require File.expand_path('./test/helper')

class LadioReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = LadioReader.new(SQLiteManager.new.site('ladio'))
  end
end
