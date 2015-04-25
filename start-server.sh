#!/bin/bash -x
cd $ROOT_DIR
bundle exec unicorn -E $RAILS_ENV -p $PORT -c config/unicorn.rb
