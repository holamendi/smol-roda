# Start with a builder stage to install gems
FROM ruby:3.2.2-slim as Builder

# Install necessary packages to build native extension gems
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends build-essential\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

# Install gems, ignoring the development and test groups
RUN bundle config set --local without 'development test' \
    && bundle install --no-cache \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# Now, build the final, production image
FROM ruby:3.2.2-slim

# Install runtime dependencies
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Copy the Gemfile and installed gems from the builder stage
COPY --from=Builder /usr/src/app/Gemfile ./Gemfile
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/

# Copy the application code
COPY . .

EXPOSE 9292

# Set the command to run Puma
CMD ["bundle", "exec", "puma"]
