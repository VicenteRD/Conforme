Mongoid.default_client.database.drop

vr =Person::User.new(
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
cv.save!



pos = Position.new(name: 'Gerencia General', functions: 'Administrar toda la empresa', competencies: ' ', area: true)
pos.add_to_set(
      child_positions:
          [
              Position.new(name: 'Director de Producto', functions: 'Administrar productos', competencies: ' ', area: true)
                  .add_to_set(
                      child_positions:
                          Position.new(name: 'goma', functions: 'Ser administrado', competencies: ' ')
                  ),
              Position.new(name: 'Director de Ventas', functions: 'Administrar ventas', competencies: ' ', area: true)
          ])
pos.save!

Task::DocumentTask.create(executor_id: vr.id, petitioner_id: cv.id, status: 'En curso', extract: 'Hacer pag web', rejected: false,
  p_at: Time.now, r_at: Time.now)

Task.create(executor_id: vr.id, petitioner_id: cv.id, status: 'En curso', extract: 'No matar el servidor', rejected: false,
                 p_at: Time.now, r_at: Time.now)


risk = Risk::Operational.new(measurement_frequency: 1, responsible_id: vr.id, position_id: pos.id,
                             process: 'Going to bed', activity: 'Trying to sleep', name: 'Failing to sleep')
risk.save!
