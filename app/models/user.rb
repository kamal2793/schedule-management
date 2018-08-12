class User < ApplicationRecord
  # Store encrypted password in db.
  has_secure_password

  has_one :doctor
  has_one :patient

  validates_presence_of :first_name, :email, :password_digest
  validates_uniqueness_of :email
end
