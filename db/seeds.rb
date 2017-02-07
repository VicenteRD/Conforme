Mongoid.default_client.database.drop

vr = Person::User.new(
  email: 'vicente.drd@gmail.com',
  password: 'vicente8',

  rut: '18635551-2',
  name: 'Vicente',
  l_name1: 'Rivera',
  l_name2: 'Dussaillant',

  phone: '(+56) 9 5637XXXX',
  address: 'Padre Hurtado Sur XXXX, depto X-XX',

  dob: Date.new(1993, 10, 2),
  photo: nil,

  role: 'SuperAdmin',
  contract_type: 'Lol nope',

  active: true,
  ll_at: Time.now,
  j_at: Time.now)
vr.save!

cv = Person::User.new(
    email: 'cvillaseca@eworks.cl',
    password: 'picton1950',

    rut: '11345343-5',
    name: 'Claudio',
    l_name1: 'Villaseca',
    l_name2: ' ',

    phone: '(+56) 9 1234XXXX',
    address: 'Colon XXXX',

    dob: Date.new(1960, 1, 1),
    photo: nil,

    role: 'SuperAdmin',
    contract_type: 'self',

    active: true,
    ll_at: Time.now,
    j_at: Time.now)

pos_gg = Position.new(name: 'Gerencia General', functions: 'Administrar toda la empresa', competencies: ' ', area: true)

pos_dp = Position.new(name: 'Director de Producto', functions: 'Administrar productos', competencies: ' ', area: true)

pos_go = Position.new(name: 'Goma', functions: 'Ser administrado', competencies: ' ')

pos_dv = Position.new(name: 'Director de Ventas', functions: 'Administrar ventas', competencies: ' ', area: true)

pos_go.parent_id = pos_dp.id
pos_go.save!

pos_dp.add_to_set(children_ids: pos_go.id)
pos_dp.parent_id = pos_gg.id
pos_dp.save!

pos_dv.parent_id = pos_gg.id
pos_dv.save!

pos_gg.add_to_set(children_ids: [pos_dp.id, pos_dv.id])
pos_gg.save!

cv.add_to_set(positions: pos_gg)
cv.save!

Task::DocumentTask.create(executor_id: vr.id, petitioner_id: cv.id, status: 'En curso', extract: 'Hacer pag web', rejected: false,
  p_at: Time.now, r_at: Time.now)

Task.create(executor_id: vr.id, petitioner_id: cv.id, status: 'En curso', extract: 'No matar el servidor', rejected: false,
                 p_at: Time.now, r_at: Time.now)

Settings::RiskSettings.create(operational_threshold: 0.5,
                              margin: 0.05,
                              operational_impact_options: {1 => 'Bueno', 2 => 'Malo', 3 => 'Catastrófico'}
)

proc1 = BusinessProcess.new(name: 'Going to sleep',
                           description: 'Something some humans do.')
proc1.save!

proc2 = BusinessProcess.new(name: 'Processing process',
                            description: 'Process to process to processing of processes within the main process of the process.')
proc2.save!


risk = Risk::OperationalRisk.new(measurement_frequency: 1, responsible_id: vr.id, area_id: pos_gg.id,
                             process_id: proc1.id, activity: 'Trying to sleep', name: 'Failing to sleep')
risk.save!
risk.created_entry(nil, body = 'Created by system')
