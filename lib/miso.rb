module Miso
  autoload :Factory,   'miso/factory'
  autoload :Image,     'miso/image'
  autoload :Processor, 'miso/processor'
  
  class MisoError < StandardError; end
  class NotImplementedError < MisoError; end
  class UnsupportedFileType < MisoError
    def initialize(path)
      ext = File.extname(path)[1..-1]
      super("Miso does not support file type `#{ext}' of `#{path}'")
    end
  end
end