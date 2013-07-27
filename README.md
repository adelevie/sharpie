[![Gem Version](https://badge.fury.io/rb/sharpie.png)](http://badge.fury.io/rb/sharpie)

[![Code Climate](https://codeclimate.com/github/adelevie/sharpie.png)](https://codeclimate.com/github/adelevie/sharpie)

[![Build Status](https://travis-ci.org/adelevie/sharpie.png)](https://travis-ci.org/adelevie/sharpie)


# Sharpie

Quick and easy static site generation with a familiar API.

## Usage

```ruby
class App < Sharpie::Base
  
  get "/" do
    "Hello, world."
  end

  # get posts from ActiveRecord or elsewhere
  def self.posts
    Post.all
  end

  posts.each do |post|
    get "/posts/#{post.id}" do
      erb :post
    end

    get "/posts/#{post.id}.json" do
      post.to_json
    end
  end

end


App.build!("_site")
```

Or use with an existing Sinatra application:

```ruby
class App < Sinatra::Base
  register Sinatra::AdvancedRoutes # this is required

  def self.posts
    Post.all
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

builder = Sharpie::Builder.new(App)
builder.build!("_site")
```

`Sharpie::Base` subclasses from `Sinatra::Base`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sharpie'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install sharpie
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Why 

Sinatra routes make web app and API creation dead-simple. The syntax is straightforward and allows for your site to feel more like Ruby and less like a bloated framework. And there's also no reason why this powerful API should be limited to dynamic web applications. Sinatra routes simply describe a path and a response. Whether the response is evaluated ahead of time or on fly should not matter.

### Why not Jekyll?

Jekyll is great for blogs and other types of sites where content is "hand created." That is, a human creates a file in a folder and writes some Markdown. Sharpie is more geared towards use-cases where the original content is already in a machine-readable format. For example, if you have a set of 1000s of JSON files that you want to expose via REST API. With Sharpie, you can write such an API with very few (yet straightfoward) lines of code.

### Fork

This software is mostly a fork of the [sinatra-static](https://github.com/paulasmuth/sinatra-static) gem by [Paul Asmuth](https://twitter.com/paulasmuth). Paul's code is very well-written. I'd rather copy and attribute it than re-invent a well-made wheel. I'm focusing on building an interface that suits my needs. More specifically, I want Sharpie to be part of a toolchain for rapidly developing static file-backed REST APIs.

# License

This software, which is a fork of MIT-licensed software, is also MIT-licensed. See `LICENSE.txt`.
