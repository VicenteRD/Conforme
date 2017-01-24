class Task::Doc < Task
  include Mongoid::Document

  field :pub_at, type: DateTime

  field :creator_id, type: BSON::ObjectId # => Person::User
  field :editor_id, type: BSON::ObjectId # => Person::User
  field :publisher_id, type: BSON::ObjectId # => Person::User

  field :document_id, type: BSON::ObjectId # => Document

  def type_name
    'Documento'
  end
end