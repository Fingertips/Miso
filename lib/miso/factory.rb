module Miso
  class Image
    def self.factory(processor_class = Processor.processor_class)
      Factory.new(processor_class)
    end
  end
  
  # A Miso::Image::Factory can be used to define multiple operations which are
  # to be applied to an image.
  #
  # A typical use case would be:
  #
  #   class Member < ActiveRecord::Base
  #     has_variant :avatar, :processor => Miso::Image.factory.crop(123, 456).watermark(WATERMARK, :southwest, 10, 10)
  #   end
  #
  # In this example, the resulting Miso::Factory instance would be used by the
  # attachment library to apply the operations. Eg:
  #
  #   module HasVariant
  #     def process_variant(name)
  #       variant = self.class.variants[name]
  #       variant.processor.apply(upload_file, output_file)
  #     end
  #   end
  class Factory
    def initialize(processor_class = Processor.processor_class)
      @processor_class = processor_class
      @operations = []
    end
    
    def crop(width, height)
      @operations << [:crop, [width, height]]
      self
    end
    
    def fit(width, height)
      @operations << [:fit, [width, height]]
      self
    end
    
    def crop_fitting(width, height)
      @operations << [:crop_fitting, [width, height]]
      self
    end
    
    def auto_orient
      @operations << [:auto_orient, []]
      self
    end
    
    def apply(input_file, output_file)
      image = Image.new(input_file, @processor_class)
      @operations.each { |method, args| image.send(method, *args) }
      image.write(output_file)
    end
  end
end