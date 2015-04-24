FROM ruby

ENV RAILS_ENV production
ENV ROOT_DIR /var/www/app

RUN mkdir -p $ROOT_DIR
WORKDIR $ROOT_DIR
# Mount volume for Nginx to serve static files from public folder
VOLUME $ROOT_DIR

# Gems
COPY Gemfile $ROOT_DIR/
COPY Gemfile.lock $ROOT_DIR/
RUN bundle install --system

# Add all files
COPY . $ROOT_DIR

# Assets
RUN bundle exec rake assets:precompile assets:clean RAILS_ENV=$RAILS_ENV --trace

COPY start-server.sh /usr/bin/start-server.sh
RUN chmod +x /usr/bin/start-server.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Secrets
ENV SECRET_KEY_BASE $SECRET_KEY_BASE

ENV DB_NAME firebot

EXPOSE 8080

CMD /usr/bin/start-server.sh
