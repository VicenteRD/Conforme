class Risk::Operational < Risk

  embeds_many :measurements, class_name: 'Risk::OperationalMeasurement'

  field :name, type: String

  def new_measurement(author_id, values)
    settings = Settings::RiskSettings.first

    self.measurements.create(values)
    measurement = self.measurements.last


    significant = 0
    if settings && settings[:operational_threshold] && settings[:margin]
      if measurement.magnitude >= (settings[:operational_threshold] * (1.0 + (settings[:margin] / 100)))
        significant = 2
      elsif measurement.magnitude >= settings[:operational_threshold]
        significant = 1
      end
    end

    measurement.significant = significant

    super(author_id, significant, measurement.comments)
  end
end
