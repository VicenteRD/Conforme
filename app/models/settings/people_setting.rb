class Settings::PeopleSetting
  include Mongoid::Document

  field :audit_position_id, type: BSON::ObjectId
  field :staff_position_id, type: BSON::ObjectId
end
