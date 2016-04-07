# 制限:1キー毎にアクセス5000回/日
# http://api.ustream.tv/json/channel/live/search/all?limit=100
# http://api.ustream.tv/json/channel/live/search/rating:gt:0.0001
# http://api.ustream.tv/json/stream/popular/search/all?limit=100

require File.expand_path('./lib/readers/channel_list_reader')

class UstReader < ChannelListReader
  def initialize(channel)
    # @api_key = ENV['NYP_API_KEY_USTREAM']
    @api_key = '5704A3C4FA188E25354E3D92951CBC3B'
    super
  end

  def read_url
    "#{@url}&key=#{@api_key}&page=#{@page_no}"
  end

  def read_page(url)
    sleep(1)
    JSON.parse(open(url).read)
  end

  def read_rows
    @doc['results'] != nil ? @doc['results'] : []
  end

  def read_channel_name(row)
    row['title']
  end

  def read_contact_url(row)
    row['url']
  end

  def read_genre(row)
    '【Ust】'
  end

  def read_detail(row)
    text = row['description'].to_s.gsub(/(\r\n|\r|\n)/, ' ')
    text.size > 60 ? "#{text[0..59]}…" : text
  end

  def read_listener_count(row)
    row['viewersNow'].to_i
  end

  def read_relay_count(row)
    read_listener_count(row)
  end

  def read_time(row)
    if row['lastStreamedAt'].nil?
      '00:00'
    else
      elapsed_time(row['lastStreamedAt'])
    end
  end
end
