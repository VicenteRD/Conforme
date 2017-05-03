class QuestionnaireResponse
  include Mongoid::Document

  embedded_in :questionnaire
end
