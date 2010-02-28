#
#
# Some assertions
module Etest::Assertions
  def assert_respond_to(obj, *args)
    raise ArgumentError, "Missing argument(s)" if args.length < 1
  
    args.reject! { |sym| obj.respond_to?(sym) }
    
    assert args.empty?, "#{obj.inspect} should respond to #{args.map(&:inspect).join(", ")}, but doesn't."
  end

  # returns a list of invalid attributes in a model, as symbols.
  def invalid_attributes(model)                                     #:nodoc:
    model.valid? ? [] : model.errors.instance_variable_get("@errors").keys.map(&:to_sym)
  end
  
  #
  # Verifies that a model is valid. Pass in some attributes to only
  # validate those attributes.
  def assert_valid(model, *attributes)
    if attributes.empty?
      assert(model.valid?, "#{model.inspect} should be valid, but isn't: #{model.errors.full_messages.join(", ")}.")
    else
      invalid_attributes = invalid_attributes(model) & attributes
      assert invalid_attributes.empty?,
        "Attribute(s) #{invalid_attributes.join(", ")} should be valid"
    end
  end

  #
  # Verifies that a model is invalid. Pass in some attributes to only
  # validate those attributes.
  def assert_invalid(model, *attributes)
    assert(!model.valid?, "#{model.inspect} should be invalid, but isn't.")
    
    return if attributes.empty?

    missing_invalids = attributes - invalid_attributes(model)

    assert missing_invalids.empty?,
      "Attribute(s) #{missing_invalids.join(", ")} should be invalid, but are not"
  end

  #
  #
  def assert_valid_xml(*args)
    args.push @response.body if args.empty?
    
    args.each do |xml|
      assert xml_valid?(xml), "XML is not valid: #{xml}"
    end
  end

  def xml_valid?(xml)
    require "libxml"
    LibXML::XML::Error.reset_handler
    
    LibXML::XML::Document.io StringIO.new(xml)
    true
  rescue LibXML::XML::Error
    false
  end
  
  def assert_invalid_xml(*args)
    args.push @response.body if args.empty?
    
    args.each do |xml|
      assert !xml_valid?(xml), "XML should not be valid: #{xml}"
    end
  end

  def assert_route(uri_path, params)
    assert_recognizes params, uri_path
  end

  def assert_raises_kind_of(klass, &block)
    begin
      yield
      assert false, "Should raise a #{klass} exception, but didn't raise at all"
    rescue klass
      assert $!.is_a?(klass), "Should raise a #{klass} exception, but raised a #{$!.class.name} exception"
    end
  end
end


module Etest::Assertions::Etest
  #
  # this actually tests the existance of an assertion and one successful
  # assertion, nothing less, and nothing more...
  def test_asserts
    assert_respond_to "nsn", :upcase
    assert respond_to?(:assert_invalid)
    assert respond_to?(:assert_valid)
  end

  class TestError < RuntimeError; end
  
  def test_assert_raises_kind_of
    assert_raises_kind_of RuntimeError do 
      raise TestError
    end
  end
  
  def test_xml
    assert_valid_xml <<-XML
<root>
<p> lkhj </p>
</root>
XML
  
    assert_invalid_xml <<-XML
<root>
<p> lkhj </p>
XML
  end
end
