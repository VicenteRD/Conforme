class ReadStatus
  include Mongoid::Document

  belongs_to :document
  belongs_to :user, class_name: 'Person::User'

  field :read_at, type: DateTime
  field :score, type: Integer
end
