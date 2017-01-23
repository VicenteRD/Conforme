class ReadStatus
  include Mongoid::Document

  belongs_to :document
  belongs_to :user

  field :read_at, type: DateTime
  field :score, tye: Integer
end
