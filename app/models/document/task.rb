class Document::Task < Task
  include Mongoid::Document

  belongs_to :document, class_name: 'Document'


end
