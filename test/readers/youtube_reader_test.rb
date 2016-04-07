require File.expand_path('./test/helper')

class YoutubeReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = YoutubeReader.new(SQLiteManager.new.site('youtube'))
  end
end
