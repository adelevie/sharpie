require "helper"

class TestBuild < MiniTest::Unit::TestCase

  def setup
    FileUtils.rm_rf("test/sites/test_app")
    FileUtils.rm_rf("test/sites/test_sharpie_app")
  end

  def teardown
    FileUtils.rm_rf("test/sites/test_app")
    FileUtils.rm_rf("test/sites/test_sharpie_app")
  end

  def test_build
    path = "test/sites/test_app"
    sharpie = Sharpie::Builder.new(TestApp)
    sharpie.build!(path)

    contents = []
    Dir.foreach(path) do |item|
      next if item == "." or item == ".."
      contents << item
    end

    assert_equal true, contents.include?("posts")
    assert_equal true, contents.include?("index.html")

    first_post = File.open("#{path}/posts/1.json").read
    assert_equal String, first_post.class

    parsed_first_post = JSON.parse(first_post)
    assert_equal String, parsed_first_post["title"].class
    assert_equal String, parsed_first_post["body"].class
  end

  def test_build_sharpie_app
    path = "test/sites/test_sharpie_app"
    TestSharpieApp.build!(path)

    contents = []
    Dir.foreach(path) do |item|
      next if item == "." or item == ".."
      contents << item
    end

    assert_equal true, contents.include?("numbers")
    assert_equal true, contents.include?("index.html")

    10.times do |i|
      parsed_page = JSON.parse(File.open("#{path}/numbers/#{i}.json").read)
      assert_equal i, parsed_page["number"]
    end
  end

end