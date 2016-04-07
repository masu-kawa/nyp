require File.expand_path('./test/helper')

class Fc2ReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = Fc2Reader.new(SQLiteManager.new.site('fc2'))
  end
end
