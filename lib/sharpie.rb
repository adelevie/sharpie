require "sharpie/version"
require "bundler/setup"
require "sinatra"
require "sinatra/advanced_routes"
require "rack/test"

module Sharpie

  class Base < Sinatra::Base
    register Sinatra::AdvancedRoutes

    def self.build!(path)
      builder = Sharpie::Builder.new(self)
      builder.build!(path)
    end
  end

  class ColorString < String
    include Term::ANSIColor
  end

  class Builder
    attr_accessor :app
    include Rack::Test::Methods

    @@file_extensions = %w(css js xml json html csv)

    def initialize(sinatra_application)
      @app = sinatra_application
    end

    def build!(dir)
      handle_error_no_each_route! unless @app.respond_to?(:each_route)
      #handle_error_dir_not_found!(dir) unless dir_exists?(dir)
      build_routes(dir)
    end

    private

    def build_routes(dir)
      @app.each_route do |route|     
        next unless route.verb == "GET"     
        build_path(route.path, dir)
      end 
    end

    def build_path(path, dir)
      FileUtils.mkdir_p(dir_for_path(path, dir))
      File.open(file_for_path(path, dir), "w+") do |f|
        f.write(get_path(path).body)
      end
    end

    def get_path(path)
      self.get(path).tap do |resp|      
        unless resp.status == 200
          binding.pry
          handle_error_non_200!(path)
        end        
      end
    end

    def file_extensions
      @@file_extensions
    end

    def file_for_path(path, dir)
      if path.match(/[^\/\.]+.(#{file_extensions.join("|")})$/)
        File.join(dir, path)
      else
        File.join(dir, path, "index.html")
      end
    end

    def dir_for_path(path, dir)
      file_for_path(path, dir).match(/(.*)\/[^\/]+$/)[1]  
    end

    def dir_exists?(dir)
      File.exists?(dir) && ::File.directory?(dir)
    end

    def handle_error_non_200!(path)
      handle_error!("GET #{path} returned non-200 status code...")
    end

    def handle_error_no_each_route!
      handle_error!("can't call app.each_route, did you include sinatra-advanced-routes?")
    end

    def handle_error!(desc)    
      raise "Sharpie error: #{desc}"
    end
  end

end