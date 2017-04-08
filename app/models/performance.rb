class Performance
  include Mongoid::Document

  field :q_type, as: :qualification_type, type: Integer
  field :phrase, type: String

  index({ phrase: 1 }, unique: true, name: 'phrase_index')
  index({ qualification_type: 1 }, name: 'type_index')

  scope :competency,  -> { where(qualification_type: 1) }
  scope :performance, -> { where(qualification_type: 2) }

  def self.all_types
    { 1 => 'competencias', 2 => 'performance' }
  end

  def presentable_type(lang = :en)
    type_name = ProviderEvaluation.all_types[qualification_type]

    type_name = 'desempeño' if type_name == 'performance' && lang == :es

    type_name
  end
end
