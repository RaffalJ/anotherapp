require 'test_helper'

class ContactContractTest < ActiveSupport::TestCase
  test "call with valid params" do
    params = {
      name: "name",
      email: "email@email.com",
      firstname: "firstname",
      lastname: "lastname",
      addresses: [
        { city: "city1", street: "street1", street_number: 1 },
        { city: "city2", street: "street2", street_number: 2 }
      ]
    }
    result = ContactContract.new.call(params)

    assert_equal result.errors.blank?, true
  end

  test "call with wrong email format" do
    params = {
      name: "name",
      email: "wrong_email",
      firstname: "firstname",
      lastname: "lastname",
      addresses: [
        { city: "city1", street: "street1", street_number: 1 },
        { city: "city2", street: "street2", street_number: 2 }
      ]
    }
    result = ContactContract.new.call(params)

    assert_equal result.errors.messages.first.text, "has wrong format"
    assert_equal result.errors.blank?, false
  end

  test "call with already existing email" do
    email = "email@email.com"
    Contact.create!(name: "name", email: email)

    params = {
      name: "name",
      email: email,
      firstname: "firstname",
      lastname: "lastname",
      addresses: [
        { city: "city1", street: "street1", street_number: 1 },
        { city: "city2", street: "street2", street_number: 2 }
      ]
    }
    result = ContactContract.new.call(params)

    assert_equal result.errors.messages.first.text, "is not unique"
    assert_equal result.errors.blank?, false
  end

  test "call with wrong address" do
    params = {
      name: "name",
      email: "email@email.com",
      firstname: "firstname",
      lastname: "lastname",
      addresses: [
        { city: "city1", street: "street1", street_number: 1 },
        { city: "city2", street: "street2", street_number: "abc" }
      ]
    }
    result = ContactContract.new.call(params)

    assert_equal result.errors.messages.first.text, "must be an integer"
    assert_equal result.errors.blank?, false
  end
end
