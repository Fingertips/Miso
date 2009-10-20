require 'rubygems' rescue LoadError
require 'test/spec'
require 'mocha'

require 'fileutils'

$:.unshift(File.expand_path('../../lib', __FILE__))

require 'miso'
require 'miso/processor'

class Test::Unit::TestCase
  TMP_DIR = File.expand_path('../tmp', __FILE__)
  
  def setup
    FileUtils.mkdir_p(TMP_DIR)
  end
  
  def teardown
    FileUtils.rm_rf(TMP_DIR)
  end
  
  def fixture_file(name)
    File.expand_path("../fixtures/#{name}", __FILE__)
  end
  
  def temp_file(filename)
    File.join(TMP_DIR, filename)
  end
end