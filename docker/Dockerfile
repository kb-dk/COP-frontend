# Development image for COP-frontend. Ruby 2.6 needs OpenSSL 1.1, so we use the
# official prebuilt Ruby image rather than compiling Ruby + OpenSSL on a newer distro.
FROM ruby:2.6.5-slim-buster

# Buster is EOL; its packages only live on archive.debian.org now.
RUN sed -i -e 's|deb.debian.org|archive.debian.org|g' \
           -e 's|security.debian.org|archive.debian.org|g' \
           -e '/buster-updates/d' /etc/apt/sources.list \
 && apt-get -o Acquire::Check-Valid-Until=false update \
 && apt-get install -y --no-install-recommends build-essential libsqlite3-dev \
 && rm -rf /var/lib/apt/lists/*

# The base image ships a newer Bundler and pins it via BUNDLER_VERSION; Gemfile.lock wants 1.17.2.
RUN gem install bundler -v 1.17.2
ENV BUNDLER_VERSION=1.17.2 \
    DISABLE_SPRING=1

# Match the host user so files written into the bind mount aren't root-owned.
ARG UID=1000
ARG GID=1000
RUN groupadd -g "$GID" app && useradd -m -u "$UID" -g "$GID" app

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4

COPY --chown=app:app . .

USER app
EXPOSE 3000
ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
