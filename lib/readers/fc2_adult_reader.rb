require File.expand_path('./lib/readers/channel_list_reader')

class Fc2AdultReader < ChannelListReader
  def read_page(url)
    JSON.parse(open(url).read)
  end

  def read_rows
    @doc['channel']
  end

  def read_channel_name(row)
    row['name']
  end

  def read_contact_url(row)
    'http://live.fc2.com/adult/' << row['id']
  end

  def read_genre(row)
    genre = '【FC2】18x'
    genre << ' 有料' if row['pay'] == 1
    genre << ' 2shot' if row['type'] == 2
    genre
  end

  def read_detail(row)
    row['title']
  end

  def read_listener_count(row)
    row['count'].to_i
  end

  def read_relay_count(row)
    row['total'].to_i
  end

  def read_time(row)
    elapsed_time(row['start'])
  end
end
