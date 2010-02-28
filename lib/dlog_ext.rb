module Dlog
  def dlog(*args)
  end
end

if !ENV["NO_DLOG"]

module Dlog
  ROOT = if defined?(RAILS_ROOT)
    RAILS_ROOT
  else
    File.expand_path(Dir.getwd) 
  end
  
  HOME = ENV["HOME"] + "/"
  
  def dlog(*args)
    msg = ""
    was_string = true
    args.map do |s|
      msg += was_string ? " " : ", " unless msg.empty?
      msg += ((was_string = s.is_a?(String)) ? s : s.inspect)
    end
    STDERR.puts "#{dlog_caller}: #{msg}"
  end

  def dlog_caller
    if caller[1] =~ /^(.*):(\d+)/
      file, line = $1, $2
      file = File.expand_path(file)

      file.gsub!(ROOT, ".") or
      file.gsub!(HOME, "~/")
    
      "#{file}(#{line})"
    else
      "<dlog>"
    end
  end
end

end

class Object
  include Dlog
end
