class Task
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  include Enumerable

  field :executor_id, type: BSON::ObjectId # => Person::User
  field :petitioner_id, type: BSON::ObjectId # => Person::User

  field :status, type: String

  field :extract, type: String

  field :rejected, type: Boolean

  field :p_at, as: :planned_for, type: DateTime
  field :r_at, as: :resolved_at, type: DateTime

  def type_name
    'Varios'
  end
end
