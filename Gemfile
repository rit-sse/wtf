source 'http://rubygems.org'

gem 'rails', '3.2.15'

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
  gem 'whiskey_disk'
end

# More asset stuff
gem 'jquery-rails'
gem 'ace-rails-ap'

# Presentation
gem 'redcarpet'

# Testing
gem 'cucumber-rails', :group => [:test]
gem 'capybara', :group => [:development, :test]
gem 'rspec-rails', :group => [:development, :test]
gem 'factory_girl_rails', :group => [:development, :test]

# Let's hit up Amazon S3
gem 'carrierwave'
gem 'fog'

# iCal support
gem 'ri_cal'

# session
gem 'redis-session-store'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
