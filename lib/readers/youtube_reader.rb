# searchだとliveの視聴者数や開始時間が取得出来ないので一度list取得してから次にvideo情報を取得する必要がある
# eventType=upcomingは数が多すぎるので取得しない
# 10ページまでしか取得出来ない？

require File.expand_path('./lib/readers/channel_list_reader')

class YoutubeReader < ChannelListReader
  def initialize(site)
    # @api_key = ENV['NYP_API_KEY_YOUTUBE']
    @api_key = 'AIzaSyDBNKukz62eO0bwuAeceRb8E6mBvpcl9H8'
    @page_token = ''
    @site_id = site['id']
    @url = site['channel_list_url']
    @doc = read_page(read_url)
    @live_info_doc = read_page(live_info_url(video_ids))
  end

  def next_page_exists?
    if @doc['nextPageToken'].nil?
      false
    else
      @page_token = @doc['nextPageToken']
      @doc = read_page(read_url)
      @live_info_doc = read_page(live_info_url(video_ids))

      ! read_rows.nil?
    end
  end

  def read_url
    "#{@url}&key=#{@api_key}&pageToken=#{@page_token}"
  end

  def read_page(url)
    sleep(1)
    JSON.parse(open(url).read)
  end

  def read_rows
    @doc['items']
  end

  def read_channel_name(row)
    title = row['snippet']['channelTitle'] # string 空多い
    title << ':' unless title.empty?
    title << row['snippet']['title'] # 必須っぽい
  end

  def read_contact_url(row)
    'https://youtu.be/' << video_id(row)
  end

  def read_genre(row)
    '【Youtube】'
  end

  def read_detail(row)
    row['snippet']['description']
  end

  def read_listener_count(row)
    ch_live_info(video_id(row))['liveStreamingDetails']['concurrentViewers'].to_i
  rescue
    0
  end

  def read_relay_count(row)
    read_listener_count(row)
  end

  def read_time(row)
    info = ch_live_info(video_id(row))
    if info['liveStreamingDetails'].nil?
      '00:00'
    else
      elapsed_time(info['liveStreamingDetails']['actualStartTime'])
    end
  end

  def video_id(row)
    row['id']['videoId']
  end

  def video_ids
    read_rows.map {|row| video_id(row)}.join(',')
  end

  def live_info_url(video_ids)
    "https://www.googleapis.com/youtube/v3/videos?part=liveStreamingDetails&maxResults=50&key=#{@api_key}&id=#{video_ids}"
  end

  def ch_live_info(video_id)
    @live_info_doc['items'].each do |item|
      return item if item['id'] == video_id
    end
    return {}
  end
end
