module FormsHelper
  def es_months
    %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
  end

  def dt_select_cl_format(fields = [:hour, :minute, :day, :month, :year])
    {
        default: Time.zone.now,
        order: fields,
        use_month_names: es_months
    }
  end

  def date_from_hash(date_hash, form_name)
    DateTime.new(date_hash[form_name + '(1i)'].to_i,
                 date_hash[form_name + '(2i)'].to_i,
                 date_hash[form_name + '(3i)'].to_i,
                 date_hash[form_name + '(4i)'].to_i,
                 date_hash[form_name + '(5i)'].to_i)
  end
end