module Risk
  class Measurement::Environmental < Measurement

    field :occ_t, as: :occurrence_time, type: Integer # -1, 0 or 1 (Past, present, future)
    field :op_s , as: :operational_situation, type: Integer # In settings, store possible values as keys of a hash with its literal names as values
    field :geo_a, as: :geographical_amplitude, type: Integer
    field :pub_b, as: :public_perception, type: Integer

    field :dir, as: :direct, type: Boolean
    field :pos, as: :positive, type: Boolean

    def calculate_magnitude
      self.index = self.op_situation + self.geo_amp + self.public_perception + self.reversible + self.control

      self.magnitude = self.index * self.probability
    end
  end
end
