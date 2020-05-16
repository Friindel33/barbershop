#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
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
  # user_name, email, date_time, barber
  @user_name = params[:user_name]
  @email = params[:email]
  @date_time = params[:date_time]
	@barber = params[:barber]
	@color = params[:color]

  @title = "Thank you!"
  @message = " #{@user_name}, we are waiting for You on: #{@date_time}. Your Barber will be #{@barber} and color will be #{@color}"

  # запишем в файл то, что ввёл клиент
  f = File.open './public/users.txt', 'a'
  f.write "Visitor: #{@user_name}, e-mail: #{@email}, time of visit: #{@date_time} with: #{@barber} color: #{@color}.\n"
  f.close

  erb :message
end

get '/admin' do
  erb :admin
end

	post '/admin' do
	  @login = params[:login]
	  @password = params[:password]

	  			# проверим логин и пароль, и пускаем внутрь или нет:
				  if @login == 'admin' && @password == 'admin'
				    @file = File.open("./public/users.txt","r")
				    erb :watch_result
				    # @file.close - должно быть, но тогда не работает. указал в erb
				  else
				    @report = '<p>Wrong Password</p>'
				    erb :admin
				  end
	end
