require "minitest/unit"

#
# taken from redgreen and adjusted
module MiniTest::Colors
  COLORS = { 
    :clear => 0, :red => 31, :green => 32, :yellow => 33 
  }

  def self.[](color_name)
    "\e[#{COLORS[color_name.to_sym]}m"
  end
end

module MiniTest
  TEST_COLORS = {
    "F" => :red,
    "E" => :red,
    "S" => :yellow,
    "." => :green
  }

  def self.colored(status, msg)
    color_name = TEST_COLORS[status[0,1]]
    return msg if !color_name
    MiniTest::Colors[color_name] + msg + MiniTest::Colors[:clear] 
  end
end

class MiniTest::Unit::TestCase
  alias :original_run :run

  def run(runner)
    r = original_run(runner)
    MiniTest.colored(r, r)
  end
end

class MiniTest::Unit
  alias :original_puke :puke

  def puke(klass, meth, e)
    r = original_puke(klass, meth, e)
    lines = []
    if 0 < @report.length
      report = @report.pop
      lines = report.split(/\n/)
      lines[0] = MiniTest.colored(r, lines[0])
      @report << lines.join("\n")
    end
    r
  end
end
