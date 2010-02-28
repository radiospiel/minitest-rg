require "rubygems"
require "minitest/unit"
require File.dirname(__FILE__) + "/string_ext"
require File.dirname(__FILE__) + "/module_ext"
require File.dirname(__FILE__) + "/dlog_ext"

#
# Embedded test cases:
#
# The Etest module contains methods to run etests.
# 
module Etest
end


require File.dirname(__FILE__) + "/etest/assertions"

class MiniTest::Unit::TestCase
  def self.run_etests(*test_cases)
    MiniTest::Unit::TestCase.reset
    
    test_cases.each do |test_case|
      MiniTest::Unit::TestCase.inherited test_case
    end

    MiniTest::Unit.new.run([])
    MiniTest::Unit::TestCase.reset
  end
end

module Etest
  def self.auto_run
    #
    # find all modules that are not named /::Etest$/, and try to load
    # the respective Etest module.
    etests = Module.instances.map { |mod|
      #next if mod.name =~ /\bEtest$/
      next if mod.name == "Object"
      
      Module.by_name "#{mod.name}::Etest"
    }.compact.uniq.sort_by(&:name)

    run *etests
  end

  def self.run(*etests)
    dlog "Running", etests
    #
    # convert all Etest modules into a test case
    test_cases = etests.map { |etest|
      to_test_case etest
    }
    
    MiniTest::Unit::TestCase.run_etests *test_cases
  end

  #
  # convert an Etest moodule into a MiniTest testcase
  def self.to_test_case(mod)
    klass = Class.new MiniTest::Unit::TestCase
    klass.send :include, mod
    klass.send :include, Assertions

    mod.const_set("TestCase", klass)
    klass
  end
end
