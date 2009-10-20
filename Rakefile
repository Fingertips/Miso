require 'rake/rdoctask'

desc "Run all specs by default"
task :default => :spec

namespace :spec do
  desc "Run all API specs"
  task :api do
    Dir[File.dirname(__FILE__) + '/spec/api/**/*_spec.rb'].each do |file|
      load file
    end
  end
  
  desc "Run all functional specs"
  task :functional do
    Dir[File.dirname(__FILE__) + '/spec/functional/*_spec.rb'].each do |file|
      load file
    end
  end
end

desc "Run all specs"
task :spec => [:'spec:api', :'spec:functional'] do
end
  
namespace :docs do
  Rake::RDocTask.new(:generate) do |rd|
    rd.main = "README"
    rd.rdoc_files.include("README", "LICENSE", "lib/**/*.rb")
    rd.options << "--all" << "--charset" << "utf-8"
  end
end