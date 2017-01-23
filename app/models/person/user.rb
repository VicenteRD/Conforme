class Person::User < Person
  include Mongoid::Document

  include ActiveModel::SecurePassword

  ## Make sure we have the minimum fields.

  validates :email, confirmation: true, uniqueness: true, with: /@/

  validates :password, length: {minimum: 8, maximum: 20}

  has_and_belongs_to_many :positions
  has_many :documents, through: :read_status
  has_many :tasks

  field :ll_at, as: :last_login, type: DateTime
  field :j_at, as: :joined_at, type: DateTime

  field :contract_type, type: String

  field :competencies, type: String
  field :performance, type: String

  ## Define the 'password_digest' field and indicate the
  ## presence of a password.
  field :password_digest, type: String
  has_secure_password
end
