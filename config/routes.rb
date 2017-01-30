Rails.application.routes.draw do

  get 'login'     => 'sessions#new'
  post 'login'    => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get '/'          => redirect('/dashboard')
  get '/dashboard' => 'dashboard#index'

  get '/personas'              => 'users#show'
  get '/personas/oganigrama'   => 'users#organization_chart'
  get '/personas/competencias' => 'users#eval_competencies'
  get '/personas/performance'  => 'users#eval_performance'
  get '/personas/clima'        => 'users#work_environment'

  get '/clientes'              => 'clients#show'
  get '/clientes/satisfaccion' => 'clients#satisfaction'

  get '/proveedores'              => 'providers#show'
  get '/proveedores/tipos'        => 'providers#types'
  get '/proveedores/competencias' => 'providers#eval_competencies'
  get '/proveedores/performance'  => 'providers#eval_performance'

  get '/tareas'           => 'tasks#index'      , as: :tasks
  get '/tareas/:type'     => 'tasks#index'      , as: :tasks_type
  get '/tareas/detalle/:id'       => 'tasks#show'       , as: :task
  get '/tareas/modal/:id' => 'tasks#show_modal' # , as: :modal_task

  get '/hallazgos'    => 'findings#index'
  get 'hallazgos/:id' => 'findings#show', as: :finding

  get '/analisis/indicadores' => 'indicators#show'

  get '/mantencion' => 'maintenance#index'

  get '/documentos' => 'documents#show'

  get '/normas' => 'standards#show'
  get '/leyes'  => 'laws#show'

  get '/foda' => 'swot#show'

  get '/partes-interesadas' => 'concerned_parties#show'

  get '/objetivos' => 'objectives#show'

  get '/procesos' => 'processes#show'

  get '/riesgos/:type'   => 'risks#index', as: :risks
  get '/riesgos/ambiente'  => 'risks#environment'
  get '/riesgos/seguridad' => 'risks#safety'
  get '/riesgos/normas'    => 'risks#standards'
  get '/riesgos/leyes'     => 'risks#laws'
  get '/riesgos/nuevo'     => 'risks#new', as: :new_risk
  get 'riesgos/detalle/:id' => 'risks#show', as: :risk
  get 'riesgos/detalle/:id/historial' => 'risks#history', as: :risk_history
  get '/riesgos/detalle/:id/nueva' => 'risks#new_measurement', as: :new_risk_measurement
  post '/riesgos/detalle/:id/nueva' => 'risks#create_measurement'

  get '/configuracion/riesgos'        => 'settings#risks'
  get '/configuracion/ambiente'       => 'settings#environment'
  get '/configuracion/seguridad'      => 'settings#safety'
  get '/configuracion/comunicaciones' => 'settings#communication'
  get '/configuracion/normas'         => 'settings#standards'
  get '/configuracion/cuestionarios'  => 'settings#questionnaires'

end
