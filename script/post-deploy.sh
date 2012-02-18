#!/bin/bash

# bundle our gems for deployment with binstubs, and the ruby-local-exec shebang
#
# we used to use --deployment, but it's sloooowww and can cause problems with
# deploying, oddly enough...
bundle install --quiet --binstubs --shebang ruby-local-exec

APP_DIR=/home/deploy/wtf
APP_SHARED=/home/deploy/wtf-shared

# re-symlink log dir
rm -rf "$APP_DIR/log"
ln -s "$APP_SHARED/log" "$APP_DIR/log"

# bring in external db config for password security
cp $APP_SHARED/config/database.yml config/database.yml

# better session key security
cp $APP_SHARED/session_key $APP_DIR

RAILS_ENV=production bundle exec rake assets:precompile # --trace
RAILS_ENV=production rake db:migrate

# bring in git submodules
git submodule update --init

# gracefully reload app with unicorn magic
pid=$APP_DIR/tmp/pids/unicorn.pid
test -s $pid && sudo kill -s USR2 "$(cat $pid)"

if [[ "$?" -ne "0" ]] ; then
  echo "ERROR: Failed to restart Unicorn. Pidfile likely doesn't exist." 2>&1
fi

# SRSLY THAT'S IT?
# ...yep.
