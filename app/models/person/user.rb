class Person::User < Person
  include Mongoid::Document

  include ActiveModel::SecurePassword
  include Referable

  ## Make sure we have the minimum fields.

  validates :email, confirmation: true, uniqueness: true, format: {with: /@/}

  #validates :password, length: {minimum: 8, maximum: 20, too_short: 'La contraseña debe tener entre 8 y 20 caracteres'}

  has_and_belongs_to_many :positions
  has_many :read_status

  field :ll_at, as: :last_login, type: DateTime
  field :j_at, as: :joined_at, type: DateTime

  field :contract_type, type: String

  ## Define the 'password_digest' field and indicate the
  ## presence of a password.
  field :password_digest, type: String
  has_secure_password

  def name_and_position
    "(#{self.all_positions}) #{self.full_name}"
  end

  def all_positions
    pos_names = []
    for pos_id in self.positions
      pos_names.push(pos_id.name)
    end

    pos_names.join('/')
  end
end
