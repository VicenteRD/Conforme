class Risk
  include Mongoid::Document

  embeds_many :measurements, class_name: 'Risk::Measurement'

  field :fq, as: :measurement_frequency, type: Integer

  belongs_to :position, foreign_key: :p_id
  belongs_to :responsible, class_name: 'Person::User', foreign_key: :r_id

  field :proc, as: :process, type: String
  field :act, as: :activity, type: String
end
