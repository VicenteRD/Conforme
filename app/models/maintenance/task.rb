class Maintenance::Task < Task
  include Mongoid::Document

  # belongs_to :maintenance

  field :asset, type: String
  field :p_at, as: :planned_for, type: DateTime
  field :work, type: String
end
