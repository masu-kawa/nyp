ENV['RACK_ENV'] = 'test'

require File.expand_path('app.rb')
require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    NYP # Sinatra::Application
  end

  def test_top_page
    get '/'
    assert last_response.body.include?("<h1>ニコ生などの配信サイトをYP表示</h1>")
  end

  def test_list_page
    get '/0/0/0/0/0/0/0/0/0/0/0/index.txt'
    assert last_response.ok?
  end

  def test_404_page
    get '/abc/def/index.txt'
    assert last_response.body.include?("ERROR")
  end
end
