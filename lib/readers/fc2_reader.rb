require File.expand_path('./lib/readers/channel_list_reader')

class Fc2Reader < ChannelListReader
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
    'http://live.fc2.com/' << row['id']
  end

  def read_genre(row)
    genre = '【FC2】'
    genre << '有料' if row['pay'] == 1
    if row['type'] == 2
      genre << ' ' if row['pay'] == 1
      genre << '2shot'
    end
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
  rescue
    '00:00'
  end
end
