source 'http://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'pg', :group => [:production]

# Auth
gem 'cancan'
gem "bartt-ssl_requirement", :require => "ssl_requirement"

# Helper for nested pages
gem 'ancestry'

# Settings
gem 'settingslogic'

# Auth
gem 'net-ldap'

# Deploy
gem 'highline'
gem 'sshkit'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
  gem "font-awesome-rails"
  gem 'bootstrap-sass-rails', "~>2.3"
end

group :production do
  gem 'libv8'
  gem 'therubyracer', '>= 0.11.1', :require => 'v8'
  gem 'unicorn'
end
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

# More asset stuff
gem 'jquery-rails'

# Add support for eco templates
gem 'sprockets'
gem 'eco'

# app/uploaders/image_uploader.rb depends on carrierwave 
# TODO: See if we still allow image uploads on events submission page
# And if we do, do they still work?
gem 'carrierwave'

# iCal support
gem 'ri_cal'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
