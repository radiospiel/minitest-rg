#
# GEM settings
#
require "yaml"

GEM_ROOT = File.expand_path("#{File.dirname(__FILE__)}/..")
if gem_config = YAML.load(File.read("#{GEM_ROOT}/gem.yml"))["gem"]
  require 'echoe'  

  GEM_NAME = File.basename(GEM_ROOT)
  Echoe.new(File.basename(GEM_ROOT), File.read("#{GEM_ROOT}/VERSION")) do |p|  
    gem_config.each do |k,v|
      p.send "#{k}=",v
    end
  end

  desc "Rebuild and install the gem"
  task :rebuild => %w(manifest default build_gemspec package) do
    gem = Dir.glob("pkg/*.gem").sort_by do |filename|
      File.new(filename).mtime
    end.last

    puts "============================================="
    puts "Installing gem..."

    system "gem install #{gem} > /dev/null 2>&1"

    puts ""
    puts "I built and installed the gem for you. To upload, run "
    puts
    puts "    gem push #{gem}"
  end
end
