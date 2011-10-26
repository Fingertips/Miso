require File.expand_path('../../start', __FILE__)

describe "A Miso::Factory instance" do
  before do
    Miso::Processor.processor_class = Miso::Processor
    
    Miso::Processor.any_instance.stubs(:write)
    
    @input_file  = fixture_file('120x100.png')
    @output_file = '/output_image.png'
    @image       = Miso::Image.new(@input_file)
    
    Miso::Image.stubs(:new).with(@input_file, Miso::Processor).returns(@image)
    Miso::Image.stubs(:new).with(@output_file, Miso::Processor)
    
    @factory = Miso::Factory.new
  end
  
  after do
    Miso::Processor.processor_class = nil
  end
  
  it "should store operations that are to be applied later on" do
    @factory.crop(123, 456).fit(123, 456).auto_orient
    
    @image.expects(:crop).with(123, 456)
    @image.expects(:fit).with(123, 456)
    @image.expects(:auto_orient)
    
    @factory.apply(@input_file, @output_file)
  end
  
  it "properly supports crop fitting" do
    @image.expects(:crop).with(123, 456).returns(@image)
    @image.expects(:fit).with(123, 456).returns(@image)
    
    @factory.crop_fitting(123, 456)
    @factory.apply(@input_file, @output_file)
  end
end