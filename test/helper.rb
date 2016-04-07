require 'test/unit'
require File.expand_path('./lib/db/sqlite_manager')

Dir[File.expand_path('./lib/readers') << '/*.rb'].each do |reader|
  require reader
end

module CannelListMethodsTest
  def test_channel_list_methods
    assert_can_read_next_page
    assert_read_url
    assert_read_page
    assert_read_rows
    @r.read_rows.each do |row|
      assert_channel_name(row)
      assert_contact_url(row)
      assert_genre(row)
      assert_detail(row)
      assert_listener_count(row)
      assert_relay_count(row)
      assert_time(row)
      assert_comment(row)
    end
    assert_next_page_exists
  end

  def assert_next_page_exists
    assert_include [true, false], @r.next_page_exists?
  end

  def assert_can_read_next_page
    assert_include [true, false], @r.can_read_next_page?
  end

  def assert_read_url
    assert_match /https?:\/\/\S+/, @r.read_url
  end

  def assert_read_page
    assert_not_nil @r.read_page(@r.read_url)
  end

  def assert_read_rows
    assert_kind_of Enumerable, @r.read_rows
  end

  def assert_channel_name(row)
    assert_kind_of String, @r.read_channel_name(row)
  end

  def assert_contact_url(row)
    assert_match /https?:\/\/\S+/, @r.read_contact_url(row)
  end

  def assert_genre(row)
    assert_kind_of String, @r.read_genre(row)
  end

  def assert_detail(row)
    assert_kind_of String, @r.read_detail(row)
  end

  def assert_listener_count(row)
    assert_kind_of Integer, @r.read_listener_count(row)
  end

  def assert_relay_count(row)
    assert_kind_of Integer, @r.read_relay_count(row)
  end

  def assert_time(row)
    assert_match /^\d+\d:\d\d$/, @r.read_time(row)
  end

  def assert_comment(row)
    assert_kind_of String, @r.read_comment(row)
  end
end
