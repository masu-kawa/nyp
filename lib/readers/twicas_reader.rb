# 制限: 最大1分間に60回。この制約を超えるとそのIPアドレスからは5分間アクセスできなくなります
# データの重複多い
# 最初の100ページくらい取得して残りは止めた方がいいかもしれない
# 取得順とか無い

require File.expand_path('./lib/readers/channel_list_reader')

class TwicasReader < ChannelListReader
  # TODO: 180ページ(秒)以上ならクロール終了
  def next_page_exists?
    if @page_no >= 180
      false
    else
      super
    end
  end

  def read_page(url)
    sleep(1)
    JSON.parse(open(url).read)
  end

  def read_rows
    @doc
  end

  def read_channel_name(row)
    row['userid']
  end

  def read_contact_url(row)
    row['link']
  end

  def read_genre(row)
    '【Twicas】'
  end

  def read_detail(row)
    row['localized_title']
  end

  def read_listener_count(row)
    row['viewers'].to_i # viewers 10人以上の場合表示される
  end

  def read_relay_count(row)
    read_listener_count(row)
  end

  def read_time(row)
    min = row['duration'].to_i / 60
    sprintf('%02d', (min / 60)) + ':' + sprintf('%02d', (min % 60))
  end

  def read_comment(row)
    row['comment']
  end
end
