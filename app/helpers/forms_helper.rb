module FormsHelper
  def es_months
    %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
  end

  def dt_rb_format(time = false, tz = true)
    '%d/%m/%Y' + (time ? ' - %H:%M' : '') + (tz ? ' %z' : '')
  end

  def dt_form_format(time = false)
    'DD/MM/YYYY' + (time ? ' - HH:mm' : '')
  end

  def date_from_hash(date_hash, form_name)
    DateTime.new(date_hash[form_name + '(1i)'].to_i,
                 date_hash[form_name + '(2i)'].to_i,
                 date_hash[form_name + '(3i)'].to_i,
                 date_hash[form_name + '(4i)'].to_i,
                 date_hash[form_name + '(5i)'].to_i)
  end
end