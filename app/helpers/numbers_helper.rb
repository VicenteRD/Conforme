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
end