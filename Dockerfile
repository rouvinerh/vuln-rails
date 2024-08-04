ARG RUBY_VERSION=3.0.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# done for webpacker:install since an outdated version is used intentionally
ENV TENANT1=${TENANT1}
ENV TENANT2=${TENANT2}
ENV HOST=${HOST}

WORKDIR /rails
FROM base as build
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev npm curl build-essential git libvips pkg-config npm

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

RUN npm install --global yarn

COPY Gemfile /rails/Gemfile
COPY Gemfile.lock /rails/Gemfile.lock
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY . .

RUN bundle exec bootsnap precompile app/ lib/

RUN bundle exec rails webpacker:install

COPY entrypoint.sh /rails/entrypoint.sh
RUN chmod +x /rails/entrypoint.sh
ENTRYPOINT ["/rails/entrypoint.sh"]

RUN useradd rails --create-home --shell /bin/bash
RUN chown -R rails:rails .
USER rails:rails

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]