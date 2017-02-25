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
  j_at: Time.now
)

tst = Person::User.new(
    email: 'a@a',
    password: '88888888',

    rut: '17700224-0',
    name: 'a',
    l_name1: 'b',
    l_name2: 'c',

    phone: 'phone',
    address: 'address',

    dob: Date.new(1991, 2, 19),
    photo: nil,

    role: 'SuperAdmin',
    contract_type: 'Lol nope',

    active: true,
    ll_at: Time.now,
    j_at: Time.now
)
tst.save!

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
    j_at: Time.now
)

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

vr.add_to_set(positions: pos_dp)
vr.save!

cv.add_to_set(positions: pos_gg)
cv.save!

Task::DocumentTask.create(executor_id: vr.id, petitioner_id: cv.id, status: 'En curso', extract: 'Hacer pag web', rejected: false,
  p_at: Time.now, r_at: Time.now)

Task.create(executor_id: vr.id, petitioner_id: cv.id, status: 'En curso', extract: 'No matar el servidor', rejected: false,
                 p_at: Time.now, r_at: Time.now)

proc1 = BusinessProcess.new(name: 'Going to sleep',
                            description: 'Something some humans do.')
proc1.save!

proc2 = BusinessProcess.new(name: 'Processing process',
                            description: 'Process to process to processing of processes within the main process of the process.')
proc2.save!

stdd = Rule.new(institution: 'ISO', name: '9001', rule_type: 2)
stdd.save!
s_art = stdd.articles.create(name: 'A', requirement: 'Do stuff right.')

law = Rule.new(institution: 'Estado', name: 'Constitución', rule_type: 1)
law.save!
l_art = law.articles.create(name: '110011', requirement: 'Dont do stuff.')

Settings::RiskSettings.create(
    margin: 0.05,
    operational_threshold: 0.5,
    operational_options: {
        impact: {1 => 'Bajo', 2 => 'Grave', 3 => 'Crítico'}
    },
    environmental_threshold: 0.5,
    environmental_options: {
        name: ['Altera la condición del aire', 'Altera la condición del suelo'],
        occ_time: {-1 => 'Pasado', 0 => 'Presente', 1 => 'Futuro'},
        op_situation: {1 => 'Normal', 2 => 'Anormal', 3 => 'Emergencia'},
        geo_amplitude: {1 => 'Local', 2 => 'Puntual', 3 => 'Externa'},
        pub_perception: {1 => 'Baja', 2 => 'Media', 3 => 'Alta'},
        reversibility: {1 => 'Reversible', 2 => 'Recuperable', 3 => 'Irrecuperable'},
        criticity: {1 => 'Baja', 2 => 'Grave', 3 => 'Crítico'}
    },
    safety_threshold: 0.5,
    safety_options: {
        condition: {0 => 'No Rutinaria', 1 => 'Rutinaria'},
        agent: ['Manejo de Conflictos', 'Horno'],
        consequence: ['Stress, tensión', 'Quemaduras y Deshidratación'],
        name: ['Agresiones verbales', 'Físico (Radiación no Ionizante)'],
        impact: {1 => 'Bajo', 2 => 'Grave', 3 => 'Crítico'}
    },
    standard_threshold: 0.5,
    law_threshold: 0.5
)

op_risk = Risk::OperationalRisk.new(
    measurement_frequency: 1,
    responsible_id: vr.id,
    area_id: pos_gg.id,
    process_id: proc1.id,
    activity: 'Trying to sleep',
    name: 'Failing to sleep'
)
op_risk.save!
op_risk.log_creation(nil, body = 'Created by system')

st_risk = Risk::RuleRisk.new(
    measurement_frequency: 30,
    responsible_id: cv.id,

    rule_type: 2,
    rule_id: stdd.id,
    article_id: s_art.id
)
st_risk.save!
st_risk.log_creation(nil, body = 'Created by system')

la_risk = Risk::RuleRisk.new(
    measurement_frequency: 30,
    responsible_id: cv.id,

    rule_type: 1,
    rule_id: law.id,
    article_id: l_art.id
)
la_risk.save!
la_risk.log_creation(nil, body = 'Created by system')

en_risk = Risk::EnvironmentalRisk.new(
    measurement_frequency: 365,
    responsible_id: cv.id,
    area_id: pos_dv.id,
    process_id: proc2.id,
    activity: 'Trashing the trashy trash can full of trashy trash',

    aspect: 'Basura',
    name: 'Altera la condición del suelo',
    regulation_id: la_risk.id,
    occurrence_time: 1,
    operational_situation: 2,
    positive: true,
    direct: false
)
en_risk.save!
en_risk.log_creation(nil, body = 'Created by system')

sa_risk = Risk::SafetyRisk.new(
    measurement_frequency: 7,
    responsible_id: vr.id,
    area_id: pos_dp.id,
    process_id: proc1.id,
    activity: 'Walking',

    position_id: pos_go.id,
    condition: 1,
    agent: 'Horno',
    consequence: 'Quemaduras y Deshidratación',
    name: 'Físico (Radiación no Ionizante)',

    comments: '<p><h6>Safety first!</h6>This is just a test...</p>',
)
sa_risk.save!
sa_risk.log_creation(nil, body = 'Created by system')


obj = Objective.new(
    creator_id: vr.id,
    responsible_id: vr.id,
    name: 'Objective 1',
    phrase: 'Order 66'
)
obj.save!

ind = Indicator.new(
    objective_id: obj.id,
    responsible_id: vr.id,

    name: 'Indicator A',
    description: 'Geeky stuff',
    method: 'No idea',
    thr: 1.0,
    margin: 0.05,
    criterion: '>',
    unit: 'Kms',
    measurement_frequency: 365
)
ind.save!

obj.save!
