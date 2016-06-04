require File.expand_path('./test/helper')

class TwitchjpReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = TwitchjpReader.new(SQLiteManager.new.site('twitchjp'))
  end
end
