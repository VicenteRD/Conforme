class Qualification
  include Mongoid::Document

  field :phrase, type: String
  field :q_type, as: :qualification_type, type: Integer

  index({ phrase: 1 }, unique: true, name: 'phrase_index')
  index({ qualification_type: 1 }, name: 'type_index')

  scope :competency,  -> { where(qualification_type: 1) }
  scope :performance, -> { where(qualification_type: 2) }

  def self.all_types
    { 1 => 'competencias', 2 => 'performance' }
  end

  def self.presentable_type(type_number, lang = :en)
    type_name = Qualification.all_types[type_number]

    type_name = 'desempeño' if type_name == 'performance' && lang == :es

    type_name
  end

  def presentable_type(lang = :en)
    Qualification.presentable_type(qualification_type, lang)
  end
end
