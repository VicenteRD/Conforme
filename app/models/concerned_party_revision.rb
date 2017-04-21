class ConcernedPartyRevision
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include Describable

  embedded_in :concerned_party

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  field :rev_at, as: :revised_at, type: DateTime
end
