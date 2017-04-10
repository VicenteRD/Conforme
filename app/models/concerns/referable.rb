module Referable
  extend ActiveSupport::Concern

  EMBED_CHAR = '#'

  included do

    field :ref, as: :references, type: Hash # {class_name: [BSON::ObjectId]}

    def get_all_referred(klass)
      class_key = klass.name

      return nil unless referable_document?(klass) && references[class_key]

      if klass.embedded?
        return nil unless defined? klass.base_info
      end

      ret_array = []

      references[class_key].each do |object_id|
        puts object_id
        element = element_from_id(klass, object_id)
        puts element
        ret_array.append(element) unless element.nil?
      end

      ret_array
    end

    def add_references(key, *values)
      hash_key = case key
                 when Class
                   key.name
                 when Symbol
                   key
                 else # Assuming the key is a string
                   key.to_sym
                 end

      self.references = {} if references.nil?

      references[hash_key] = [] if self.references[hash_key].nil?

      values.each do |val|
        case val
        when Array
          references[hash_key].push(*val)
        else
          references[hash_key].push(val)
        end
      end
    end

    # Loads all the associations from an already set hash,
    # without overriding already-set values.
    def add_references_from_hash(hashed_values, base_id = '')
      hashed_values.each do |k, v|
        klass = k.constantize
        v.each do |id|
          obj = klass.find(id)
          prefix = base_id.empty? ? '' : base_id + '#'
          obj.add_references(self.class.name, prefix + self.id.to_s)
          obj.save!
        end

        add_references(k, v)
      end

      save!
    end

    def set_references_from_hash(hashed_values, base_id = '')
      self.references = {}
      add_references_from_hash(hashed_values, base_id)
    end

  end # included

  private

  def element_from_id(klass, object_id)
    if klass.embedded?
      ids = object_id.split(EMBED_CHAR)

      base_object = klass.base_info[:klass].find(ids[0])
      return nil unless base_object

      base_object.send(klass.base_info[:embeds_list]).find(ids[1])
    else
      klass.find(object_id)
    end
  end

  def referable_document?(klass)
    (klass < Mongoid::Document) && (klass < Referable)
  end

end
