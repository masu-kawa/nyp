require File.expand_path('./lib/readers/channel_list_reader')
require 'capybara/poltergeist'

class AfreecatvReader < ChannelListReader
  def initialize(site)
    Capybara.javascript_driver = :poltergeist
    @s = Capybara::Session.new(:poltergeist)
    @site_id = site['id']
    @url = site['channel_list_url']
    read_page(read_url)
  end

  def next_page_exists?
    @s.find('#paging strong + a').click
    true
  rescue Capybara::ElementNotFound => e
    false
  end

  def can_read_next_page?
    true
  end

  def read_url
    @url
  end

  def read_page(url)
    @s.visit(url)
  end

  def read_rows
    @s.all('#container > .rv_list > ul > li')
  end

  def read_channel_name(row)
    row.find('.infox .time').text
  end

  def read_contact_url(row)
    row.find('.subject a')[:href]
  end

  def read_genre(row)
    '【AfreecaTV】'
  end

  def read_detail(row)
    row.find('.subject').text
  end

  def read_listener_count(row)
    row.find('.infox .viewer').text.to_i
  end

  def read_relay_count(row)
    read_listener_count(row)
  end
end
