require 'sinatra/base'
require 'sinatra/reloader'
require File.expand_path('./lib/db/sqlite_manager')

class NYP < Sinatra::Base
  SITE_NAME = 'ニコ生などの配信サイトをYP表示' unless defined?(SITE_NAME)
  SITE_LIST = ['nico', 'nico_official', 'twicas', 'fc2', 'fc2_adult', 'youtube', 'himast', 'livetube', 'ladio', 'ust', 'afreecatv', 'twitchjp'] unless defined?(SITE_LIST)

  configure :development do
    register Sinatra::Reloader
  end

  before do
    @db = SQLiteManager.new
  end

  after do
    @db.close
  end

  # get(SITE_LIST.inject('') {|p, s| p << '/:' << s} << '/*.*') do
  get '/:nico/:nico_official/:twicas/:fc2/:fc2_adult/:youtube/:himast/:livetube/:ladio/:ust/:afreecatv/:twitchjp/index.txt', provides: 'txt' do
    site_ids = []
    SITE_LIST.each do |site_name|
      # x以外の文字にマッチ
      if !params[site_name].nil? && params[site_name] =~ /\A(?:0|1|[+-DX][1-9]\d{0,6})\z/
        site_ids << site_name
      end
    end
    erb :index, layout: false, locals: { channels: @db.channels(site_ids) }
  end

  get '/' do
    erb :top, locals: { sites: @db.sites }
  end

  get '/guide' do
    erb :guide
  end

  get '/*' do
    # file_type無いとpcyp表示されない
    error_message = ["channel_name" => "ERROR", "detail" => "ERROR", "contact_url" => "http://nyp.orz.hm:25780/", "file_type" => "WMV"]
    erb :index, layout: false, locals: { channels: error_message }
  end


  helpers do
    def listener_count_by_setting_value(count, val)
      if val == '0'
        0
      elsif val == '1'
        count
      elsif val =~ /\A([+-DX])([1-9]\d{0,6})\z/
        cond_operator = Regexp.last_match[1]
        cond_num = Regexp.last_match[2].to_i

        case cond_operator
        when '+' then count + cond_num
        when '-' then count - cond_num
        when 'X' then count * cond_num
        when 'D' then count / cond_num
        end
      end
    end

    def setting_x?(site)
      site['default_setting'] == 'x'
    end

    def setting_0?(site)
      site['default_setting'] == '0'
    end

    def setting_1?(site)
      site['default_setting'] == '1'
    end
  end
end


__END__

Peercast index.txt
配信チャンネル名<>00000000000000000000000000000000<><>URL<>ジャンル<>詳細<>視聴者数<>リレー数<>0<>WMV<><><><><><>配信時間<>click<>配信者からのコメント<>0

リクエストURL例
http://localhost:4567/1/0/0/0/0/0/0/0/index.txt?host=localhost:7144

環境変数
ENV['NYP_API_KEY_USTREAM']
ENV['NYP_API_KEY_YOUTUBE']


# お知らせ用
ニコ生などの配信サイトをYP表示<>00000000000000000000000000000000<><>http://nyp.orz.hm:25780<>【お知らせ】<>twich(日本語のみ)に対応しました。お手数ですがURLの変更をお願いします<>9999999<>9999999<>0<>WMV<><><><><><>00:00<>click<><>0
