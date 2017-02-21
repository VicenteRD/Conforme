Rails.application.routes.draw do

  get 'business_processes/list'

  get 'business_processes/new'

  # -------- Root and Dashboard

  get '/'          => redirect('/dashboard')
  get '/dashboard' => 'dashboard#index'

  # -------- Sessions

  get 'login'     => 'sessions#new'
  post 'login'    => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  # -------- Uploads

  post '/upload'  => 'uploaded_files#create'

  get '/personas'              => 'users#index'
  get '/personas/ficha/:id'    => 'users#show', as: :user
  get '/personas/oganigrama'   => 'positions#show'
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

  # -------- Indicators

  get '/analisis/indicadores' => 'indicators#index', as: :indicators
  get '/analisis/indicadores/detalle/:id' => 'indicators#show', as: :indicator
  get '/analisis/indicadores/nuevo' => 'indicators#new', as: :new_indicator
  get '/analisis/indicadores/editar/:id' => 'indicators#edit', as: :edit_indicator
  get '/analisis/indicadores/detalle/:indicator_id/:id' => 'indicator_measurements#show_details'

  get '/analisis/indicadores/:indicator_id/nueva' => 'indicator_measurements#new',
      as: :new_indicator_measurement
  get '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#edit',
      as: :edit_indicator_measurement

  post '/analisis/indicadores/nuevo' => 'indicators#create'
  patch '/analisis/indicadores/editar/:id' => 'indicators#update'
  post '/analisis/indicadores/:indicator_id/nueva' => 'indicator_measurements#create'
  patch '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#update'


  get '/mantencion' => 'maintenance#index'

  get '/documentos' => 'documents#show'

  get '/normas' => 'standards#show'
  get '/leyes'  => 'laws#show'

  get '/foda' => 'swot#show'

  get '/partes-interesadas' => 'concerned_parties#show'

  get '/objetivos' => 'objectives#show', as: :objective

  get 'posicion/:parent_id/nueva' => 'positions#new'

  # -------- Risks

  get '/riesgos/:type'                       => 'risks#index',            as: :risks
  get '/riesgos/:type/nuevo'                 => 'risks#new',              as: :new_risk
  get '/riesgos/editar/:id'                  => 'risks#edit',             as: :edit_risk
  get '/riesgos/detalle/:id'                 => 'risks#show',             as: :risk
  get '/riesgos/detalle/:risk_id/nueva'      => 'risk_measurements#new',  as: :new_risk_measurement
  get '/riesgos/:risk_id/:id/editar'         => 'risk_measurements#edit', as: :edit_risk_measurement
  get '/riesgos/detalle/:id/historial'       => 'risks#history',          as: :risk_history

  get '/riesgos/detalle/:id/:msrmnt_id'      => 'risk_measurements#show_details'

  post  '/riesgos/:type/nuevo'               => 'risks#create'
  patch '/riesgos/editar/:id'                => 'risks#update'
  post  '/riesgos/detalle/:risk_id/nueva'    => 'risk_measurements#create'
  patch '/riesgos/:risk_id/:id/editar'       => 'risk_measurements#update'

  # -------- Configuration - TODO Maybe move them into their kind as 'settings' ?

  get '/configuracion/riesgos'        => 'settings#risks'
  get '/configuracion/ambiente'       => 'settings#environment'
  get '/configuracion/seguridad'      => 'settings#safety'
  get '/configuracion/comunicaciones' => 'settings#communication'
  get '/configuracion/normas'         => 'settings#standards'
  get '/configuracion/cuestionarios'  => 'settings#questionnaires'

  # -------- Other

  get '/associables/:element/:name' => 'associables#list'

  get '/processes/:element'      => 'business_processes#list'
  get '/processes/:element/new'  => 'business_processes#new', as: :new_business_process
  post '/processes/:element/new' => 'business_processes#create'

end
