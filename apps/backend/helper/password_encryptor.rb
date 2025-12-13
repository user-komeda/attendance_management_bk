# frozen_string_literal: true

# rbs_inline: enabled

require 'bcrypt'

module PasswordEncryptor
  class << self
    def digest(password)
      BCrypt::Password.create(password)
    end

    def matches?(password, password_digest)
      BCrypt::Password.new(password_digest) == password
    end
  end
end
