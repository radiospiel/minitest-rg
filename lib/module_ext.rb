# 
# TDD helpers for modules. 
class Module
  #
  # reloads the module, and runs the module's etests.
  def etest
    reload if respond_to?(:reload)
    Etest.run self
  end

  #
  # returns all instances of a module
  def instances                                           #:nodoc:
    r = []
    ObjectSpace.each_object(self) { |mod| r << mod }
    r
  end
  
  #
  # load a module by name. 
  def self.by_name(name)                                  #:nodoc:
    old_verbose, $VERBOSE = $VERBOSE, nil
    
    r = eval(name, nil, __FILE__, __LINE__)
    r if r.is_a?(Module) && r.name == name
  rescue NameError, LoadError
    nil
  ensure
    $VERBOSE = old_verbose
  end
  
  #
  # tries to reload the source file for this module. THIS IS A DEVELOPMENT
  # helper, don't try to use it in production mode!
  #
  # Limitations:
  #
  # To reload a module with a name of "X::Y" we try to load (in that order) 
  # "x/y.rb", "x.rb"
  #
  def reload
    Module::Reloader.reload_file("#{to_s.underscore}.rb") || begin
      dlog("Cannot reload module #{self}")
      false
    end
  end

  module Reloader                                       #:nodoc:
    def self.reload_file(file)
      begin
        load(file) && file
      rescue MissingSourceFile
        nfile = file.gsub(/\/[^\/]+\.rb/, ".rb")
        nfile != file && reload_file(nfile)
      end
    end
  end
end
