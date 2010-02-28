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

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| 
  puts ext
  load ext }
