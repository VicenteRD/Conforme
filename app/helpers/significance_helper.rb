module SignificanceHelper

  def significant_bgcolor(sig, hover = false)
    tag = 'background-color: '
    case sig
      when 0
        tag + (hover ? '#069225' : '#0eb132')
      when 1
        tag + (hover ? '#abab2c' : '#cccc37')
      when 2
        tag + (hover ? '#d6393f' : '#fb434a')
      else
        ''
    end
  end

  def significant_txtcolor(sig, hover = false)
    tag = 'color: '
    case sig
      when 0
        tag + (hover ? '#ffffff' : '#ffffff')
      when 1
        tag + (hover ? '#ffffff' : '#ffffff')
      when 2
        tag + (hover ? '#ffffff' : '#ffffff')
      else
        ''
    end
  end

  def significant_style(sig, hover = false)
    significant_bgcolor(sig, hover) + '; ' + significant_txtcolor(sig, hover)
  end

  def significant_style_css
    <<-EOS
.sig-0 {
  #{significant_style(0).sub('; ', ";\n  ")}
}
.sig-1 {
  #{significant_style(1).sub('; ', ";\n  ")}
}
.sig-2 {
  #{significant_style(2).sub('; ', ";\n  ")}
}

tr:hover .sig-0 {
  #{significant_style(0, true).sub('; ', ";\n  ")}
}

tr:hover .sig-1 {
  #{significant_style(1, true).sub('; ', ";\n  ")}
}

tr:hover .sig-2 {
  #{significant_style(2, true).sub('; ', ";\n  ")}
}
    EOS
  end

  def humanize_significant(sig)
    if sig == 0
      'No Significativo'
    elsif sig == 1 || sig == 2
      'Significativo'
    else
      'Sin mediciones'
    end
  end
end