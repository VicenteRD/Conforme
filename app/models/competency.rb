class Competency
  include Mongoid::Document

  field :phrase, type: String

  index({ phrase: 1 }, unique: true, name: 'phrase_index')
end
