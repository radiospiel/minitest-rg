class String
  # taken from active-support
  def underscore
    gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end

  def camelize
    gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
  end
end

module String::Etest
  def test_underscore
    assert_equal "x", "X".underscore
    assert_equal "xa_la_nder", "XaLaNder".underscore
  end

  def test_underscore
    assert_equal "X", "x".camelize
    assert_equal "XaLaNder", "xa_la_nder".camelize
  end
end

