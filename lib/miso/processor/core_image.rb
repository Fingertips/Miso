module Miso
  class Processor
    class CoreImage < Processor
      def self.available?
        $:.any? { |path| File.exist? File.join(path, 'osx/cocoa.rb') }
      end
      
      def initialize(input_file)
        super
        require 'osx/cocoa'
      end
    end
  end
end