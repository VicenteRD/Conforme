class MinutesFolder
  include Mongoid::Document

  include EnumerableDocument
  include Describable
  include Referable

  embeds_many :minutes

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :name, type: String
  field :loc, as: :location, type: String

  field :lm_at, as: :last_minute_at, type: DateTime

  def find_minute(id)
    minutes.find(id)
  end

  def new_minute(fields, treated_topics, untreated_topics)
    minute = minutes.create!(fields)
    minute.treated_topics = treated_topics if treated_topics
    minute.untreated_topics = untreated_topics if untreated_topics
    minute.save!


    if last_minute_at.nil? || minute.start_at > last_minute_at
      self.last_minute_at = minute.start_at
      save!
    end

    minute
  end

  def edit_minute(id, fields, treated_topics, untreated_topics)
    minute = find_minute(id)
    return unless minute

    minute.update!(fields)
    minute.treated_topics = treated_topics
    minute.untreated_topics = untreated_topics

    minute.save!

    minute
  end

  def last_meeting_at(format)
    last_minute_at.strftime(format) if last_minute_at
  end
end
