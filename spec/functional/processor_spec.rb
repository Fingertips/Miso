require File.expand_path('../../start', __FILE__)

describe "Miso::Processor" do
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
end