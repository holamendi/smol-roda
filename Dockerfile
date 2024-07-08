FROM ruby:3.3.3-alpine AS builder

ENV RACK_ENV=production

RUN apk add --no-cache build-base

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock .ruby-version ./

RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3 && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

FROM ruby:3.3.3-alpine

ENV RACK_ENV=production

RUN apk add --no-cache tzdata && \
    addgroup -S deploy && adduser -S deploy -G deploy

WORKDIR /usr/src/app

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY --chown=deploy:deploy . .

USER deploy

# EXPOSE 3000

CMD ["bundle", "exec", "puma"]
