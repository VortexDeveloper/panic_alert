class ContactsController < ApplicationController
  before_action :authenticate!

  def index
    render json: {list: current_user.accepted_dependent_requests}
  end

  def create
    numbers = contact_numbers(params[:contact][:numbers]).uniq
    contact = User.where('ddd || phone_number IN (:number)', number: numbers).first

    if contact && current_user.add_for_emergency_contact(contact)
      save_display_name(contact, params[:contact][:display_name])
      send_notification_to(
        contact,
        "#{current_user.name} te adicionou como contato de emergência",
        {kind: params[:contact][:kind]},
        params[:contact][:kind]
      )

      render json: {
        list: current_user.accepted_dependent_requests,
        message: "Solicitação foi enviada para #{params[:contact][:display_name]}"
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

    if contact && current_user.accept_emergency_contact_of(contact)
      send_notification_to(
        contact,
        "#{current_user.name} aceitou ser seu contato de emergência",
        {kind: params[:kind]},
        params[:kind]
        )
      head :no_content
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :display_name, numbers: [:value, :type])
  end

  def code_and_phone_number(unformatted_number)
    number = unformatted_number.gsub(/([[:space:]]|\-|\+)/, '')
    if number.starts_with? "55"
      [number[2..3], number[4..-1]]
    elsif number.size >= 10
      [number[0..1], number[2..-1]]
    else
      [current_user.ddd, number]
    end
  end

  def contact_numbers(numbers)
    numbers.map do |info|
      if info[:type]=='mobile'
        code_and_phone_number(info[:value]).join
      end
    end
  end

  def save_display_name(contact, display_name)
    relation = Contact.where(user: current_user, emergency_contact: contact).first
    relation.display_name = display_name
    relation.save
  end

  def send_notification_to(contact, message, add_to_payload, kind)
    notification_options = {
      tokens: contact.device_token || [],
      message: message,
      title: "Pânico do Alerta",
      payload: {
        data: {
          title: "Pânico do Alerta",
          body: message,
          notId: 10
        }
      }
    }
    notification_options[:payload][:data].merge!(add_to_payload)
    notification = IonicNotification::Notification.new(notification_options)
    notification.send if contact.device_token.present?

    save_user_notification(notification, contact, kind)
  end

  def save_user_notification(notification, contact, kind)
    features = notification.as_json.select do |key, value|
      Notification.column_names.include? key
    end
    features[:sender] = current_user
    features[:kind] = kind
    contact.notifications.create(features)
  end
end
