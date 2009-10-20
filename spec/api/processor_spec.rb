require File.expand_path('../../start', __FILE__)

describe "Miso::Processor" do
  before do
    Miso::Processor.processor_class = nil
  end
  
  after do
    Miso::Processor.processor_class = nil
  end
  
  it "should assign the processor class to use" do
    Miso::Processor.processor_class = Miso::Processor::ImageMagick
    Miso::Processor.processor_class.should.be Miso::Processor::ImageMagick
  end
  
  it "should find the first available processor class" do
    Miso::Processor.processor_classes = [
      stub(:available? => false),
      stub(:available? => true),
      stub(:available? => false)
    ]
    
    Miso::Processor.processor_class.should.be Miso::Processor.processor_classes[1]
  end
  
  it "should raise if no available processor class is found" do
    Miso::Processor.processor_classes = [
      stub(:available? => false),
      stub(:available? => false)
    ]
    
    lambda {
      Miso::Processor.processor_class
    }.should.raise
  end
  
  it "should initialize with an input file path" do
    processor = Miso::Processor.new(fixture_file('120x100.png'))
    processor.input_file.should == fixture_file('120x100.png')
  end
  
  it "should expand and verify the input file path" do
    raised = false
    begin
      Miso::Processor.new('~/image.png')
    rescue Errno::ENOENT => e
      raised = true
      e.message.should.include File.expand_path('~/image.png')
    end
    raised.should.be true
  end
  
  it "should returns the width and height" do
    processor = Miso::Processor.new(fixture_file('120x100.png'))
    processor.stubs(:dimensions).returns([120, 100])
    processor.width.should == 120
    processor.height.should == 100
  end
end