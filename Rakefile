require 'rake/testtask'
require File.expand_path('./lib/db/sqlite_manager')
require File.expand_path('./lib/camelize')

Dir[File.expand_path('./lib/readers') << '/*.rb'].each do |reader|
  require reader
end


namespace :db do
  desc 'DBファイルの作成と初期データの登録'
  task :setup, :path do |task, args|
    db_name = 'nyp.sqlite3'
    # sqliteファイル出力先
    path = args[:path].nil? ? "." : args[:path]
    unless File.exist?("#{path}/#{db_name}")
      SQLiteManager.new("#{path}/#{db_name}").setup
    end
  end
end


desc 'チャンネルリストを取得してDBに保存'
task :crawler, :log_path do |task, args|
  begin
    # log出力設定
    log_path = args[:log_path].nil? ? "log" : args[:log_path]
    logger = Logger.new("#{log_path}/crawler.log", 2) # ファイルローテーション数

    db = SQLiteManager.new
    mutex = Mutex.new
    threads = []

    db.sites.each do |site|
      threads << Thread.new(site) do |s|
        begin
          r = Object.const_get("#{s['id'].camelize}Reader").new(s)
          channels = []

          begin
            r.read_rows.each do |row|
              channels << {
                site_id: r.site_id,
                channel_name: r.read_channel_name(row),
                contact_url: r.read_contact_url(row),
                genre: r.read_genre(row),
                detail: r.read_detail(row),
                listener_count: r.read_listener_count(row),
                relay_count: r.read_relay_count(row),
                time: r.read_time(row),
                comment: r.read_comment(row),
                file_type: r.read_file_type(row),
                tip: r.read_tip(row)
              }
            end
            puts "loading: #{r.read_url}"
          end while r.next_page_exists?

          mutex.synchronize do
            db.transaction do
              db.clear_channels(r.site_id)
              channels.each {|ch| db.insert_channel(ch)}
            end
          end
        rescue => e
          logger.error("thread_error: #{r.site_id}\n#{e.message}\n#{e.backtrace.join("\n")}\n")
        end
      end
    end
    threads.each {|t| t.join(570)} # タイムアウトは9分30秒 (ツイキャスが時間掛かる為)
  rescue => e
    logger.error("#{e.message}\n#{e.backtrace.join("\n")}\n")
  ensure
    db.close
  end
end


# unicorn
namespace :unicorn do
  desc "Start unicorn"
  task(:start) {
    config = "#{Dir.pwd}/config/unicorn.rb"
    sh "bundle exec unicorn -c #{config} -E production -D"
  }

  desc "Stop unicorn"
  task(:stop) { unicorn_signal :QUIT }

  def unicorn_signal signal
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    begin
      File.read("#{Dir.pwd}/tmp/unicorn.pid").to_i
    rescue Errno::ENOENT
      raise "Unicorn doesn't seem to be running"
    end
  end
end


# TEST
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb', 'test/readers/*_test.rb']
  t.verbose = true
end

namespace :test do
  desc 'クローラーのサイト別実行テスト'
  task :crawl, :site_id do |task, args|
    db = SQLiteManager.new('nyp_test.sqlite3')
    db.setup
    db.conn.execute('DELETE FROM channels')
    site = db.site(args[:site_id])
    fail('サイトID該当無し') if site.nil?
    r = Object.const_get("#{site['id'].camelize}Reader").new(site)

    channels = []
    begin
      r.read_rows.each do |row|
        channels << {
          site_id: r.site_id,
          channel_name: r.read_channel_name(row),
          contact_url: r.read_contact_url(row),
          genre: r.read_genre(row),
          detail: r.read_detail(row),
          listener_count: r.read_listener_count(row),
          relay_count: r.read_relay_count(row),
          time: r.read_time(row),
          comment: r.read_comment(row),
          file_type: r.read_file_type(row),
          tip: r.read_tip(row)
        }
      end
      puts "loading: #{r.read_url}"
      puts "#{channels.sample(5).map {|c| c[:channel_name]}}"
      puts
    end while r.next_page_exists?

    db.transaction do
      db.clear_channels(r.site_id)
      channels.each {|ch| db.insert_channel(ch)}
    end
    db.close
  end
end
