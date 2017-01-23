class Minute
  include Mongoid::Document

  embedded_in :folder, class_name: 'Minute::Folder'

  embeds_many :curr_topics, class_name: 'Minute::Topic'
  embeds_many :next_topics, class_name: 'Minute::Topic'

  field :editor_id, type: BSON::ObjectId # => Person::User

  field :participants_ids, type: Array # BSON::ObjectId => Person::User
  field :tasks_ids, type: Array # BSON::ObjectId => Minute::Task

  field :u_file_id, class_name: BSON::ObjectId # => UploadedFile

  field :start, type: DateTime
  field :finish, type: DateTime

  field :nxt_start, type: DateTime
  field :nxt_finish,type: DateTime

  field :obs, type: String
  field :detail, type: String

end
