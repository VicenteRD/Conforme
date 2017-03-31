class ObjectiveRevision
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include Describable

  embedded_in :objective

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :rev_at, as: :revised_at, type: DateTime

  def log_created(user_id, body)
    log_book.new_entry(user_id, 'Creado', body)
  end

  def update_and_log(user_id, fields, log_entry)
    update!(fields)

    log_book.new_entry(user_id, 'Editado', log_entry)
  end
end
