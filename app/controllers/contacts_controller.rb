# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :update, :destroy]

  # GET /contacts
  def index
    @contacts = Contact.includes(:addresses)

    render json: @contacts
  end

  # GET /contacts/1
  def show
    render json: @contact, include: [:addresses]
  end

  # POST /contacts
  def create
    CreateContact.new(contact_params).call.to_result.either(
      -> contact { render json: contact, include: [:addresses], status: :created },
      -> errors { render json: errors, status: :unprocessable_entity }
    )
  end

  # POST /mass_create
  def mass_create
    contact_attrs = params[:contact_attrs] || GenerateContacts.new.call

    now = Time.zone.now
    contacts = []
    contact_attrs.each do |attrs|
      new_attrs = attrs.merge(created_at: now, updated_at: now, id: rand(2**32..2**48))
      contact = Contact.new(new_attrs)
      contacts << new_attrs if contact.valid?
    end
    Contact.insert_all(contacts)
    created_contacts = Contact.where(id: contacts.map{ |c| c[:id] })

    render json: created_contacts, status: :created
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:contact).permit(
        :name,
        :email,
        :firstname,
        :lastname,
        addresses: [
          :city,
          :street,
          :street_number
        ]
      )
    end
end
