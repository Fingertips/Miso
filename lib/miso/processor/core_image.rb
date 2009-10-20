# Based on code from HotCocoa and: http://redartisan.com/2007/12/12/attachment-fu-with-core-image
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
        @dimensions ||= image.extent.size.to_a
      end
      
      def crop(width, height)
        scale_width, scale_height = scale(width, height)
        multiplier = scale_width > scale_height ? scale_width : scale_height
        transform(multiplier)
        
        # find the center and calculate the new bottom right from there
        x = ((buffer_width.to_f - width.to_f) / 2).round.abs
        y = ((buffer_height.to_f - height.to_f) / 2).round.abs
        _crop(x, y, width, height)
      end
      
      def fit(width, height)
        scale_width, scale_height = scale(width, height)
        multiplier = scale_width < scale_height ? scale_width : scale_height
        new_width  = (self.width * multiplier).round
        new_height = (self.height * multiplier).round
        
        transform(multiplier)
        _crop(0, 0, new_width, new_height)
      end
      
      def write(output_file)
        bitmap = OSX::NSBitmapImageRep.alloc.initWithCIImage(@buffer)
        blob = bitmap.representationUsingType_properties(detect_file_type(output_file), nil)
        blob.writeToFile_atomically(output_file, false)
        reset!
      end
      
      private
      
      def image
        OSX::CIImage.imageWithContentsOfURL(OSX::NSURL.fileURLWithPath(@input_file))
      end
      
      def reset!
        @buffer = image
      end
      
      def buffer_width
        @buffer.extent.size.width
      end
      
      def buffer_height
        @buffer.extent.size.height
      end
      
      def apply_filter(name, options)
        filter = OSX::CIFilter.filterWithName(name)
        filter.setDefaults
        options.merge('inputImage' => @buffer).each do |name, value|
          filter.setValue_forKey(value, name)
        end
        @buffer = filter.valueForKey('outputImage')
      end
      
      def scale(width, height)
        [width.to_f / buffer_width, height.to_f / buffer_height]
      end
      
      def transform(multiplier)
        apply_filter 'CILanczosScaleTransform',
                     'inputScale' => multiplier,
                     'inputAspectRatio' => 1.0
      end
      
      def _crop(x, y, width, height)
        apply_filter 'CICrop', 'inputRectangle' => OSX::CIVector.vectorWithX_Y_Z_W(x, y, width, height)
      end
      
      def detect_file_type(path)
        OSX::NSPNGFileType
      end
    end
  end
end