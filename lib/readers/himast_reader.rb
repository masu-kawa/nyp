require File.expand_path('./lib/readers/channel_list_reader')

class HimastReader < ChannelListReader
  def read_page(url)
    sleep(0.5)
    Nokogiri::XML(open(url))
  end

  def read_rows
    @doc.css('item')
  end

  def read_channel_name(row)
    row.css('description').text.match(/配信者:<b>(.*)<\/b>/)[1]
  end

  def read_contact_url(row)
    row.css('link').text
  end

  def read_genre(row)
    '【ひまスト】'
  end

  def read_detail(row)
    row.css('title').text
  end

  def read_listener_count(row)
    row.css('description').text.match(/視聴者数:<b>(\d*)<\/b>/)[1].to_i
  end

  def read_relay_count(row)
    row.css('description').text.match(/延べ入場者数：<b>(\d*)<\/b>/)[1].to_i
  end

  def read_time(row)
    elapsed_time(row.css('pubDate').text)
  end

  def read_comment(row)
    row.css('description').text.gsub!(/\s|<br(\s\/)?>/, ' ').match(/配信者:<b>.*<\/b>([\s\w\W]*)/)[1].strip
  rescue
    'コメントエラー'
  end
end
