require Rails.root.join('lib/strategies/auth_token_strategy')
require Rails.root.join('lib/strategies/basic_auth_strategy')

Warden::Strategies.add(:auth_token, AuthTokenStrategy)
Warden::Strategies.add(:basic_auth, BasicAuthStrategy)
