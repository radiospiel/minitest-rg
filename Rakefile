task :default => :test

task :test do
	sh "ruby test/test.rb"
end

task :rcov do
  sh "cd test; rcov -o ../coverage -x ruby/.*/gems -x ^test.rb test.rb"
end

task :rdoc do
  sh "rdoc -o doc/rdoc"
end

require 'rubygems'  
require 'rake'  
require 'echoe'  

Echoe.new('etest', '0.1') do |p|  
  p.description     = "Embedded tests"  
  p.url             = "http://github.com/pboy/etest"  
  p.author          = "pboy"  
  p.email           = "eno-pboy@open-lab.org"  
  p.ignore_pattern  = ["tmp/*"]  
  # p.runtime_dependencies = %w(nokogiri htmlentities rdiscount)
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

