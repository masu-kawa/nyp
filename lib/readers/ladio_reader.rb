require File.expand_path('./lib/readers/channel_list_reader')

class LadioReader < ChannelListReader
  def read_page(url)
    Nokogiri::HTML(open(url, 'r:Shift_JIS').read)
  end

  def read_rows
    @doc.text.split(/\n\n/)
  end

  def read_channel_name(row)
    name = row.match(/DJ=(.*)\n/)[1]
    if name.nil? || name.empty?
      read_detail(row)
    else
      name
    end
  end

  def read_contact_url(row)
    row.match(/SURL=(.*)\n/)[1]
  end

  def read_genre(row)
    genre = '【ねとらじ】'
    genre << row.match(/GNL=(( |.)*)\n/)[1].to_s
    genre
  end

  def read_detail(row)
    row.match(/NAM=(.*)\n/)[1].to_s
  end

  def read_listener_count(row)
    row.match(/CLN=(\d*)\n/)[1].to_i
  end

  def read_relay_count(row)
    row.match(/MAX=(\d*)\n/)[1].to_i
  end

  def read_time(row)
    elapsed_time(row.match(/TIMS=(( |.)*)\n/)[1].to_s)
  end

  def read_comment(row)
    row.match(/DESC=(( |.)*)\n/)[1].to_s
  end

  def read_file_type(row)
    case mime_type = row.match(/TYPE=(.*)\n/)[1]
    when 'audio/mpeg/' then 'MP3'
    when 'application/ogg' then 'OGG'
    when 'audio/aacp' then 'AACP'
    else 'MP3'
    end
  end

  def read_tip(row)
    host = row.match(/SRV=(.*)\n/)[1]
    port = row.match(/PRT=(.*)\n/)[1]
    account = row.match(/MNT=(.*)\n/)[1] # 先頭に/あり
    "#{host}:#{port}#{account}"
  end
end
