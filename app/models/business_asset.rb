class BusinessAsset
  include Mongoid::Document

  include EnumerableDocument
  include Describable
  include Referable

  embeds_one :log_book, class_name: 'Log::Book'

  before_create do
    self.log_book = Log::Book.new unless self.log_book
  end

  embeds_many :jobs, class_name: 'BusinessAssetJob'

  field :name, type: String
  field :idn, as: :identification, type: String
  field :desc, as: :description, type: String

  field :t_id, as: :type_id, type: BSON::ObjectId # => BusinessAssetType
  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person::User

  def get_jobs(type)
    if type == 'mantencion'
      self.jobs.maintenance
    elsif type == 'calibracion'
      self.jobs.calibration
    else
      nil
    end
  end

  def self.display_name
    'Activos'
  end

  def display_name
    name
  end
end
