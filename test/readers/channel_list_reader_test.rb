require File.expand_path('./test/helper')

class ChannelListReaderTest < Test::Unit::TestCase
  include CannelListMethodsTest

  def setup
    @r = ChannelListReader.new('channel_list_url' => 'http://example.com')
  end
end
