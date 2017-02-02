module NumbersHelper
  def frequency_string(freq_n)
    case freq_n
      when 1
        'diaria'
      when 7
        'semanal'
      when 30
        'mensual'
      when 122
        'trimestral'
      when 182
        'semestral'
      when 365
        'anual'
      else
        '??'
    end
  end
end