class BusinessAssetJob
  include Mongoid::Document

  embedded_in :business_asset

  embeds_one :log_book, class_name: 'Log::Book'

  before_create do
    self.log_book ||= Log::Book.new
  end

  field :job_type, type: Integer

  index({rule_type: 1}, {name: 'type_index'})

  scope :maintenance, -> { where(job_type: 1) }
  scope :calibration, -> { where(job_type: 2) }

  field :e_at, as: :executed_at, type: DateTime

  field :exd, as: :executed, type: Boolean

  field :mtv, as: :motive, type: String
  field :rst, as: :result, type: String

  field :cmts, as: :comments, type: String

  def self.last_non_executed_datetime(jobs, time_format)
    job = jobs.where(:executed.nin => [false]).last

    job ? job.executed_at.strftime(time_format) : '-'
  end
end
