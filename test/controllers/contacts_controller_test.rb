require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact = contacts(:one)
    @contact.email = "e#{SecureRandom.alphanumeric(8)}@example.com"

    @address_one = addresses(:address_one)
    @address_two = addresses(:address_two)
  end

  test "#index" do
    get contacts_url, as: :json
    assert_response :success
  end

  test "#create" do
    assert_difference('Contact.count') do
      post contacts_url, params: { contact: { email: @contact.email, name: @contact.name } }, as: :json
    end

    assert_response 201
  end

  test "#create with invalid email" do
    post contacts_url, params: { contact: { email: "invalid email format", name: @contact.name } }, as: :json

    assert_response 422
  end

  test "#create with addresses" do
    post contacts_url, params: {
      contact: {
        email: @contact.email,
        name: @contact.name,
        firstname: @contact.firstname,
        lastname: @contact.lastname,
        addresses: [
          { city: @address_one.city, street: @address_one.street, street_number: @address_one.street_number },
          { city: @address_two.city, street: @address_two.street, street_number: @address_two.street_number },
        ]
      },
    }, as: :json

    assert_response 201
    assert_equal(Contact.last.email, @contact.email)
    assert_equal(Contact.last.addresses.size, 2)
  end

  test "#create with invalid addresses" do
    post contacts_url, params: {
      contact: {
        email: @contact.email,
        name: @contact.name,
        firstname: @contact.firstname,
        lastname: @contact.lastname,
        addresses: [
          { city: @address_one.city, street: @address_one.street, street_number: @address_one.street_number },
          { city: @address_two.city, street: @address_two.street, street_number: "string" },
        ]
      },
    }, as: :json

    assert_response 422
  end

  test "#mass_create" do
    time = Time.now.to_i
    p "Start at: #{time}"
    assert_difference('Contact.count', 10000) do
      post mass_create_contacts_url, as: :json
    end

    now = Time.now.to_i
    p "End at: #{now}"
    p "Delta: #{now - time} seconds"
    assert_response 201
  end

  test "#show" do
    get contact_url(@contact), as: :json
    assert_response :success
  end

  test "#update" do
    patch contact_url(@contact), params: { contact: { email: @contact.email, name: @contact.name } }, as: :json
    assert_response 200
  end

  test "#destroy" do
    assert_difference('Contact.count', -1) do
      delete contact_url(@contact), as: :json
    end

    assert_response 204
  end
end
