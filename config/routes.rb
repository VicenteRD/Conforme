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
  get '/personas/organigrama'   => 'positions#index', as: :positions
  get '/personas/organigrama/detalle/:id'   => 'positions#show', as: :position
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

  post  '/analisis/indicadores/nuevo' => 'indicators#create'
  patch '/analisis/indicadores/editar/:id' => 'indicators#update'
  post  '/analisis/indicadores/:indicator_id/nueva' => 'indicator_measurements#create'
  patch '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#update'

  # -------- Assets

  get '/activos/:job_type'            => 'business_assets#index', as: :business_assets
  get '/activos/:job_type/nuevo'                => 'business_assets#new'  , as: :new_business_asset
  get '/activos/:job_type/:id'        => 'business_assets#show' , as: :business_asset
  get '/activos/:job_type/:id/editar' => 'business_assets#edit' , as: :edit_business_asset

  post  '/activos/:job_type/nuevo'        => 'business_assets#create'
  patch '/activos/:job_type/:id/editar'   => 'business_assets#update'

  get '/activos/:job_type/:asset_id/nuevo'       => 'business_asset_jobs#new' , as: :new_asset_job
  get '/activos/:job_type/:asset_id/editar/:id'  => 'business_asset_jobs#edit', as: :edit_asset_job

  post  '/activos/:job_type/:asset_id/nuevo'       => 'business_asset_jobs#create'
  patch '/activos/:job_type/:asset_id/editar/:id'  => 'business_asset_jobs#update'


  # --------

  get '/normas' => 'standards#show'
  get '/leyes'  => 'laws#show'

  get '/partes-interesadas' => 'concerned_parties#show'

  get '/objetivos' => 'objectives#show', as: :objective

  get 'posicion/:parent_id/nueva' => 'positions#new'

  # -------- Risks

  get '/riesgos/:type'                 => 'risks#index',            as: :risks
  get '/riesgos/:type/nuevo'           => 'risks#new',              as: :new_risk
  get '/riesgos/:id/editar'            => 'risks#edit',             as: :edit_risk
  get '/riesgos/:id'                   => 'risks#show',             as: :risk
  get '/riesgos/:risk_id/nueva'        => 'risk_measurements#new',  as: :new_risk_measurement
  get '/riesgos/:risk_id/:id/editar'   => 'risk_measurements#edit', as: :edit_risk_measurement
  get '/riesgos/:id/historial'         => 'risks#history',          as: :risk_history

  get '/riesgos/:id/:msrmnt_id'        => 'risk_measurements#show_details'

  post  '/riesgos/:type/nuevo'         => 'risks#create'
  patch '/riesgos/editar/:id'          => 'risks#update'
  post  '/riesgos/:risk_id/nueva'      => 'risk_measurements#create'
  patch '/riesgos/:risk_id/:id/editar' => 'risk_measurements#update'

  # -------- Configuration - TODO Maybe move them into their kind as 'settings' ?

  get '/configuracion/riesgos'        => 'settings#risks'
  get '/configuracion/ambiente'       => 'settings#environment'
  get '/configuracion/seguridad'      => 'settings#safety'
  get '/configuracion/comunicaciones' => 'settings#communication'
  get '/configuracion/normas'         => 'settings#standards'
  get '/configuracion/cuestionarios'  => 'settings#questionnaires'

  # -------- SWOT

  get '/FODA' => 'swot#index'
  get '/FODA/:id' => 'swot#show'

  # -------- Other

  get '/associables/:element/:name' => 'associables#list'

  get '/processes/:element'      => 'business_processes#list'
  get '/processes/:element/new'  => 'business_processes#new', as: :new_business_process
  post '/processes/:element/new' => 'business_processes#create'

end
