Rails.application.routes.draw do

  # -------- Root and Dashboard

  get '/'          => redirect('/dashboard')
  get '/dashboard' => 'dashboard#index'

  # -------- Sessions

  get 'login'     => 'sessions#new'
  post 'login'    => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  # -------- Employees

  get '/personas/fichas'          => 'users#index'            , as: :users
  get '/personas/fichas/nuevo'    => 'users#new'              , as: :new_user
  get '/personas/fichas/:id'      => 'users#show'             , as: :user

  get '/personas/organigrama'                  => 'positions#index', as: :positions
  get '/personas/organigrama/:parent_id/nueva' => 'positions#new'  , as: :new_position
  get '/personas/organigrama/:id'              => 'positions#show' , as: :position

  get '/personas/competencias'    => 'users#eval_competencies'
  get '/personas/desempeno'       => 'users#eval_performance'
  get '/personas/clima'           => 'users#work_environment'

  get '/clientes'              => 'clients#show'
  get '/clientes/satisfaccion' => 'clients#satisfaction'

  get '/proveedores'              => 'providers#show'
  get '/proveedores/tipos'        => 'providers#types'
  get '/proveedores/competencias' => 'providers#eval_competencies'
  get '/proveedores/performance'  => 'providers#eval_performance'

  get '/tareas'           => 'tasks#index'       , as: :tasks
  get '/tareas/:type'     => 'tasks#index'       , as: :tasks_type
  get '/tareas/detalle/:id'       => 'tasks#show', as: :task

  get '/hallazgos'    => 'findings#index'
  get 'hallazgos/:id' => 'findings#show', as: :finding

  # -------- Indicators

  get '/analisis/indicadores'            => 'indicators#index', as: :indicators
  get '/analisis/indicadores/nuevo'      => 'indicators#new'  , as: :new_indicator
  get '/analisis/indicadores/:id'        => 'indicators#show' , as: :indicator
  get '/analisis/indicadores/:id/editar' => 'indicators#edit' , as: :edit_indicator

  get '/analisis/indicadores/:indicator_id/nueva'      => 'indicator_measurements#new' ,
      as: :new_indicator_measurement
  get '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#edit',
      as: :edit_indicator_measurement

  post  '/analisis/indicadores/nuevo'                    => 'indicators#create'
  patch '/analisis/indicadores/:id/editar'               => 'indicators#update'

  post  '/analisis/indicadores/:indicator_id/nueva'      => 'indicator_measurements#create'
  patch '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#update'

  # -------- Assets

  get '/activos/:job_type'            => 'business_assets#index', as: :business_assets
  get '/activos/:job_type/nuevo'      => 'business_assets#new'  , as: :new_business_asset
  get '/activos/:job_type/:id'        => 'business_assets#show' , as: :business_asset
  get '/activos/:job_type/:id/editar' => 'business_assets#edit' , as: :edit_business_asset

  get '/activos/:job_type/:asset_id/nuevo'       => 'business_asset_jobs#new' , as: :new_asset_job
  get '/activos/:job_type/:asset_id/:id/editar'  => 'business_asset_jobs#edit', as: :edit_asset_job

  post  '/activos/:job_type/nuevo'                 => 'business_assets#create'
  patch '/activos/:job_type/:id/editar'            => 'business_assets#update'

  post  '/activos/nuevo-tipo'                      => 'business_assets#create_type',
        as: :new_business_asset_type

  post  '/activos/:job_type/:asset_id/nuevo'       => 'business_asset_jobs#create'
  patch '/activos/:job_type/:asset_id/:id/editar'  => 'business_asset_jobs#update'

  # -------- Planning

  get '/planificacion'            => 'plannings#index', as: :plannings
  get '/planificacion/nueva'      => 'plannings#new'  , as: :new_planning
  get '/planificacion/:id'        => 'plannings#show' , as: :planning
  get '/planificacion/:id/editar' => 'plannings#edit' , as: :edit_planning

  get '/planificacion/:plan_id/nueva'      => 'planning_activities#new' ,
      as: :new_planning_activity
  get '/planificacion/:plan_id/:id/editar' => 'planning_activities#edit',
      as: :edit_planning_activity

  post  '/planificacion/nueva'               => 'plannings#create'
  patch '/planificacion/:id/editar'          => 'plannings#update'

  post  '/planificacion/:plan_id/nueva'      => 'planning_activities#create'
  patch '/planificacion/:plan_id/:id/editar' => 'planning_activities#update'

  # -------- SWOT

  get '/FODA'            => 'swot#index', as: :swot_index
  get '/FODA/nuevo'      => 'swot#new'  , as: :new_swot
  get '/FODA/:id'        => 'swot#show' , as: :swot
  get '/FODA/:id/editar' => 'swot#edit' , as: :edit_swot

  post  '/FODA/nuevo'      => 'swot#create'
  patch '/FODA/:id/editar' => 'swot#update'

  # -------- ConcernedParties

  get '/partes-interesadas'            => 'concerned_parties#index', as: :concerned_parties
  get '/partes-interesadas/nuevo'      => 'concerned_parties#new'  , as: :new_concerned_party
  get '/partes-interesadas/:id'        => 'concerned_parties#show' , as: :concerned_party
  get '/partes-interesadas/:id/editar' => 'concerned_parties#edit' , as: :edit_concerned_party

  post  '/partes-interesadas/nuevo'      => 'concerned_parties#create'
  patch '/partes-interesadas/:id/editar' => 'concerned_parties#update'

  # -------- Objectives

  get '/objetivos'            => 'objectives#index', as: :objectives
  get '/objetivos/nuevo'      => 'objectives#new'  , as: :new_objective
  get '/objetivos/:id'        => 'objectives#show' , as: :objective
  get '/objetivos/:id/editar' => 'objectives#edit' , as: :edit_objective

  post  '/objetivos/nuevo'      => 'objectives#create'
  patch '/objetivos/:id/editar' => 'objectives#update'

  # -------- BusinessProcesses

  get '/procesos'            => 'business_processes#index', as: :business_processes
  get '/procesos/nuevo'      => 'business_processes#new'  , as: :new_business_process
  get '/procesos/:id'        => 'business_processes#show' , as: :business_process
  get '/procesos/:id/editar' => 'business_processes#edit' , as: :edit_business_process

  post  '/procesos/nuevo'      => 'business_processes#create'
  patch '/procesos/:id/editar' => 'business_processes#update'

  # -------- Risks

  get '/riesgos/:type'            => 'risks#index', as: :risks
  get '/riesgos/:type/nuevo'      => 'risks#new'  , as: :new_risk
  get '/riesgos/:type/:id'        => 'risks#show' , as: :risk
  get '/riesgos/:type/:id/editar' => 'risks#edit' , as: :edit_risk

  get '/riesgos/:type/:risk_id/nueva'      => 'risk_measurements#new' , as: :new_risk_measurement
  get '/riesgos/:type/:risk_id/:id/editar' => 'risk_measurements#edit', as: :edit_risk_measurement

  post  '/riesgos/:type/nuevo'         => 'risks#create'
  patch '/riesgos/:type/:id/editar/'   => 'risks#update'

  post  '/riesgos/:type/:risk_id/nueva'      => 'risk_measurements#create'
  patch '/riesgos/:type/:risk_id/:id/editar' => 'risk_measurements#update'

  # -------- Configuration - TODO Maybe move them into their kind as 'settings' ?

  get '/configuracion/riesgos'        => 'settings#risks'
  get '/configuracion/ambiente'       => 'settings#environment'
  get '/configuracion/seguridad'      => 'settings#safety'
  get '/configuracion/comunicaciones' => 'settings#communication'
  get '/configuracion/normas'         => 'settings#standards'
  get '/configuracion/cuestionarios'  => 'settings#questionnaires'

  # -------- Other

  get '/referables/:class_name/:extra' => 'referables#render_list'

  post '/documentos/reglas/nuevo' => 'rules#create', as: :new_rule

  post '/uploads/new' => 'uploaded_files#create', as: :new_upload
end
