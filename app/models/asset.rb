class Asset
  include Mongoid::Document

  embeds_one :log_book, class_name: 'Log::Book'

  before_create do
    self.log_book = Log::Book.new unless self.log_book
  end

  embeds_many :calibrations, class_name: 'Asset::Calibration'
  embeds_many :maintenance_jobs, class_name: 'Asset::Maintenance'

  field :name, type: String

  field :a_type, as: :asset_type, type: String

  field :nm_at, as: :next_maintenance_at, type: DateTime
  field :nc_at, as: :next_calibration_at, type: DateTime

  field :cmts, as: :comments, type: String
end
