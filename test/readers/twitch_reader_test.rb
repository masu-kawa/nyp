require File.expand_path('./test/helper')

class TwitchReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = TwitchReader.new(SQLiteManager.new.site('twitchjp'))
  end
end
