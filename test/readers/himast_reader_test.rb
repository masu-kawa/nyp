require File.expand_path('./test/helper')

class HimastReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = HimastReader.new(SQLiteManager.new.site('himast'))
  end
end
