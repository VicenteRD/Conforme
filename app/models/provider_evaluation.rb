class ProviderEvaluation
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  belongs_to :provider_type
  belongs_to :evaluated_provider, class_name: 'Person::Provider'

  field :eval_id, as: :evaluator_id, type: BSON::ObjectId # => Person::User

  field :grades, type: Array
end
