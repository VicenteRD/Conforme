class Task
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include Enumerable

  belongs_to :petitioner, class_name: 'Person::User', foreign_key: 'u_id'
  belongs_to :executor, class_name: 'Person::User', foreign_key: 'e_id'

  field :n, as: :number
  field :status, type: String

  field :extract, type: String

  field :rejected, type: Boolean

  field :p_at, as: :planned_for, type: DateTime
  field :r_at, as: :resolved_at, type: DateTime
end
