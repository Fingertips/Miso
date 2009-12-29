require File.expand_path('../../../start', __FILE__)

if Executioner::ClassMethods.find_executable('gm')
  describe "Miso::Processor::GraphicsMagick" do
    it "should check the load paths to see if GraphicsMagick is available" do
      Miso::Processor::GraphicsMagick.should.be.available
      
      Miso::Processor::GraphicsMagick.stubs(:find_executable).returns(nil)
      Miso::Processor::GraphicsMagick.should.not.be.available
    end
  end
  
else
  warn "[!] Skipping Miso::Processor::GraphicsMagick functional spec."
end
