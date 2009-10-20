require File.expand_path('../../start', __FILE__)

describe "A Miso::Factory instance" do
  before do
    @input_file = '/image.png'
    @output_file = '/output_image.png'
    @image = Miso::Image.new(@input_file)
    
    Miso::Image.stubs(:new).with(@input_file).returns(@image)
    
    @factory = Miso::Factory.new
  end
  
  it "should store operations that are to be applied later on" do
    @factory.crop(123, 456).fit(123, 456)
    
    @image.expects(:crop).with do |width, height|
      @image.expects(:fit).with(123, 456)
      width == 123 and height == 456
    end
    
    @factory.apply(@input_file, @output_file)
  end
end