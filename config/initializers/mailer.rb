Rails.application.configure do
  config.action_mailer.smtp_settings = {
    address: 'smtp.alertadepanico.com',
    port: 587,
    domain: "alertadepanico.com",
    enable_starttls_auto: false,
    user_name: ENV['MAILER_USERNAME'],
    password: ENV['MAILER_PASSWORD']
  }
end
