require 'rubygems' rescue LoadError
require 'test/spec'
require 'mocha'

require 'fileutils'

$:.unshift(File.expand_path('../../lib', __FILE__))

require 'miso'
require 'miso/processor'
require 'miso/processor/core_image'
require 'miso/processor/image_magick'

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
  
  def with_load_path(*load_path)
    before = $:.dup
    $:.replace load_path
    yield
  ensure
    $:.replace before
  end
  
  def file_info(path)
    `/usr/bin/env file '#{path}'`.split(':').last.strip
  end
end