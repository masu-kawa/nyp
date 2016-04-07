# こっちのURLで放送予定の番組情報取得できるけど視聴者数ないので使わない
# http://live.nicovideo.jp/rss

require File.expand_path('./lib/readers/channel_list_reader')

class NicoOfficialReader < ChannelListReader
  def read_rows
    @doc.css('#rank .active .detail')
  end

  def read_channel_name(row)
    row.css('p a').text.slice(0, 10)
  end

  def read_contact_url(row)
    'http://live.nicovideo.jp/' << row.css('p a')[0][:href]
  end

  def read_genre(row)
    '【ニコ生公式】'
  end

  def read_detail(row)
    row.css('p a').text
  end

  # 10分あたりの平均コメ数を返す
  def read_listener_count(row)
    hour, min = read_elapsed_hour_and_min(row)
    elapsed_minutes = (hour.to_i * 60) + min.to_i
    comment_count = row.css('.count .coment').text.gsub!(/\s|,/, '').to_i
    (comment_count / (elapsed_minutes / 10)).to_i
  rescue ZeroDivisionError
    0
  end

  def read_relay_count(row)
    row.css('.count .audience').text.gsub!(/\s|,/, '').to_i
  end

  def read_time(row)
    hour, min = read_elapsed_hour_and_min(row)
    sprintf('%02d', hour) + ':' + sprintf('%02d', min)
  end

  def read_elapsed_hour_and_min(row)
    unless @hour && @min
      time = row.css('.time').text
      if time.include?('時間')
        time = time.split('時間')
        @hour = time[0]
        @min = time[1].sub('分', '')
      else
        @hour = '00'
        @min = time.sub('分', '')
      end
    end
    return @hour, @min
  end
end
