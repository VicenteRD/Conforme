module NumbersHelper
  def frequency_string(freq_n)
    frequency_hash.fetch(freq_n, '')
  end

  def frequency_hash
    {365 => 'Anual', 182 => 'Semestral', 122 => 'Trimestral', 30 => 'Mensual', 7 => 'Semanal', 1 => 'Diaria'}
  end

  def boolean_hash
    {true => 'Si', false => 'No'}
  end

  def chart_data(measurements, x_buffer, field_key = 'magnitude')

    # Instantiate a set of raw holders
    raw_dates = Set.new
    values = []
    thresholds = []

    measurements.each do |m|
      date = m.measured_at.to_date.to_time.to_i

      raw_dates.add(date)

      values.push({x: date, y: m[field_key.to_sym]})
      thresholds.push({x: date, y: m.threshold})
    end

    # Process the raw data into a hash for ease of use
    data = {}

    # We use an array that Javascript can read, instead of a set
    data[:numeric_dates] = raw_dates.to_a

    # For the hashes, we turn them into a string beforehand, and
    # modify it to match the JS format of a dict / hash.
    data[:values] = ruby_to_js_hash(values)
    data[:thresholds] = ruby_to_js_hash(thresholds)

    # Also add minX and maxX to ease the readability on the view itself.
    # Y ranges are not included, because they vary from risk type to risk type.
    data[:min_x] = data[:numeric_dates].first - x_buffer.hours.to_i
    data[:max_x] = data[:numeric_dates].last + x_buffer.hours.to_i

    data
  end

  private
  def ruby_to_js_hash(hash)
    hash.to_s.gsub(':x=>', 'x: ').gsub(':y=>', 'y: ')
  end
end