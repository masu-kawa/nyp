require File.expand_path('./test/helper')

class UstReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = UstReader.new(SQLiteManager.new.site('ust'))
  end
end
