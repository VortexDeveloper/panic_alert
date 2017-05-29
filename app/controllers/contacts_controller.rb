class ContactsController < ApplicationController
  before_action :authenticate!

  def index
    render json: {list: current_user.accepted_dependent_requests}
  end

  def create
    numbers = params[:contact][:numbers].map { |info| info[:value] if info[:type]=='mobile' }
    contact = User.where(cellphone: numbers).first

    if contact
      current_user.add_for_emergency_contact(contact)
      render json: {
        list: current_user.accepted_dependent_requests,
        message: "Solicitação foi enviada para #{contact.name}"
      }
    else
      render json: {errors: {message: 'Este contato não está cadastrado no Pânico do Alerta'}}, status: :unprocessable_entity
    end
  end

  def open_requests
    render json: {list: current_user.pending_dependent_requests}
  end

  def drop_contact
    contact = User.find params[:contact_id]

    if contact
      current_user.drop_contact contact
      render json: {list: current_user.accepted_dependent_requests}
    end
  end

  def refuse_request
    contact = User.find params[:contact_id]

    if contact
      current_user.refuse_emergency_contact_of contact
      head :no_content
    end
  end

  def accept_request
    contact = User.find params[:contact_id]

    if contact
      current_user.accept_emergency_contact_of contact
      head :no_content
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:name, numbers: [:value, :type])
  end
end
