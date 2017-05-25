class UserMailer < ApplicationMailer
  def send_support_email(user, message)
    @user = user
    @message = message
    mail(
      to: 'Central de Suporte <contato@alertadepanico.com.br>',
      reply_to: "#{@user.name} #{@user.username} <#{@user.email}>",
      subject: "Requisição de Suporte enviada por #{@user.name} #{@user.username}"
    )
  end
end
