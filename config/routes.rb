Rails.application.routes.draw do

  # -------- Root and Dashboard

  get '/'          => redirect('/dashboard')
  get '/dashboard' => 'dashboard#index'

  # -------- Sessions

  get 'login'     => 'sessions#new'
  post 'login'    => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  # -------- Unsorted

  get '/tareas'           => 'tasks#index'   , as: :tasks
  get '/tareas/:type'     => 'tasks#index'   , as: :tasks_type
  get '/tareas/detalle/:id'   => 'tasks#show', as: :task

  get '/hallazgos'    => 'findings#index'
  get 'hallazgos/:id' => 'findings#show', as: :finding

  # -------- Betterment

  # -- Audit Programs

  get '/mejora/auditoria'            => 'audit_programs#index', as: :audit_programs
  get '/mejora/auditoria/nuevo'      => 'audit_programs#new',   as: :new_audit_program
  get '/mejora/auditoria/:id'        => 'audit_programs#show',  as: :audit_program
  get '/mejora/auditoria/:id/editar' => 'audit_programs#edit',  as: :edit_audit_program

  post  '/mejora/auditoria/nuevo'            => 'audit_programs#create'

  # --- Audits

  get '/mejoras/auditoria/:program_id' => 'audits#index', as: :audits
  get '/mejora/auditoria/:program_id/nuevo'      => 'audits#new', as: :new_audit
  get '/mejoras/auditoria/:program_id/:id' => 'audits#show', as: :audit

  post  '/mejora/auditoria/:program_id/nuevo'            => 'audits#create'


  #get '/analisis/indicadores/:indicator_id/nueva'      => 'indicator_measurements#new' ,
  #    as: :new_indicator_measurement
  #get '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#edit',
  #    as: :edit_indicator_measurement

  #patch '/analisis/indicadores/:id/editar'       => 'indicators#update'
  #patch '/analisis/indicadores/edit-attachments' => 'indicators#edit_attachments'

  #post  '/analisis/indicadores/:indicator_id/nueva'      => 'indicator_measurements#create'
  #patch '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#update'

  # -------- Employees

  # Employees Files
  get '/personas/fichas'            => 'users#index', as: :users
  get '/personas/fichas/nuevo'      => 'users#new',   as: :new_user
  get '/personas/fichas/:id'        => 'users#show',  as: :user
  get '/personas/fichas/:id/editar' => 'users#edit',  as: :edit_user

  post  '/personas/fichas/nuevo'            => 'users#create'
  patch '/personas/fichas/:id/editar'       => 'users#update'
  patch '/personas/fichas/edit-attachments' => 'users#edit_attachments'


  # Organization Chart
  get '/personas/organigrama'            => 'positions#index', as: :positions
  get '/personas/organigrama/nueva'      => 'positions#new',   as: :new_position
  get '/personas/organigrama/:id'        => 'positions#show',  as: :position
  get '/personas/organigrama/:id/editar' => 'positions#edit',  as: :edit_position

  post  '/personas/organigrama/nueva'             => 'positions#create'
  patch '/personas/organigrama/:id/editar'        => 'positions#update'
  patch '/personas/:organigrama/edit-attachments' => 'positions#edit_attachments'

  # Competencies & Performance evaluations, Climate
  get '/personas/evaluaciones/clima'       => 'users#work_environment' # ??
  get '/personas/evaluaciones/:type'       => 'employee_evaluations#index', as: :employee_evaluations
  get '/personas/evaluaciones/:type/nuevo' => 'employee_evaluations#new',   as: :new_employee_evaluation
  get '/personas/evaluaciones/:type/:id'   => 'employee_evaluations#show',  as: :employee_evaluation

  post '/personas/evaluaciones/:type/nuevo' => 'employee_evaluations#create'

  # -------- Clients

  # Clients Files
  get '/clientes/fichas'            => 'clients#index', as: :clients
  get '/clientes/fichas/nuevo'      => 'clients#new',   as: :new_client
  get '/clientes/fichas/:id'        => 'clients#show',  as: :client
  get '/clientes/fichas/:id/editar' => 'clients#edit',  as: :edit_client

  post  '/clientes/fichas/nuevo'            => 'clients#create'
  patch '/clientes/fichas/:id/editar'       => 'clients#update'
  patch '/clientes/fichas/edit-attachments' => 'clients#edit_attachments'


  # Client Types
  get '/clientes/tipos'            => 'client_types#index', as: :client_types
  get '/clientes/tipos/nuevo'      => 'client_types#new',   as: :new_client_type
  get '/clientes/tipos/:id'        => 'client_types#show',  as: :client_type
  get '/clientes/tipos/:id/editar' => 'client_types#edit',  as: :edit_client_type

  post  '/clientes/tipos/nuevo'            => 'client_types#create'
  patch '/clientes/tipos/:id/editar'       => 'client_types#update'
  patch '/clientes/tipos/edit-attachments' => 'client_types#edit_attachments'


  # Client Satisfaction (??)
  get '/clientes/satisfaccion' => 'clients#satisfaction' # ??

  # -------- Providers

  # Providers Files
  get '/proveedores/fichas'            => 'providers#index', as: :providers
  get '/proveedores/fichas/nuevo'      => 'providers#new',   as: :new_provider
  get '/proveedores/fichas/:id'        => 'providers#show',  as: :provider
  get '/proveedores/fichas/:id/editar' => 'providers#edit',  as: :edit_provider

  post  '/proveedores/fichas/nuevo'            => 'providers#create'
  patch '/proveedores/fichas/:id/editar'       => 'providers#update'
  patch '/proveedores/fichas/edit-attachments' => 'providers#edit_attachments'


  # Provider Types
  get '/proveedores/tipos'            => 'provider_types#index', as: :provider_types
  get '/proveedores/tipos/nuevo'      => 'provider_types#new',   as: :new_provider_type
  get '/proveedores/tipos/:id'        => 'provider_types#show',  as: :provider_type
  get '/proveedores/tipos/:id/editar' => 'provider_types#edit',  as: :edit_provider_type

  post  '/proveedores/tipos/nuevo'            => 'provider_types#create'
  patch '/proveedores/tipos/:id/editar'       => 'provider_types#update'
  patch '/proveedores/tipos/edit-attachments' => 'provider_types#edit_attachments'


  # Competencies & Performance evaluations
  get '/proveedores/evaluaciones/:type'       => 'provider_evaluations#index', as: :provider_evaluations
  get '/proveedores/evaluaciones/:type/nuevo' => 'provider_evaluations#new',   as: :new_provider_evaluation
  get '/proveedores/evaluaciones/:type/:id'   => 'provider_evaluations#show',  as: :provider_evaluation

  post '/proveedores/evaluaciones/:type/nuevo' => 'provider_evaluations#create'

  # -------- Analysis: Indicators

  get '/analisis/indicadores'            => 'indicators#index', as: :indicators
  get '/analisis/indicadores/nuevo'      => 'indicators#new',   as: :new_indicator
  get '/analisis/indicadores/:id'        => 'indicators#show',  as: :indicator
  get '/analisis/indicadores/:id/editar' => 'indicators#edit',  as: :edit_indicator

  get '/analisis/indicadores/:indicator_id/nueva'      => 'indicator_measurements#new' ,
      as: :new_indicator_measurement
  get '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#edit',
      as: :edit_indicator_measurement

  post  '/analisis/indicadores/nuevo'            => 'indicators#create'
  patch '/analisis/indicadores/:id/editar'       => 'indicators#update'
  patch '/analisis/indicadores/edit-attachments' => 'indicators#edit_attachments'

  post  '/analisis/indicadores/:indicator_id/nueva'      => 'indicator_measurements#create'
  patch '/analisis/indicadores/:indicator_id/:id/editar' => 'indicator_measurements#update'

  # -------- Assets

  get '/activos/:job_type'            => 'business_assets#index', as: :business_assets
  get '/activos/:job_type/nuevo'      => 'business_assets#new',   as: :new_business_asset
  get '/activos/:job_type/:id'        => 'business_assets#show',  as: :business_asset
  get '/activos/:job_type/:id/editar' => 'business_assets#edit',  as: :edit_business_asset

  get '/activos/:job_type/:asset_id/nuevo'       => 'business_asset_jobs#new',  as: :new_asset_job
  get '/activos/:job_type/:asset_id/:id/editar'  => 'business_asset_jobs#edit', as: :edit_asset_job

  post '/activos/nuevo-tipo' => 'business_assets#create_type',
       as: :new_business_asset_type

  post  '/activos/:job_type/nuevo'            => 'business_assets#create'
  patch '/activos/:job_type/:id/editar'       => 'business_assets#update'
  patch '/activos/:job_type/edit-attachments' =>  'business_assets#edit_attachments'


  post  '/activos/:job_type/:asset_id/nuevo'       => 'business_asset_jobs#create'
  patch '/activos/:job_type/:asset_id/:id/editar'  => 'business_asset_jobs#update'

  # -------- Planning

  get '/planificacion'            => 'plannings#index', as: :plannings
  get '/planificacion/nueva'      => 'plannings#new'  , as: :new_planning
  get '/planificacion/:id'        => 'plannings#show' , as: :planning
  get '/planificacion/:id/editar' => 'plannings#edit' , as: :edit_planning

  get '/planificacion/:plan_id/nueva'      => 'planning_activities#new',  as: :new_planning_activity
  get '/planificacion/:plan_id/:id/editar' => 'planning_activities#edit', as: :edit_planning_activity

  post  '/planificacion/nueva'            => 'plannings#create'
  patch '/planificacion/:id/editar'       => 'plannings#update'
  patch '/planificacion/edit-attachments' => 'plannings#edit_attachments'


  post  '/planificacion/:plan_id/nueva'      => 'planning_activities#create'
  patch '/planificacion/:plan_id/:id/editar' => 'planning_activities#update'

  # -------- Documents

  post '/documentos/reglas/nuevo' => 'rules#create', as: :new_rule

  # -- Uploads
  get '/documentos/archivos'       => 'uploaded_files#index', as: :uploaded_files
  get '/documentos/archivos/nuevo' => 'uploaded_files#new',   as: :new_uploaded_file
  get '/documentos/archivos/:id'   => 'uploaded_files#show',  as: :uploaded_file

  post '/documentos/archivos/nuevo' => 'uploaded_files#create'

  # -- Minutes

  get '/documentos/actas'            => 'minutes_folders#index', as: :minutes_folders
  get '/documentos/actas/nuevo'      => 'minutes_folders#new',   as: :new_minutes_folder
  get '/documentos/actas/:id'        => 'minutes_folders#show',  as: :minutes_folder
  get '/documentos/actas/:id/editar' => 'minutes_folders#edit',  as: :edit_minutes_folder

  post  '/documentos/actas/nuevo'      => 'minutes_folders#create'
  patch '/documentos/actas/:id/editar' => 'minutes_folders#update'

  get '/documentos/actas/:folder_id/nueva' => 'minutes#new', as: :new_minute
  get '/documentos/actas/:folder_id/:id'   => 'minutes#edit', as: :edit_minute

  post  '/documentos/actas/:folder_id/nueva' => 'minutes#create'
  patch '/documentos/actas/:folder_id/:id'   => 'minutes#update'

  # -- Definitions

  get '/documentos/definiciones'            => 'definitions#index', as: :definitions
  get '/documentos/definiciones/nuevo'      => 'definitions#new',   as: :new_definition
  get '/documentos/definiciones/:id'        => 'definitions#show',  as: :definition
  get '/documentos/definiciones/:id/editar' => 'definitions#edit',  as: :edit_definition

  post  '/documentos/definiciones/nuevo'      => 'definitions#create'
  patch '/documentos/definiciones/:id/editar' => 'definitions#update'

  # -- Questionnaires

  get '/documentos/cuestionarios'            => 'questionnaires#index', as: :questionnaires
  get '/documentos/cuestionarios/nuevo'      => 'questionnaires#new',   as: :new_questionnaire
  get '/documentos/cuestionarios/:id'        => 'questionnaires#show',  as: :questionnaire
  get '/documentos/cuestionarios/:id/editar' => 'questionnaires#edit',  as: :edit_questionnaire

  get '/documentos/cuestionarios/:id/responder' => 'questionnaires#respond',
      as: :respond_questionnaire

  post  '/documentos/cuestionarios/nuevo'      => 'questionnaires#create'
  patch '/documentos/cuestionarios/:id/editar' => 'questionnaires#update'

  post '/documentos/cuestionarios/:id/responder' => 'questionnaires#process_response'

  # -------- Strategies: SWOT

  get '/estrategias/FODA'            => 'swot#index', as: :swot_index
  get '/estrategias/FODA/nuevo'      => 'swot#new',   as: :new_swot
  get '/estrategias/FODA/:id'        => 'swot#show',  as: :swot
  get '/estrategias/FODA/:id/editar' => 'swot#edit',  as: :edit_swot

  post  '/estrategias/FODA/nuevo'      => 'swot#create'
  patch '/estrategias/FODA/:id/editar' => 'swot#update'
  patch '/estrategias/FODA/edit-attachments' => 'swot#edit_attachments'

  get '/estrategias/FODA/:swot_id/revisiones/nueva' => 'swot_revisions#new',
      as: :new_swot_revision
  get '/estrategias/FODA/:swot_id/revisiones/:id'   => 'swot_revisions#edit',
      as: :edit_swot_revision

  post  '/estrategias/FODA/:swot_id/revisiones/nueva' => 'swot_revisions#create'
  patch '/estrategias/FODA/:swot_id/revisiones/:id'   => 'swot_revisions#update'

  # -------- Strategies: PESTE

  get '/estrategias/PESTA'            => 'peste#index', as: :peste_index
  get '/estrategias/PESTA/nuevo'      => 'peste#new',   as: :new_peste
  get '/estrategias/PESTA/:id'        => 'peste#show',  as: :peste
  get '/estrategias/PESTA/:id/editar' => 'peste#edit',  as: :edit_peste

  post  '/estrategias/PESTA/nuevo'            => 'peste#create'
  patch '/estrategias/PESTA/:id/editar'       => 'peste#update'
  patch '/estrategias/PESTA/edit-attachments' => 'peste#edit_attachments'

  get '/estrategias/PESTA/:peste_id/revisiones/nueva' => 'peste_revisions#new',
      as: :new_peste_revision
  get '/estrategias/PESTA/:peste_id/revisiones/:id'   => 'peste_revisions#edit',
      as: :edit_peste_revision

  post  '/estrategias/PESTA/:peste_id/revisiones/nueva' => 'peste_revisions#create'
  patch '/estrategias/PESTA/:peste_id/revisiones/:id'   => 'peste_revisions#update'

  # -------- Strategies: ConcernedParties

  get '/estrategias/partes-interesadas'            => 'concerned_parties#index', as: :concerned_parties
  get '/estrategias/partes-interesadas/nuevo'      => 'concerned_parties#new',   as: :new_concerned_party
  get '/estrategias/partes-interesadas/:id'        => 'concerned_parties#show',  as: :concerned_party
  get '/estrategias/partes-interesadas/:id/editar' => 'concerned_parties#edit',  as: :edit_concerned_party

  post  '/estrategias/partes-interesadas/nuevo'            => 'concerned_parties#create'
  patch '/estrategias/partes-interesadas/:id/editar'       => 'concerned_parties#update'
  patch '/estrategias/partes-interesadas/edit-attachments' => 'concerned_parties#edit_attachments'

  get '/estrategias/partes-interesadas/:party_id/revisiones/nueva' => 'concerned_party_revisions#new',
      as: :new_concerned_party_revision
  get '/estrategias/partes-interesadas/:party_id/revisiones/:id'   => 'concerned_party_revisions#edit',
      as: :edit_concerned_party_revision

  post  '/estrategias/partes-interesadas/:party_id/revisiones/nueva' => 'concerned_party_revisions#create'
  patch '/estrategias/partes-interesadas/:party_id/revisiones/:id'   => 'concerned_party_revisions#update'

  # -------- Strategies: Objectives

  get '/estrategias/objetivos'            => 'objectives#index', as: :objectives
  get '/estrategias/objetivos/nuevo'      => 'objectives#new',   as: :new_objective
  get '/estrategias/objetivos/:id'        => 'objectives#show',  as: :objective
  get '/estrategias/objetivos/:id/editar' => 'objectives#edit',  as: :edit_objective

  post  '/estrategias/objetivos/nuevo'             => 'objectives#create'
  patch '/estrategias/objetivos/:id/editar'        => 'objectives#update'
  patch '/estrategias/objetivos/edit-attachments' => 'objectives#edit_attachments'


  get '/estrategias/objetivos/:objective_id/revisiones/nueva' => 'objective_revisions#new',
      as: :new_objective_revision
  get '/estrategias/objetivos/:objective_id/revisiones/:id'   => 'objective_revisions#edit',
      as: :edit_objective_revision

  post  '/estrategias/objetivos/:objective_id/revisiones/nueva' => 'objective_revisions#create'
  patch '/estrategias/objetivos/:objective_id/revisiones/:id'   => 'objective_revisions#update'

  # -------- Strategies: BusinessProcesses

  get '/estrategias/procesos'            => 'business_processes#index', as: :business_processes
  get '/estrategias/procesos/nuevo'      => 'business_processes#new',   as: :new_business_process
  get '/estrategias/procesos/:id'        => 'business_processes#show',  as: :business_process
  get '/estrategias/procesos/:id/editar' => 'business_processes#edit',  as: :edit_business_process

  post  '/estrategias/procesos/nuevo'            => 'business_processes#create'
  patch '/estrategias/procesos/:id/editar'       => 'business_processes#update'
  patch '/estrategias/procesos/edit-attachments' => 'business_processes#edit_attachments'

  get '/estrategias/procesos/:process_id/revisiones/nueva' => 'business_process_revisions#new',
      as: :new_business_process_revision
  get '/estrategias/procesos/:process_id/revisiones/:id'   => 'business_process_revisions#edit',
      as: :edit_business_process_revision

  post  '/estrategias/procesos/:process_id/revisiones/nueva' => 'business_process_revisions#create'
  patch '/estrategias/procesos/:process_id/revisiones/:id'   => 'business_process_revisions#update'

  # -------- Strategies: Communications

  get '/estrategias/comunicacion'            => 'communications#index',  as: :communications
  get '/estrategias/comunicacion/nuevo'      => 'communications#new',    as: :new_communication
  get '/estrategias/comunicacion/:id'        => 'communications#show',   as: :communication
  get '/estrategias/comunicacion/:id/editar' => 'communications#edit',   as: :edit_communication

  post  '/estrategias/comunicacion/nuevo'            => 'communications#create'
  patch '/estrategias/comunicacion/:id/editar'       => 'communications#update'
  patch '/estrategias/comunicacion/edit-attachments' => 'communications#edit_attachments'


  get '/estrategias/comunicacion/:communication_id/revisiones/nueva' => 'communication_revisions#new',
      as: :new_communication_revision
  get '/estrategias/comunicacion/:communication_id/revisiones/:id'   => 'communication_revisions#edit',
      as: :edit_communication_revision

  post  '/estrategias/comunicacion/:communication_id/revisiones/nueva' => 'communication_revisions#create'
  patch '/estrategias/comunicacion/:communication_id/revisiones/:id'   => 'communication_revisions#update'

  # -------- Risks

  get '/riesgos/:type'            => 'risks#index', as: :risks
  get '/riesgos/:type/nuevo'      => 'risks#new',   as: :new_risk
  get '/riesgos/:type/:id'        => 'risks#show',  as: :risk
  get '/riesgos/:type/:id/editar' => 'risks#edit',  as: :edit_risk

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
  post '/referables/:class_name/:extra' => 'referables#render_list_post'

  get '/providers/evaluations/:person_id/:group_id/:qualification_type' =>
          'provider_evaluations#load_qualifications'
  get '/employees/evaluations/:person_id/:group_id/:qualification_type' =>
          'employee_evaluations#load_qualifications'

  post '/qualifications/new' => 'qualifications#create', as: :new_qualification
end
