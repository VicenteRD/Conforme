module ApplicationHelper

  def print_responsible(id)
    if id && (responsible = Person::User.find(id))
      responsible.first_last_name
    else
      'ERR'
    end
  end

  def person_user_path(user)
    user_path(user)
  end

  def person_provider_path(provider)
    provider_path(provider)
  end

  def person_client_path(client)
    client_path(client)
  end

  def nav_select
    [
        ['Tareas', 'tasks', style: 'font-weight:bold'],
        ['Mejora', 'betterment', style: 'font-weight:bold'],
        ['Análisis', 'analysis', style: 'font-weight:bold'],
        ['Personas', 'employees', style: 'font-weight:bold'],
        ['Clientes', 'clients', style: 'font-weight:bold'],
        ['Proveedores', 'providers', style: 'font-weight:bold'],
        ['Activos', 'assets', style: 'font-weight:bold'],
        ['Planificación', 'planning', style: 'font-weight:bold'],
        ['Documentos', 'documents', style: 'font-weight:bold'],
        ['Estrategias', 'strategies', style: 'font-weight:bold'],
        %w(FODA Swot),
        %w(PESTA Peste),
        ['Partes Interesadas', 'ConcernedParty'],
        %w(Objetivos Objective),
        %w(Procesos BusinessProcess),
        %w(Comunicación Communication),


        ['Riesgos', 'risks', style: 'font-weight:bold'],
        ['Riesgos Operacionales', 'Risk::OperationalRisk'],
        ['Riesgos Ambientales', 'Risk::EnvironmentalRisk'],
        ['Riesgos Seguridad', 'Risk::SafetyRisk'],
        ['Riesgos Normativos', 'Risk::RuleRisk#standard'],
        ['Riesgos Legales', 'Risk::RuleRisk#law']
    ]
  end

  def nav_select_disabled
    %w(tasks betterment analysis employees clients providers assets planning documents strategies risks)
  end

end
