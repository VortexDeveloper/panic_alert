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

  private
  def contact_params
    params.require(:contact).permit(:name, numbers: [:value, :type])
  end
end
