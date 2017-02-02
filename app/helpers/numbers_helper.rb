module NumbersHelper
  def frequency_string(freq_n)
    frequency_hash.fetch(freq_n, '')
  end

  def frequency_hash
    {1 => 'Diaria', 7 => 'Semanal', 30 => 'Mensual', 122 => 'Trimestral', 182 => 'Semestral',  365 => 'Anual'}
  end
end