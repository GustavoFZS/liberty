# frozen_string_literal: true

module Tokenizable
  JWT_SECRET = Rails.application.secrets.jwt_secret.to_s
  PASSWORD_SECRET = Rails.application.secrets.password_token.to_s

  def self.included(base)
    base.extend ClassMethods
  end

  def jwt_token
    payload = {}
    payload[:id] = id.to_s
    payload[:encrypted_password] = JWT.encode encrypted_password, PASSWORD_SECRET
    payload[:created_at] = DateTime.now.to_i
    encode(payload)
  end

  module ClassMethods
    def by_token(token)
      decoded_token = decode(token)

      return unless valid?(decoded_token)

      dec_id = decoded_token['id']
      dec_encrypted_password = decode(decoded_token['encrypted_password'], PASSWORD_SECRET)
      where(id: dec_id, encrypted_password: dec_encrypted_password).last
    end

    private

    def decode(token, _secret = JWT_SECRET, _algo = 'HS256')
      JWT.decode(token, JWT_SECRET, 'HS256')[0]
    end

    def valid?(decoded_token)
      Time.at(decoded_token['created_at']) + JWT_TOKEN_EXP > DateTime.now
    end
  end

  private

  def encode(payload, _secret = JWT_SECRET, algo = 'HS256')
    JWT.encode payload, JWT_SECRET, algo
  end
end
