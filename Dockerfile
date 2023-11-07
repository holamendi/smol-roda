FROM ruby:3.2.2-alpine as Builder

RUN apk add --no-cache --virtual .build-deps build-base git \
    && apk add --no-cache tzdata \
    && gem update bundler

ENV BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH=/bundle \
    GEM_HOME=/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config set without 'development test' \
    && bundle install --retry 3 --jobs 4 \
    && apk del .build-deps

COPY . .

RUN rm -rf spec tmp log

FROM ruby:3.2.2-alpine

RUN apk add --no-cache tzdata

COPY --from=Builder /bundle /usr/local/bundle
COPY --from=Builder /app /app

WORKDIR /app
ENV PATH /usr/local/bundle/bin:$PATH
ENV RACK_ENV=production

EXPOSE 9292

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
