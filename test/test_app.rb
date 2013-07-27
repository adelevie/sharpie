require "bundler/setup"
require "sinatra/base"
require "sinatra/advanced_routes"
require "json"

class TestApp < Sinatra::Base
  register Sinatra::AdvancedRoutes

  def self.posts
    [
      {
        "id" => 1,
        "title" => "Hello, world",
        "body" => "Sinatra routes + static html = win"
      },
      {
        "id" => 2,
        "title" => "Second Post",
        "body" => "Why not?"
      }
    ]
  end

  posts.each do |post|
    get "/posts/#{post['id']}.json" do
      post.to_json
    end
  end

  get "/" do
    erb :index
  end
end