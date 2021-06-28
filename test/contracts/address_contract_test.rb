require 'test_helper'

class AddressContractTest < ActiveSupport::TestCase
  test "call with valid params" do
    params = { city: "city", street: "street", street_number: 1 }
    result = AddressContract.new.call(params)

    assert_equal result.errors.blank?, true
  end

  test "call with invalid city format" do
    params = { city: 123, street: "street", street_number: 1 }
    result = AddressContract.new.call(params)

    assert_equal result.errors.messages.first.text, "must be a string"
    assert_equal result.errors.blank?, false
  end

  test "call with invalid street number format" do
    params = { city: "city", street: "street", street_number: "abc" }
    result = AddressContract.new.call(params)

    assert_equal result.errors.messages.first.text, "must be an integer"
    assert_equal result.errors.blank?, false
  end
end
