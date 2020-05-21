require 'SQLite3'

db4 = SQLite3::Database.open 'barbershop.db'
db4.results_as_hash = true

db4.execute 'SELECT * FROM users ORDER BY id DESC' do |row|
  print row['user_name']
  print "\t"
  print row['phone']
  print "\t"
  print row['email']
  print "\t"
  puts row['date_stamp']
end
