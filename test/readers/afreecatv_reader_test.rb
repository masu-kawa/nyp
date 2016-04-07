require File.expand_path('./test/helper')

class AfreecatvReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = AfreecatvReader.new(SQLiteManager.new.site('afreecatv'))
  end
end
