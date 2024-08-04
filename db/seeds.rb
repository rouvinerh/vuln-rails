User.destroy_all

User.create!(
  email: ENV.fetch('TENANT1_EMAIL'),
  password: ENV.fetch('TENANT1_PASSWORD')
)

User.create!(
  email: ENV.fetch('TENANT2_EMAIL'),
  password: ENV.fetch('FLAG')
)
