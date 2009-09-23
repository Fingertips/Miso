module Miso
  class Processor
    class CoreImage < Processor
      def self.available?
        available = $:.any? { |path| File.exist? File.join(path, 'osx/cocoa.rb') }
        require 'osx/cocoa'
        available
      end
      
      def crop(width, height)
        # ...
      end
      
      def fit(width, height)
        # ...
      end
      
      def dimensions
        # ...
      end
      
      def write(output_file)
        # ...
      end
    end
  end
end