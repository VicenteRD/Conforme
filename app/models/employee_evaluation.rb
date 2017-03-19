class EmployeeEvaluation
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  belongs_to :position
  belongs_to :evaluated_employee, class_name: 'Person::User'

  field :grades, type: Array

  field :eval_id, as: :evaluator_id, type: BSON::ObjectId # => Person::User

  field :grades, type: Array
end
