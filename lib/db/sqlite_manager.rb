require 'sqlite3'

class SQLiteManager
  attr_reader :conn

  def initialize(file_name = 'nyp.sqlite3')
    @conn = SQLite3::Database.new(file_name, results_as_hash: true)
    @conn.busy_timeout = 30000 # ms
  end

  def transaction(&block)
    @conn.transaction(mode = :immediate, &block)
  end

  def close
    @conn.close
  end

  def insert_channel(site_id:, channel_name:, contact_url:, genre:, detail:, listener_count:, relay_count:, time:, comment:, file_type:, tip:)
    @conn.execute(
      "INSERT OR IGNORE INTO channels (site_id, channel_name, contact_url, genre, detail, listener_count, relay_count, time, comment, file_type, tip) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [site_id, channel_name, contact_url, genre, detail, listener_count, relay_count, time, comment, file_type, tip]
    )
  end

  def clear_channels(site_id)
    @conn.execute('DELETE FROM channels WHERE site_id = ?', site_id)
  end

  def sites
    @conn.execute('SELECT * FROM sites')
  end

  def site(site_id)
    @conn.execute('SELECT * FROM sites WHERE id = ?', site_id).first
  end

  def channels(site_ids)
    return [] if site_ids.count <= 0

    placeholder = '?'
    (site_ids.count - 1).times do
      placeholder << ',?'
    end

    @conn.execute("SELECT * FROM channels WHERE site_id IN (#{placeholder})", site_ids)
  end

  def setup
    require 'yaml'

    @conn.execute_batch <<-EOS
      CREATE TABLE IF NOT EXISTS sites (
        id TEXT NOT NULL,
        name TEXT NOT NULL,
        url TEXT NOT NULL,
        channel_list_url TEXT NOT NULL,
        page_no INTEGER DEFAULT NULL,
        default_setting TEXT NOT NULL
      );
      CREATE UNIQUE INDEX IF NOT EXISTS idx_sites_on_id ON sites (id);

      CREATE TABLE IF NOT EXISTS channels (
        site_id TEXT,
        channel_name TEXT,
        contact_url TEXT,
        genre TEXT,
        detail TEXT,
        listener_count INTEGER,
        relay_count INTEGER,
        time TEXT,
        comment TEXT,
        file_type TEXT,
        tip TEXT
      );
      CREATE INDEX IF NOT EXISTS idx_channels_on_site_id ON channels (site_id);
      CREATE UNIQUE INDEX IF NOT EXISTS idx_channels_on_contact_url ON channels (contact_url);
    EOS

    sleep(1)

    sites = YAML.load_file(File.expand_path('./config/data.yml'))['streaming_sites']
    sites.each do |site|
      @conn.execute("INSERT OR IGNORE INTO sites (id, name, url, channel_list_url, page_no, default_setting) VALUES (?, ?, ?, ?, ?, ?)", site.values)
    end
  end
end
