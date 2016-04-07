require File.expand_path('./test/helper')

class TwicasReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = TwicasReader.new(SQLiteManager.new.site('twicas'))
  end
end
