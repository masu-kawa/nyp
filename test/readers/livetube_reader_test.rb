require File.expand_path('./test/helper')

class LivetubeReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = LivetubeReader.new(SQLiteManager.new.site('livetube'))
  end
end
