require File.expand_path('./test/helper')

class NicoOfficialReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = NicoOfficialReader.new(SQLiteManager.new.site('nico_official'))
  end
end
