module Miso
  class Processor
    class CoreImage < Processor
      def self.available?
        $:.any? { |path| File.exist? File.join(path, 'osx/cocoa.rb') }
      end
      
      def initialize(input_file)
        super
        require 'osx/cocoa'
        @image = OSX::CIImage.imageWithContentsOfURL(OSX::NSURL.fileURLWithPath(input_file))
      end
      
      def dimensions
        @image.extent.size.to_a
      end
    end
  end
end