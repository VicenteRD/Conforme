module RisksHelper

  def minimize_type(class_name)
    case class_name
      when 'Risk::OperationalRisk'
        'operational'
      when 'Risk::EnvironmentalRisk'
        'environmental'
      when 'Risk::SafetyRisk'
        'safety'
      when 'Risk::RuleRisk'
        'rule'
      else
        nil
    end
  end

  def rule_type_breadcrumb(type)
    if type == 1
      link_to 'Riesgos Legales', risks_path('ley')
    elsif type == 2
      link_to 'Riesgos Normativos', risks_path('norma')
    end
  end

  def significant_bgcolor(sig, hover = false)
    tag = 'background-color: '
    case sig
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

.risk-sig-0 {
  /* Intentionally left blank. */
}
.risk-sig-1 {
  #{significant_style(1).sub('; ', ";\n  ")}
}
.risk-sig-2 {
  #{significant_style(2).sub('; ', ";\n  ")}
}

tr:hover .risk-sig-1 {
  #{significant_style(1, true).sub('; ', ";\n  ")}
}

tr:hover .risk-sig-2 {
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

  def ppf?(n)
    case n
      when -1
        'Pasado'
      when 0
        'Presente'
      when 1
        'Futuro'
      else
        '?'
    end
  end

  def direct?(dir)
    dir ? 'Directo' : 'Indirecto'
  end

  def positive?(pos)
    pos ? 'Positivo' : 'Negativo'
  end

  private
  def ruby_to_js_hash(hash)
    hash.to_s.gsub(':x=>', 'x: ').gsub(':y=>', 'y: ')
  end

end
