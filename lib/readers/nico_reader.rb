# common  一般
# try やってみた
# live  ゲーム
# req 動画紹介
# r18 R-18
# face  顔出し
# totu  凸待ち

require File.expand_path('./lib/readers/channel_list_reader')

class NicoReader < ChannelListReader
  PageTab = ['common', 'try', 'live', 'req', 'r18', 'face', 'totu',]

  def initialize(site)
    @initial_page_no = site['page_no']
    @current_tab = PageTab.first
    @current_tab_no = 0
    super
  end

  def next_page_exists?
    @page_no += 1
    @doc = read_page(read_url)

    if read_rows.empty?
      @current_tab_no +=1
      if @current_tab_no > (PageTab.count - 1)
        false
      else
        @page_no = @initial_page_no
        @current_tab = PageTab[@current_tab_no]
        true
      end
    else
      true
    end
  end

  def read_url
    "#{@url}#{@page_no}&tab=#{@current_tab}"
  end

  def read_page(url)
    sleep(1)
    Nokogiri::XML(open(url))
  end

  def read_rows
    @doc.css('item')
  end

  def read_channel_name(row)
    row.xpath('nicolive:community_name').text + '/' + row.xpath('nicolive:owner_name').text
  end

  def read_contact_url(row)
    row.css('link').text
  end

  def read_genre(row)
    genre = '【ニコ生】'
    row.css('category').each_with_index do |c, i|
      genre << ' ' if i > 0
      genre << c.text
    end
    genre << ' コミュ限' if row.xpath('nicolive:member_only').text == 'true'
    genre
  end

  def read_detail(row)
    row.css('title').text
  end

  # 10分あたりの平均コメ数を返す
  def read_listener_count(row)
    elapsed_minutes = (Time.now - Time.parse(row.css('pubDate').text)) / 60
    comment_count = row.xpath('nicolive:num_res').text.to_i
    (comment_count / (elapsed_minutes / 10)).to_i
  rescue ZeroDivisionError
    0
  end

  def read_relay_count(row)
    row.xpath('nicolive:view').text.to_i
  end

  def read_time(row)
    elapsed_time(row.css('pubDate').text)
  end

  def read_comment(row)
    text = row.css('description').text.gsub(/\s/, '')
    text.size > 60 ? "#{text[0..59]}…" : text
  end
end
