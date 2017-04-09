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

  def dt_mask_format(time = false)
    '00/00/0000' + (time ? ' - 00:00' : '')
  end

  def show_formatted_date(date)
    show_dt(date, dt_rb_format(false, false))
  end

  def show_formatted_datetime(datetime)
    show_dt(datetime, dt_rb_format(true, false))
  end

  def server_timezone
    Time.zone.now.strftime('%z')
  end

  def parse_datetime(date_string, time = true)
    return unless date_string
    dt_klass = time ? DateTime : Date
    dt_klass.strptime(
      "#{date_string} #{server_timezone}",
      dt_rb_format(time)
    )
  end

  private

  def show_dt(dt, format = nil)
    return dt if format.nil?

    dt ? dt.strftime(format) : '-'
  end
end