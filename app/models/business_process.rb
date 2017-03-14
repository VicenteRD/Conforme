class BusinessProcess
  include Mongoid::Document

  field :name, type: String

  field :p_type, as: :process_type, type: String

  field :desc, as: :description, type: String

  field :r_id, as: :responsible_id, type: BSON::ObjectId

  field :cmts, as: :comments, type: String

  index({name: 1}, {unique: true, name: 'name_index'})

  def self.get_all_types
    ['Cadena de Valor', 'Gestión', 'Apoyo', 'Estrategia']
  end

  def presentable_type
    if self.process_type.nil?
      'ERR'
    else
      BusinessProcess.get_all_types[self.process_type]
    end
  end
end
