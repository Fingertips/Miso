module Miso
  class Processor
    class ImageMagick < Processor
      def self.available?
        `which convert`
        $?.success
      end
      
      def crop(width, height)
        dimensions = "#{width}x#{height}"
        operations << "-resize #{dimensions}^ -gravity center -crop #{dimensions}+0+0"
      end
      
      def fit(width, height)
        operations << "-resize #{width}x#{height}^"
      end
      
      def dimensions
        if info = identify(input_file) and match = /\s(\d+)x(\d+)\+/.match(info)
          match.to_a[1..2]
        end
      end
      
      def write(output_file)
        convert(input_file, output_file, operations.join(' '))
      end
      
      private
      
      def operations
        @operations ||= []
      end
    end
  end
end