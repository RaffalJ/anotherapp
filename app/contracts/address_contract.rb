class AddressContract < ApplicationContract
  params do
    required(:city).value(:string)
    optional(:street).value(:string)
    optional(:street_number).value(:integer)
  end
end
