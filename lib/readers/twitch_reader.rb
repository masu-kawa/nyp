require File.expand_path('./lib/readers/channel_list_reader')

class TwitchReader < ChannelListReader

  def next_page_exists?
    if can_read_next_page?
      @page_no += 100 # offset
      @doc = read_page(read_url)

      ! read_rows.empty?
    else
      false
    end
  end

  def read_page(url)
    JSON.parse(open(url).read)
  end

  def read_rows
    @doc['streams']
  end

  def read_channel_name(row)
    row['channel']['name']
  end

  def read_contact_url(row)
    row['channel']['url']
  end

  def read_genre(row)
    "【Twitch(#{row['channel']['language']})】" + row['game'].to_s # game title
  end

  def read_detail(row)
    row['channel']['status'].to_s
  end

  def read_listener_count(row)
    row['viewers']
  end

  def read_relay_count(row)
    row['viewers']
  end

  def read_time(row)
    elapsed_time(row['created_at'])
  end

  def read_comment(row)
    "フォロワー数: #{row['channel']['followers']} 合計閲覧数: #{row['channel']['views']} 平均FPS: #{row['average_fps']} 遅延: #{row['delay']}"
  end
end
