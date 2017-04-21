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

  field :prog, as: :progress, type: Float, default: 0.0

  field :cmts, as: :comments, type: String

  def new_activity(fields)
    activities.create!(fields)

    update_progress
  end

  def find_activity(id)
    activities.find(id)
  end

  def update_progress
    self.progress = activities.avg(:progress)

    save!
  end

  def self.display_name
    'Planificación'
  end

  def display_name
    name
  end
end
