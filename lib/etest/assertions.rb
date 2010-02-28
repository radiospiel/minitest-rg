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
    if args.empty?
      args.push @response.body
    end
    
    require "libxml"

    args.each do |xml|
      assert LibXML::XML::Document.io(StringIO.new(xml))
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
