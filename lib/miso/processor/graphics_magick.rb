module Miso
  class Processor
    class GraphicsMagick < ImageMagick
      def self.available?
        !find_executable('gm').nil?
      end
      
      executable :gm
      
      def identify(input_file)
        gm "identify '#{input_file}'"
      end
      
      def convert(source_path, output_path, options)
        ensure_output_directory(output_path)
        gm "convert '#{source_path}' #{options} '#{output_path}'"
      end
    end
  end
end
