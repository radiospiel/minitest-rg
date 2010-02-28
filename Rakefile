task :default => :test

task :test do
	sh "ruby test/test.rb"
end

task :rcov do
  sh "cd test; rcov -o ../coverage -x ruby/.*/gems test.rb"
end

task :rdoc do
  sh "rdoc -o doc/rdoc"
end
