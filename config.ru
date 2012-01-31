# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require ::File.expand_path('../pinocchio/app', __FILE__)

run Wtf::Application
