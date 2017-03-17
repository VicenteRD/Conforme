class Planning
  include Mongoid::Document

  include EnumerableDocument
  include Describable
  include Referable

  embeds_one :log_book, class_name: 'Log::Book'

  before_create do
    self.log_book ||= Log::Book.new
  end

  embeds_many :activities, class_name: 'PlanningActivity'

  field :d_at, as: :due_at, type: DateTime
  field :e_at, as: :executed_at, type: DateTime

  field :name, type: String
  field :desc, as: :description, type: String

  field :prog, as: :progress, type: Float

  field :cmts, as: :comments, type: String

  def update_progress
    self.progress = self.activities.avg(:progress)

    self.save!
  end
end
