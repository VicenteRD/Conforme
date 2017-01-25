module Associable
  extend ActiveSupport::Concern

  included do
    receiver.class_eval do

      field :audits             , type: Array
      field :concerned_parties  , type: Array
      field :definitions        , type: Array
      field :documents          , type: Array
      field :findings           , type: Array
      field :indicators         , type: Array
      field :management_reviews , type: Array
      field :minutes            , type: Array
      field :objectives         , type: Array
      field :plannings          , type: Array
      field :people             , type: Array
      field :positions          , type: Array
      field :process_types      , type: Array
      field :risks              , type: Array
      field :standards          , type: Array
      field :swot               , type: Array
      field :tasks              , type: Array
      field :uploaded_files     , type: Array

    end
  end
end
