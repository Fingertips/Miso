require File.expand_path('../../start', __FILE__)

describe "Miso::Image, concerning initialization" do
  class FakeProcessor; end
  
  before do
    Miso::Processor.processor_class = nil
  end
  
  after do
    Miso::Processor.processor_class = nil
  end
  
  it "should initialize with only a file argument and use the default processor class" do
    Miso::Processor.processor_class = Miso::Processor::ImageMagick
    image = Miso::Image.new(fixture_file('120x100.png'))
    
    image.processor.input_file.should == fixture_file('120x100.png')
    image.processor.class.should == Miso::Processor::ImageMagick
  end
  
  it "should initialize with a file and processor class" do
    image = Miso::Image.new(fixture_file('120x100.png'), Miso::Processor::ImageMagick)
    
    image.processor.input_file.should == fixture_file('120x100.png')
    image.processor.class.should == Miso::Processor::ImageMagick
  end
end

describe "An instance of Miso::Image, concerning forwarding calls to the processor" do
  before do
    Miso::Processor.any_instance.stubs(:fit)
    Miso::Processor.any_instance.stubs(:crop)
    
    @image = Miso::Image.new(fixture_file('120x100.png'), Miso::Processor)
  end
  
  it "should forward #crop to the processor" do
    @image.processor.expects(:crop).with(123, 456)
    @image.crop(123, 456)
  end
  
  it "should return self when calling #crop" do
    @image.crop(123, 456).should.be @image
  end
  
  it "should forward #fit to the processor" do
    @image.processor.expects(:fit).with(123, 456)
    @image.fit(123, 456)
  end
  
  it "should return self instance when calling #fit" do
    @image.fit(123, 456).should.be @image
  end
  
  it "should forward #dimensions to the processor and return the result" do
    @image.processor.expects(:dimensions).returns([123, 456])
    @image.dimensions.should == [123, 456]
  end
  
  it "should forward #width and #height to the processor and return the result" do
    @image.processor.expects(:width).returns(123)
    @image.width.should == 123
  end
  
  it "should forward #height to the processor and return the result" do
    @image.processor.expects(:height).returns(456)
    @image.height.should == 456
  end
  
  it "should forward #write to the processor and forward its output file to the new instance of Miso::Image" do
    @image.processor.expects(:write).with(fixture_file('120x100.png'))
    output_image = @image.write(fixture_file('120x100.png'))
    output_image.processor.input_file.should == fixture_file('120x100.png')
  end
end

describe "An instance of Miso::Image, concerning combined methods" do
  before do
    Miso::Processor.any_instance.stubs(:fit)
    Miso::Processor.any_instance.stubs(:crop)
    
    @image = Miso::Image.new(fixture_file('120x100.png'), Miso::Processor)
  end
  
  it "should call #fit to scale and preserve aspect ratio, then call #crop" do
    @image.expects(:fit).with(123, 456).returns(@image)
    @image.expects(:crop).with(123, 456).returns(@image)
    
    @image.crop_fitting(123, 456)
  end
  
  it "should return self when calling #crop_fitting" do
    @image.crop_fitting(123, 456).should.be @image
  end
end

describe "Miso::Image, concerning shortcut class methods" do
  before do
    @input_file = fixture_file('120x100.png')
    @output_file = temp_file('cropped_to_40x30.png')
    @image = Miso::Image.new(@input_file, Miso::Processor)
    
    Miso::Image.stubs(:new).with(@input_file, nil).returns(@image)
  end
  
  it "should crop to specified dimensions" do
    @image.expects(:crop).with(40, 30).returns(@image)
    @image.expects(:write).with(@output_file)
    
    Miso::Image.crop(@input_file, @output_file, 40, 30)
  end
  
  it "should fit to specified dimensions, conserving the original aspect ratio" do
    @image.expects(:fit).with(40, 30).returns(@image)
    @image.expects(:write).with(@output_file)
    
    Miso::Image.fit(@input_file, @output_file, 40, 30)
  end
  
  it "should return its dimensions" do
    @image.expects(:dimensions).returns([120, 100])
    Miso::Image.dimensions(@input_file).should == [120, 100]
  end
end