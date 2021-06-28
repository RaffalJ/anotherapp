class ContactContract < ApplicationContract
  schema do
    required(:name).value(:string)
    required(:email).value(:string)
    optional(:firstname).value(:string)
    optional(:lastname).value(:string)
    optional(:addresses).array(AddressContract.schema)
  end

  rule(:email) do
    unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
      key.failure('wrong format')
    end

    key.failure('is not unique') if Contact.pluck(:email).include?(value)
  end

  rule(:addresses).each do
    result = AddressContract.new.call(value)
    key.failure(result.errors) unless result.success?
  end
end
