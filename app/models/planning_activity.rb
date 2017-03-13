class PlanningActivity
  include Mongoid::Document

  include EnumerableDocument

  embeds_one :log_book, class_name: 'Log::Book'

  before_create do
    self.log_book ||= Log::Book.new
  end

  embedded_in :planning

  field :d_at, as: :due_at, type: DateTime
  field :e_at, as: :executed_at, type: DateTime

  field :prog, as: :progress, type: Float

  field :name, type: String
  field :desc, as: :description, type: String

  field :cmts, as: :comments, type: String
end
