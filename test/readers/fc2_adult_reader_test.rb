require File.expand_path('./test/helper')

class Fc2AdultReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = Fc2AdultReader.new(SQLiteManager.new.site('fc2_adult'))
  end
end
