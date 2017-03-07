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

  def es_type(type)
    if type == 1
      'ley'
    elsif type == 2
      'norma'
    end
  end
end
