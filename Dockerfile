FROM ruby:3.2.2-slim as Builder

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends build-essential\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle config set --local without 'development test' \
    && bundle install --no-cache \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

FROM ruby:3.2.2-slim

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY --from=Builder /usr/src/app/Gemfile ./Gemfile
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/

COPY . .

# Set the command to run Puma
CMD ["bundle", "exec", "puma", "-p", "$PORT"]
