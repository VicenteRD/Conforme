module DatesHelper
  def es_months
    %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
  end

  def dt_rb_format(time = false, tz = true)
    '%d/%m/%Y' + (time ? ' - %H:%M' : '') + (tz ? ' %z' : '')
  end

  def dt_form_format(time = false)
    'DD/MM/YYYY' + (time ? ' - HH:mm' : '')
  end

  def server_timezone
    Time.zone.now.strftime('%z')
  end

  def parse_datetime(date_string, time = true)
    if date_string
      DateTime.strptime(
          "#{date_string} #{server_timezone}",
          dt_rb_format(time)
       )
    else
      nil
    end
  end
end