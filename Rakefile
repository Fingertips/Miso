require 'rubygems'
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
task :spec do
  sh "ruby -r #{Dir.glob('spec/**/*_spec.rb').join(' -r ')} -e ''"
end

namespace :docs do
  Rake::RDocTask.new(:generate) do |rd|
    rd.main = "README"
    rd.rdoc_files.include("README", "LICENSE", "lib/**/*.rb")
    rd.options << "--all" << "--charset" << "utf-8"
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name     = "miso"
    s.homepage = "http://github.com/Fingertips/miso"
    s.email    = ["eloy@fngtps.com", "manfred@fngtps.com"]
    s.authors  = ["Eloy Duran", "Manfred Stienstra"]
    s.summary  = s.description = "Miso is a unified API for simple image operations commonly used on the web."
    s.files   -= %w{ .gitignore .kick }
    s.add_dependency('executioner', '>= 0.3.0')
  end
rescue LoadError
end
 
begin
  require 'jewelry_portfolio/tasks'
  JewelryPortfolio::Tasks.new do |p|
    p.account = 'Fingertips'
  end
rescue LoadError
end