require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'SQLite3'

def is_barber_exists? db, name #checks if barber exists in the list
	db.execute('select * from barbers where name =?' , [name]).length > 0
end

def seed_db db, barbers

	barbers.each do |barber| #if is_barber_exists? doesn't have a barber with this name it inserts one
		if !is_barber_exists? db, barber
			db.execute 'insert into barbers (name) values (?)', [barber]
		end
	end

end

def get_db
  db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute 'select * from barbers'
end

configure do
	db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS
 		"Users"
		 (
			"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "user_name" TEXT,
			"phone"	TEXT,
			"email"	TEXT,
			"date_stamp"	TEXT,
			"barber"	TEXT,
			"color"	TEXT
		)'

db.execute 'CREATE TABLE IF NOT EXISTS
	"barbers"
	 (
		"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
		"name" TEXT
		)'                                                                   #  creates table barbers if there is no one
		seed_db db, ['John Bold', 'Marta "The Hairy"', 'Johan the "Razor"', 'Willie the "Scissors"']  #  checks if the one I want to add in in this list
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified by Friindel33"
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end


post '/visit' do
  # user_name, email, date_stamp, barber
  @user_name = params[:user_name]
  @email = params[:email]
  @date_stamp = params[:date_stamp]
	@barber = params[:barber]
	@color = params[:color]
	@phone = params[:phone]

  @title = "Thank you!"
  @message = "<h4>#{@user_name}, we are waiting for You on: <b>#{@date_stamp}</b>. Your Barber will be #{@barber} and color will be #{@color}</h4>"

	hh = {
					:user_name => 'Please enter your name',
					:email => 'Please enter your email',
					:phone => 'Please enter your phone',
					:date_stamp => 'Please choose date'
				}
				@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

				if @error != ''
					return erb :visit
				end

#insert data into barbershop.db
				db = get_db
        db.execute 'insert into
          Users
          (
          user_name,
          phone,
          email,
          date_stamp,
          barber,
          color
          )
          values (?, ?, ?, ?, ?, ?)', [@user_name, @phone, @email, @date_stamp, @barber, @color]

          # запишем в файл то, что ввёл клиент
          f = File.open './public/users.txt', 'a'
          f.write "Visitor: #{@user_name}, e-mail: #{@email}, phone number: #{@phone}, time of visit: #{@date_stamp} with: #{@barber} color: #{@color}.\n"
          f.close

  erb :message
end


post '/contacts' do

	@name = params[:name]
	@yemail = params[:yemail]
	@your_message = params[:yourmessage]

	@title = "Thank you!"
	@message = "#{@name}, We have received your message. We will respond ASAP"

  bb = {
					:name => 'Please enter your name',
					:yemail => 'Please enter your email',
					:your_message => 'Please enter your message',
				}
				@error = bb.select {|key,_| params[key] == ""}.values.join(", ")

				if @error != ''
					return erb :contacts
				end

        #insert data into barbershop.db
				db = get_db
                db.execute 'insert into Contacts (name, yemail, your_message) values (?, ?, ?)', [@name, @yemail, @your_message]

	f = File.open './public/users.txt', 'a'
	f.write "Name: #{@name}, e-mail: #{@yemail}, left a message: #{@your_message}.\n"
	f.close

	erb :message
end


get '/admin' do
  erb :admin
end

	post '/admin' do
	  @login = params[:login]
	  @password = params[:password]
		@delete = params[:delete]

		#@delete = File.open("./public/users.txt", "a+") do |delete|
		#  delete.truncate(5)
		#end

	  			# проверим логин и пароль, и пускаем внутрь или нет:
				  if @login == 'admin' && @password == 'admin'
				    @file = File.open("./public/users.txt","r")
				    erb :watch_result
				    # @file.close - должно быть, но тогда не работает. указал в erb
				  else
				    @error = '<p>Wrong Login or Password</p>'
				    erb :admin
				  end
	end

	get '/showusers' do
		db = get_db
		@results = db.execute 'select * from users order by id'
		erb :showusers
	end
