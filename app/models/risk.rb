class Risk
  include Mongoid::Document

  embeds_many :measurements, class_name: 'Risk::Measurement'

  field :fq, as: :measurement_frequency, type: Integer

  field :pos_id, as: :position_id, type: BSON::ObjectId
  field :res_id, as: :responsible_id, type: BSON::ObjectId

  # belongs_to :position, class_name: 'Position', foreign_key: :p_id
  # belongs_to :responsible, class_name: 'Person::User', foreign_key: :r_id

  field :proc, as: :process, type: String
  field :act, as: :activity, type: String
end
