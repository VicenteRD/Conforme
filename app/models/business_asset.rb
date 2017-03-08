class BusinessAsset
  include Mongoid::Document

  include EnumerableDocument

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

  field :cmts, as: :comments, type: String
end