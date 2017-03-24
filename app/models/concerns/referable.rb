module Referable
  extend ActiveSupport::Concern

  EMBED_CHAR = '#'

  included do

    field :ref, as: :references, type: Hash # {class_name: [BSON::ObjectId]}

    def get_all_referred(klass, base_klass = nil, embeds_list = '')
      unless is_referable_document? klass
        return nil
      end

      class_key = klass.name
      ret_array = []

      if self.references[class_key]
        self.references[class_key].each do |object_id|
          if object_id.include? EMBED_CHAR
            if base_klass.nil? || embeds_list.nil? || embeds_list.empty?
              next
            end

            ids = object_id.sub(EMBED_CHAR)

            if (base_object = base_klass.find(ids[0]))
              element = base_object[embeds_list].find(ids[1])
            else
              next
            end
          else
            element = klass.find(object_id)
          end

          ret_array.append(element)
        end
      end

      ret_array == [] ? nil : ret_array
    end

    def add_references(key, *values)
      case key
        when Class
          hash_key = key.name
        when Symbol
          hash_key = key
        else # Assuming the key is a string
          hash_key = key.to_sym
      end

      if self.references.nil?
        self.references = {}
      end

      if self.references[hash_key].nil?
        self.references[hash_key] = []
      end

      values.each do |val|
        case val
          when Array
            self.references[hash_key].push(*val)
          else
            self.references[hash_key].push(val)
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

        self.add_references(k, v)
      end

      self.save!
    end

    def set_references_from_hash(hashed_values, base_id = '')
      self.references = {}
      add_references_from_hash(hashed_values, base_id)
    end

  end # included

  ## Helper methods
  private
  def is_referable_document?(klass)
    (klass < Mongoid::Document) && (klass < Referable)
  end

end
