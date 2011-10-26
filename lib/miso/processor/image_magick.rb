begin
  require 'rubygems'
  gem 'executioner', '>= 0.3'
rescue LoadError
end
require 'executioner'
require 'fileutils'

module Miso
  class Processor
    class ImageMagick < Processor
      def self.available?
        !find_executable('convert').nil?
      end
      
      def crop(width, height)
        dimensions = "#{width}x#{height}"
        operations << "-resize #{dimensions}^ -gravity center -crop #{dimensions}+0+0!"
      end
      
      def fit(width, height)
        operations << "-resize #{width}x#{height}"
      end
      
      def auto_orient
        operations << "-auto-orient"
      end
      
      def dimensions
        if info = identify(input_file) and match = /\s(\d+)x(\d+)\+/.match(info)
          match.to_a[1..2].map { |d| d.to_i }
        end
      end
      
      def write(output_file)
        options = operations.join(' ')
        operations.clear
        convert(input_file, output_file, options)
      end
      
      include Executioner
      executable :convert
      executable :identify
      
      alias_method :_convert, :convert
      def convert(source_path, output_path, options)
        ensure_output_directory(output_path)
        _convert "'#{source_path}' #{options} '#{output_path}'"
      end
      
      private
      
      def operations
        @operations ||= []
      end
      
      def ensure_output_directory(path)
        FileUtils.mkdir_p(File.dirname(path))
      end
    end
  end
end