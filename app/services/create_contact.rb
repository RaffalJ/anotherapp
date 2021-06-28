class CreateContact
  prepend ::BaseMonad
  attr_reader :params, :now

  def initialize(params)
    @params = params.to_h
    @now = Time.zone.now
  end

  def call
              yield validate_params
    contact = yield create_contact
              yield create_addresses(contact)
    Success(contact)
  end

  private

  def validate_params
    result = ContactContract.new.call(params)
    return Success(true) if result.success?

    return Failure(generate_error_messages(result.errors.messages))
  end

  def create_contact
    Try { Contact.create!(params.slice(:name, :email, :firstname, :lastname)) }
  end

  def create_addresses(contact)
    Try do
      return Success(true) if params[:addresses].blank?

      params[:addresses].map do |param|
        Address.create!(param.merge(contact: contact))
      end
    end
  end

  def generate_error_messages(errors)
    messages = []
    errors.each do |error|
      messages << "#{error.path.first.to_s} #{error.text}" if error.path.size == 1
      messages << "#{error.path.first.to_s.singularize} #{error.path.second}: #{error.path.third.to_s} #{error.text}" if error.path.size > 1
    end
    messages
  end
end
