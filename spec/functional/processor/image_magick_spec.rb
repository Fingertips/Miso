require File.expand_path('../../../start', __FILE__)

if system("which convert > /dev/null")
  describe "Miso::Processor::ImageMagick" do
    it "should check the load paths to see if ImageMagick is available" do
      Miso::Processor::ImageMagick.should.be.available
      
      Miso::Processor::ImageMagick.stubs(:system).returns(false)
      Miso::Processor::ImageMagick.should.not.be.available
    end
  end
  
else
  warn "[!] Skipping Miso::Processor::ImageMagick functional spec."
end