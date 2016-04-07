require File.expand_path('./test/helper')

class NicoReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = NicoReader.new(SQLiteManager.new.site('nico'))
  end
end
