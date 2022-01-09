FROM ruby:3.1.0

# set up contact person for our project
LABEL maintainer='martins.kruze@gmail.com'

# remove all downloaded lists with rm -rf /var/lib/apt/lists/*
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends apt-utils postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# make application direcory
RUN mkdir /rails_7

# change working direcotry to it
WORKDIR /rails_7

# copy Gemfile and Gemfile.lock to our working direcotory
COPY Gemfile* /rails_7/

# install gems
RUN bundle install

# copy our project
COPY . /rails_7

# script that removes tmp/pids/server.pid file if it exists (need ensure it is executable with chmod +x docker-entrypoint.sh)
ENTRYPOINT ["./docker-entrypoint.sh"]
