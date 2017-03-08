class Person
  include Mongoid::Document
  include Mongoid::Paperclip

  include Activatable

  ## Make sure we have the minimum fields.

  validates :rut, if: :valid_rut?, presence: true, uniqueness: true # Error: DV invalido

  validates :name, presence: true, format: {with: /\A[a-z]+\Z/i}

  ## Creates 'c_at' and 'u_at' fields, representing the times
  ## at which the user was created and updated, respectively.
  include Mongoid::Timestamps::Short

  has_mongoid_attached_file :avatar
  has_mongoid_attached_file :background_image

  validates_attachment_content_type :avatar, content_type: %w(image/jpg image/jpeg image/png image/gif)
  validates_attachment_content_type :background_image, content_type: %w(image/jpg image/jpeg image/png image/gif)

  ## Other fields
  field :rut, type: String

  field :name, type: String
  # Last names
  field :l_name1, type: String
  field :l_name2, type: String

  field :dob, type: Date

  field :email, type: String
  field :phone, type: String

  field :address, type: String

  field :role, :type => String

  def first_last_name
    self.name + ' ' + self.l_name1
  end

  def last_names
    self.l_name1 + ' ' + self.l_name2
  end

  def full_name
    self.name + ' ' + self.last_names
  end

  def valid_rut?
    number_and_digit = rut.split('-')

    if number_and_digit.size == 2 && (true if Integer(number_and_digit[0]) rescue false) &&
        number_and_digit[0].size.between?(7, 8) && number_and_digit[1].size == 1

      total = 0
      i = 2
      number_and_digit[0].reverse { |d|
        total += d.to_i * i
        i = i < 7 ? i + 1 : 2
      }

      digit = 11 - (total % 11)
      return (digit < 10 && digit.to_s == number_and_digit[1]) ||
          (digit == 10 && number_and_digit[1].downcase == 'k') ||
          (digit == 11 && number_and_digit[1] == '0')
    else
      # Error, invalid format
    end

    false
  end

end
