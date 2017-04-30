class Minute
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include EnumerableDocument
  include Describable
  include Referable

  embedded_in :folder, class_name: 'MinuteFolder'

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :name, type: String

  field :treated_t, as: :treated_topics, type: Hash # {String => Bool}
  field :untreated_t, as: :untreated_topics, type: Array # String

  field :editor_id, type: BSON::ObjectId # => Person::User

  field :tasks_ids, type: Array # BSON::ObjectId => Minute::Task

  field :start_at, type: DateTime
  field :finish_at, type: DateTime

  field :nxt_start_at, type: DateTime
  field :nxt_finish_at, type: DateTime

  # BSON::ObjectId => Person::User
  field :emp_p_ids, as: :employee_participant_ids, type: Array

  # BSON::ObjectId => Person::Client
  field :client_p_ids, as: :client_participant_ids, type: Array

  # BSON::ObjectId => Person::Provider
  field :prov_p_ids, as: :provider_participant_ids, type: Array

  # BSON::ObjectId => Person (??)
  field :other_p_ids, as: :other_participant_ids, type: Array

end
