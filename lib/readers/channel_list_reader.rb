require 'open-uri'
require 'nokogiri'
require 'json'
require 'time'

class ChannelListReader
  attr_reader :site_id

  def initialize(site)
    @site_id = site['id']
    @url = site['channel_list_url']
    @page_no = site['page_no'] # int or nil
    @doc = read_page(read_url)
  end

  def next_page_exists?
    if can_read_next_page?
      @page_no += 1
      @doc = read_page(read_url)

      ! read_rows.empty?
    else
      false
    end
  end

  def can_read_next_page?
    ! @page_no.nil?
  end

  def read_url
    if can_read_next_page?
      "#{@url}#{@page_no}"
    else
      @url
    end
  end

  def read_page(url)
    Nokogiri::HTML(open(url))
  end

  def read_rows
    []
  end

  def read_channel_name(row)
    ''
  end

  def read_contact_url(row)
    'http://example.com'
  end

  def read_genre(row)
    ''
  end

  def read_detail(row)
    ''
  end

  def read_listener_count(row)
    0
  end

  def read_relay_count(row)
    0
  end

  def read_time(row)
    '00:00'
  end

  def read_comment(row)
    ''
  end

  def read_file_type(row)
    'WMV'
  end

  def read_tip(row)
    ''
  end

  def elapsed_time(start_time)
    min = (Time.now - Time.parse(start_time)).floor / 60 # 経過時間
    sprintf('%02d', (min / 60)) + ':' + sprintf('%02d', (min % 60))
  end
end
