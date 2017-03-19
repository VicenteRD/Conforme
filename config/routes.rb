Rails.application.routes.draw do

  get 'employee_evaluations/index'

  get 'employee_evaluations/show'

  get 'employee_evaluations/new'

  get 'employee_evaluations/create'

  get 'provider_evaluations/index'

  get 'provider_evaluations/show'

  get 'provider_evaluations/new'

  get 'provider_evaluations/create'

  # -------- Root and Dashboard

  get '/'          => redirect('/dashboard')
  get '/dashboard' => 'dashboard#index'

  # -------- Sessions

  get 'login'     => 'sessions#new'
  post 'login'    => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  # -------- Unsorted

  get '/tareas'           => 'tasks#index'       , as: :tasks
  get '/tareas/:type'     => 'tasks#index'       , as: :tasks_type
  get '/tareas/detalle/:id'   => 'tasks#show', as: :task

  get '/hallazgos'    => 'findings#index'
  get 'hallazgos/:id' => 'findings#show', as: :finding

  # -------- Employees

  # Employees Files
  get '/personas/fichas'            => 'users#index', as: :users
  get '/personas/fichas/nuevo'      => 'users#new'  , as: :new_user
  get '/personas/fichas/:id'        => 'users#show' , as: :user
  get '/personas/fichas/:id/editar' => 'users#edit' , as: :edit_user

  post  '/personas/fichas/nuevo'      => 'users#create'
  patch '/personas/fichas/:id/editar' => 'users#update'

  # Organization Chart
  get '/personas/organigrama'                  => 'positions#index', as: :positions
  get '/personas/organigrama/:parent_id/nueva' => 'positions#new'  , as: :new_position
  get '/personas/organigrama/:id'              => 'positions#show' , as: :position
  get '/personas/organigrama/:id/editar'       => 'positions#edit' , as: :edit_position

  post  '/personas/organigrama/:parent_id/nuevo' => 'positions#create'
  patch '/personas/organigrama/:id/editar'       => 'positions#update'

  # Competencies & Performance evaluations, Climate
  get '/personas/evaluaciones/clima'       => 'users#work_environment'  # ??
  get '/personas/evaluaciones/:type'       => 'employee_evaluations#index', as: :employee_evaluations
  get '/personas/evaluaciones/:type/nuevo' => 'employee_evaluations#new'  , as: :new_employee_evaluation
  get '/personas/evaluaciones/:type/:id'   => 'employee_evaluations#show' , as: :employee_evaluation

  post '/personas/evaluaciones/:type/nuevo' => 'employee_evaluations#create'

  # -------- Clients

  # Clients Files,tipo,sat
  get '/clientes/fichas'            => 'clients#index', as: :clients
  get '/clientes/fichas/nuevo'      => 'clients#new'  , as: :new_client
  get '/clientes/fichas/:id'        => 'clients#show' , as: :client
  get '/clientes/fichas/:id/editar' => 'clients#edit' , as: :edit_client

  post  '/clientes/fichas/nuevo'      => 'clients#create'
  patch '/clientes/fichas/:id/editar' => 'clients#update'

  # Client Types
  get '/clientes/tipos'            => 'client_types#index', as: :client_types
  get '/clientes/tipos/nuevo'      => 'client_types#new'  , as: :new_client_type
  get '/clientes/tipos/:id'        => 'client_types#show' , as: :client_type
  get '/clientes/tipos/:id/editar' => 'client_types#edit' , as: :edit_client_type

  post  '/clientes/tipos/nuevo'      => 'client_types#create'
  patch '/clientes/tipos/:id/editar' => 'client_types#update'

  # Client Satisfaction (??)
  get '/clientes/satisfaccion' => 'clients#satisfaction' # ??

  # -------- Providers

  # Providers Files
  get '/proveedores/fichas'        => 'providers#index', as: :providers
  get '/proveedores/fichas/nuevo'  => 'providers#new'  , as: :new_provider
  get '/proveedores/fichas/:id'    => 'providers#show' , as: :provider
  get '/proveedores/fichas/editar' => 'providers#edit' , as: :edit_provider

  post  '/proveedores/fichas/nuevo'      => 'providers#create'
  patch '/proveedores/fichas/:id/editar' => 'providers#update'

  # Provider Types
  get '/proveedores/tipos'            => 'provider_types#index', as: :provider_types
  get '/proveedores/tipos/nuevo'      => 'provider_types#new'  , as: :new_provider_type
  get '/proveedores/tipos/:id'        => 'provider_types#show' , as: :provider_type
  get '/proveedores/tipos/:id/editar' => 'provider_types#edit' , as: :edit_provider_type

  post  '/proveedores/tipos/nuevo'      => 'provider_types#create'
  patch '/proveedores/tipos/:id/editar' => 'provider_types#update'

  # Competencies & Performance evaluations
  get '/proveedores/evaluaciones/:type'       => 'provider_evaluations#index', as: :provider_evaluations
  get '/proveedores/evaluaciones/:type/nuevo' => 'provider_evaluations#new'  , as: :new_provider_evaluation
  get '/proveedores/evaluaciones/:type/:id'   => 'provider_evaluations#show' , as: :provider_evaluation

  post '/proveedores/evaluaciones/:type/nuevo' => 'provider_evaluations#create'

  # -------- Analysis: Indicators

  get '/analisis/indicadores'            => 'indicators#index', as: :indicators
  get '/analisis/indicadores/nuevo'      => 'indicators#new'  , as: :new_indicator
  get '/analisis/indicadores/:id'        => 'indicators#show' , as: :indicator
  get '/analisis/indicadores/:id/editar' => 'indicators#edit' , as: :edit_indicator

  get '/analisis/indicadores/:indicator_id/nueva'      => 'indicator_measurements#new' ,
      as: :new_indicator_measurement
  get '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#edit',
      as: :edit_indicator_measurement

  post  '/analisis/indicadores/nuevo'      => 'indicators#create'
  patch '/analisis/indicadores/:id/editar' => 'indicators#update'

  post  '/analisis/indicadores/:indicator_id/nueva'      => 'indicator_measurements#create'
  patch '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#update'

  # -------- Assets

  get '/activos/:job_type'            => 'business_assets#index', as: :business_assets
  get '/activos/:job_type/nuevo'      => 'business_assets#new'  , as: :new_business_asset
  get '/activos/:job_type/:id'        => 'business_assets#show' , as: :business_asset
  get '/activos/:job_type/:id/editar' => 'business_assets#edit' , as: :edit_business_asset

  get '/activos/:job_type/:asset_id/nuevo'       => 'business_asset_jobs#new' , as: :new_asset_job
  get '/activos/:job_type/:asset_id/:id/editar'  => 'business_asset_jobs#edit', as: :edit_asset_job

  post  '/activos/nuevo-tipo' => 'business_assets#create_type', as: :new_business_asset_type

  post  '/activos/:job_type/nuevo'                 => 'business_assets#create'
  patch '/activos/:job_type/:id/editar'            => 'business_assets#update'

  post  '/activos/:job_type/:asset_id/nuevo'       => 'business_asset_jobs#create'
  patch '/activos/:job_type/:asset_id/:id/editar'  => 'business_asset_jobs#update'

  # -------- Planning

  get '/planificacion'            => 'plannings#index', as: :plannings
  get '/planificacion/nueva'      => 'plannings#new'  , as: :new_planning
  get '/planificacion/:id'        => 'plannings#show' , as: :planning
  get '/planificacion/:id/editar' => 'plannings#edit' , as: :edit_planning

  get '/planificacion/:plan_id/nueva'      => 'planning_activities#new' , as: :new_planning_activity
  get '/planificacion/:plan_id/:id/editar' => 'planning_activities#edit', as: :edit_planning_activity

  post  '/planificacion/nueva'               => 'plannings#create'
  patch '/planificacion/:id/editar'          => 'plannings#update'

  post  '/planificacion/:plan_id/nueva'      => 'planning_activities#create'
  patch '/planificacion/:plan_id/:id/editar' => 'planning_activities#update'

  # -------- Documents

  post '/documentos/reglas/nuevo' => 'rules#create', as: :new_rule

  # -- Uploads
  get '/documentos/archivos'       => 'uploaded_files#index', as: :uploaded_files
  get '/documentos/archivos/nuevo' => 'uploaded_files#new'  , as: :new_uploaded_file

  post '/documentos/archivos/nuevo' => 'uploaded_files#create'

  # -------- Strategies: SWOT

  get '/estrategias/FODA'            => 'swot#index', as: :swot_index
  get '/estrategias/FODA/nuevo'      => 'swot#new'  , as: :new_swot
  get '/estrategias/FODA/:id'        => 'swot#show' , as: :swot
  get '/estrategias/FODA/:id/editar' => 'swot#edit' , as: :edit_swot

  post  '/estrategias/FODA/nuevo'      => 'swot#create'
  patch '/estrategias/FODA/:id/editar' => 'swot#update'

  # -------- Strategies: ConcernedParties

  get '/estrategias/partes-interesadas'            => 'concerned_parties#index', as: :concerned_parties
  get '/estrategias/partes-interesadas/nuevo'      => 'concerned_parties#new'  , as: :new_concerned_party
  get '/estrategias/partes-interesadas/:id'        => 'concerned_parties#show' , as: :concerned_party
  get '/estrategias/partes-interesadas/:id/editar' => 'concerned_parties#edit' , as: :edit_concerned_party

  post  '/estrategias/partes-interesadas/nuevo'      => 'concerned_parties#create'
  patch '/estrategias/partes-interesadas/:id/editar' => 'concerned_parties#update'

  # -------- Strategies: Objectives

  get '/estrategias/objetivos'            => 'objectives#index', as: :objectives
  get '/estrategias/objetivos/nuevo'      => 'objectives#new'  , as: :new_objective
  get '/estrategias/objetivos/:id'        => 'objectives#show' , as: :objective
  get '/estrategias/objetivos/:id/editar' => 'objectives#edit' , as: :edit_objective

  post  '/estrategias/objetivos/nuevo'      => 'objectives#create'
  patch '/estrategias/objetivos/:id/editar' => 'objectives#update'

  # -------- Strategies: BusinessProcesses

  get '/estrategias/procesos'            => 'business_processes#index', as: :business_processes
  get '/estrategias/procesos/nuevo'      => 'business_processes#new'  , as: :new_business_process
  get '/estrategias/procesos/:id'        => 'business_processes#show' , as: :business_process
  get '/estrategias/procesos/:id/editar' => 'business_processes#edit' , as: :edit_business_process

  post  '/estrategias/procesos/nuevo'      => 'business_processes#create'
  patch '/estrategias/procesos/:id/editar' => 'business_processes#update'

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

  # -------- Settings

  get '/configuracion/riesgos'        => 'settings#risks'
  get '/configuracion/ambiente'       => 'settings#environment'
  get '/configuracion/seguridad'      => 'settings#safety'
  get '/configuracion/comunicaciones' => 'settings#communication'
  get '/configuracion/normas'         => 'settings#standards'
  get '/configuracion/cuestionarios'  => 'settings#questionnaires'

  # -------- Other

  get '/referables/:class_name/:extra' => 'referables#render_list'
end
