#
# GEM settings
#
GEM_ROOT = File.expand_path("#{File.dirname(__FILE__)}/..")
if gem_config = YAML.load(File.read("#{GEM_ROOT}/gem.yml"))["gem"]
  require 'echoe'  

  GEM_NAME = File.basename(GEM_ROOT)
  Echoe.new(File.basename(GEM_ROOT), File.read("#{GEM_ROOT}/VERSION")) do |p|  
STDERR.puts gem_config.inspect
    gem_config.each do |k,v|
      p.send "#{k}=",v
    end
  end

  desc "Rebuild the gem"
  task :rebuild => %w(manifest default build_gemspec package) do
    puts "============================================="
    puts "I built the gem for you. To upload, run "
    puts
    puts "    gem push $(ls -d pkg/*.gem | tail -n 1)"
  end
end
