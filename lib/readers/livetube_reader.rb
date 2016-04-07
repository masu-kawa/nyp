require File.expand_path('./lib/readers/channel_list_reader')

class LivetubeReader < ChannelListReader
  def read_page(url)
    JSON.parse(open(url).read)
  end

  def read_rows
    @doc
  end

  def read_channel_name(row)
    row['author']
  end

  def read_contact_url(row)
    'http://livetube.cc/' << row['link']
  end

  def read_genre(row)
    '【Livetube】' << row['tags'].join(' ')
  end

  def read_detail(row)
    row['title']
  end

  def read_listener_count(row)
    row['viewing']
  end

  def read_relay_count(row)
    row['view']
  end

  def read_time(row)
    elapsed_time(row['created'])
  end
end
