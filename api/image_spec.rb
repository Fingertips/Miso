describe "An instance of Miso::Image" do
  before do
    image_120_x_100 = Miso::Image.new(fixture_file('120x100.png'))
    output_file = temp_file('temp.png')
  end
  
  it "should crop to specified dimensions" do
    image_120_x_100.crop(40, 30).write(output_file).dimensions.should == [40, 30]
    image_120_x_100.crop(40, 34).write(output_file).dimensions.should == [40, 34]
  end
  
  it "should fit to specified dimensions, conserving the original aspect ratio" do
    image_120_x_100.fit(40, 30).write(output_file).dimensions.should == [36, 30]
    image_120_x_100.fit(40, 34).write(output_file).dimensions.should == [40, 33]
  end
  
  it "should return its dimensions" do
    image_120_x_100.dimensions.should == [120, 100]
  end
end

describe "Miso::Image"
  it "should crop to specified dimensions" do
    output_file = temp_file('cropped_to_40x30.png')
    Miso::Image.crop(fixture_file('120x100.png'), output_file, 40, 30)
    Miso::Image.dimensions(output_file).should == [40, 30]
  end

  it "should fit to specified dimensions, conserving the original aspect ratio" do
    output_file = temp_file('fits_within_40x30.png')
    Miso::Image.fit(fixture_file('120x100.png'), output_file, 40, 30)
    Miso::Image.dimensions(output_file).should == [36, 30]
  end

  it "should return its dimensions" do
    Miso::Image.dimensions(fixture_file('120x100.png'), 120, 100)
  end
end