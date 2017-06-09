require 'bundler'
Bundler.require

require './MySlackBot'
run Sinatra::Application
