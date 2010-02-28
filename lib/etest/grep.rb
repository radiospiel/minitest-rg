__END__

module Etest::Grep
  def self.load_from_directories(*dirs)
    raise ArgumentError, "Missing directories" if dirs.empty?
    # -- collect tests

    STDERR.puts "\nLoad etests"

    etests = []
    rex = /^\s*module\s+(\S*\bEtest\b)/

    dirs.each do |dir|
      File.grep(rex, Dir.glob("#{dir}/**/*.rb")) do |_, _, matches|
        etests << matches[1]
      end
    end

    etests = etests.uniq.sort

    # -- load tests

    etests = etests.uniq.sort.each do |etest|
      mod = etest.constantize rescue nil
      next STDERR.puts("  #{etest}: cannot load test") unless mod
  
      tests = mod.instance_methods.select { |m| m =~ /^test_/ }

      next STDERR.puts("  #{etest}: Does not define any tests") if tests.empty?

      STDERR.puts("  #{etest}: w/#{tests.length} tests")

      klass = Class.new(Mpx::TestCase)
      klass.send :include, mod

      mod.const_set("TestCase", klass)
    end.compact
  end
end
