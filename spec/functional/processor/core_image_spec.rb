require File.expand_path('../../../start', __FILE__)

begin
  require 'osx/cocoa'
  
  describe "Miso::Processor::CoreImage" do
    it "should check the load paths to see if RubyCocoa is available" do
      Miso::Processor::CoreImage.should.be.available
      with_load_path '/tmp', '~/' do
        Miso::Processor::CoreImage.should.not.be.available
      end
    end
    
    it "should require osx/cocoa on initialization" do
      Miso::Processor::CoreImage.any_instance.expects(:require).with('osx/cocoa')
      Miso::Processor::CoreImage.new(fixture_file('120x100.png'))
    end
  end
  
  describe "An instance of Miso::Processor::CoreImage" do
    it "should write the output file with the type inflected from the extension" do
      { 'png' => 'PNG', 'jpg' => 'JPEG', 'gif' => 'GIF' }.each do |ext, type|
        Miso::Image.crop(input, output(ext), 100, 100, processor)
        file_info(output(ext)).should.include type
      end
    end
    
    it "should raise if it can't inflect the type from the extension" do
      lambda {
        Miso::Image.crop(input, output('foo'), 100, 100, processor)
      }.should.raise Miso::UnsupportedFileType
    end
    
    private
    
    def processor;   Miso::Processor::CoreImage  end
    def input;       fixture_file('120x100.png') end
    def output(ext); temp_file("temp.#{ext}")    end
  end
  
rescue LoadError
  warn "[!] Skipping Miso::Processor::CoreImage functional spec."
end