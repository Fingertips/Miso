require 'miso/processor/core_image'
require 'miso/processor/image_magick'
require 'miso/processor/graphics_magick'

module Miso
  class Processor
    class << self
      # Sets the default processor class.
      attr_writer :processor_class
      
      # Sets the default processor classes list.
      attr_writer :processor_classes
      
      # The default processor class.
      #
      # Returns either the assigned processor, or otherwise finds the first
      # processor, that is available on the machine, from the processor_classes
      # array.
      def processor_class
        @processor_class ||= processor_classes.find { |c| c.available? }
        raise "None of the Miso::Processor classes are available." unless @processor_class
        @processor_class
      end
      
      # The list of processor classes.
      #
      # When no explicit processor_class is set this list is iterated, from
      # first to last, and the first available processor on the machine is used.
      def processor_classes
        @processor_classes ||= [CoreImage, GraphicsMagick, ImageMagick]
      end
      
      def available?
        raise NotImplementedError, "The class `#{name}' does not implement ::available?."
      end
    end
    
    attr_reader :input_file
    
    def initialize(input_file)
      @input_file = File.expand_path(input_file)
      raise Errno::ENOENT, @input_file unless File.exist?(@input_file)
    end
    
    def crop(width, height)
      raise NotImplementedError, "The class `#{self.class.name}' does not implement #crop."
    end
    
    def fit(width, height)
      raise NotImplementedError, "The class `#{self.class.name}' does not implement #fit."
    end
    
    def auto_orient
      raise NotImplementedError, "The class `#{self.class.name}' does not implement #auto_orient."
    end
    
    def dimensions
      raise NotImplementedError, "The class `#{self.class.name}' does not implement #dimensions."
    end
    
    def write(output_file)
      raise NotImplementedError, "The class `#{self.class.name}' does not implement #write."
    end
    
    def width
      dimensions.first
    end
    
    def height
      dimensions.last
    end
  end
end
