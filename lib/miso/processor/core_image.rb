module Miso
  class Processor
    class CoreImage < Processor
      def self.available?
        available = $:.any? { |path| File.exist? File.join(path, 'osx/cocoa.rb') }
        require 'osx/cocoa'
        available
      end
    end
  end
end