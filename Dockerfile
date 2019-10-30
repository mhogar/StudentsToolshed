FROM ruby:2.6.1-alpine

# install dependencies
RUN apk add --update \
    build-base \
    postgresql-dev \
    yarn \
    tzdata \
    && rm -rf /var/cache/apk/*

# update bundler
RUN gem install bundler

# set working directory
ENV APP_PATH /app/
WORKDIR ${APP_PATH}

# copy the node.js files and install modules
COPY package.json yarn.lock ${APP_PATH}
RUN yarn install

# copy the gem files and install gems
COPY Gemfile Gemfile.lock ${APP_PATH}
RUN bundle install --without production

# copy the rest of the application and run the last setup commands
COPY . ${APP_PATH}
#RUN rails db:migrate

# expose the port for the app
EXPOSE 3000

# run this command before all other commands
ENTRYPOINT ["bundle", "exec"]

# run the server
CMD ["rails", "server", "-b", "0.0.0.0"]
