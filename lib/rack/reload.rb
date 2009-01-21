require 'rubygems'
require 'rack'
module Rack
  class Reload
    
    def initialize(app, *reloadable)
      @app = app
      @reloadable = reloadable
    end

    def call(env)
      @reloadable.each { |mod| mod.reload }
      @app.call(env)
    end
    
  end
end