module Miso
  class Processor
    class CoreImage < Processor
      def self.available?
        $:.any? { |path| File.exist? File.join(path, 'osx/cocoa.rb') }
      end
      
      def initialize(input_file)
        super
        require 'osx/cocoa'
        reset!
      end
      
      def dimensions
        @dimensions ||= ci_image.extent.size.to_a
      end
      
      def crop(width, height)
        apply_filter 'CICrop', 'inputRectangle' => vector(width, height)
      end
      
      def write(output_file)
        bitmap = OSX::NSBitmapImageRep.alloc.initWithCIImage(@buffer)
        blob = bitmap.representationUsingType_properties(detect_file_type(output_file), nil)
        blob.writeToFile_atomically(output_file, false)
        reset!
      end
      
      private
      
      def reset!
        @buffer = ci_image
      end
      
      def ci_image
        OSX::CIImage.imageWithContentsOfURL(OSX::NSURL.fileURLWithPath(@input_file))
      end
      
      def vector(width, height)
        OSX::CIVector.vectorWithX_Y_Z_W(0, 0, width, height)
      end
      
      def apply_filter(name, options)
        filter = OSX::CIFilter.filterWithName(name)
        filter.setDefaults
        options.merge('inputImage' => @buffer).each do |name, value|
          filter.setValue_forKey(value, name)
        end
        @buffer = filter.valueForKey('outputImage')
      end
      
      def detect_file_type(path)
        OSX::NSPNGFileType
      end
    end
  end
end