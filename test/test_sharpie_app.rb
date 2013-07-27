require "bundler/setup"
require "sharpie"
require "json"

class TestSharpieApp < Sharpie::Base
  get "/" do
    "<html><body><p>Welcome to the index.</p></body></html>"
  end

  10.times do |i|
    get "/numbers/#{i}.json" do
      {
        "number" => i
      }.to_json
    end
  end
end