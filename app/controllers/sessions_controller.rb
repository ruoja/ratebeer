class SessionsController < ApplicationController

	def new
		#render login
	end

	def create
		user = User.find_by username: params[:username]
    if user.banned
      redirect_to signin_path, notice: 'Your user accout has been frozen. Please contact admin'
		elsif user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to user_path(user), notice: "Welcome #{params[:username]}!"
		else
			redirect_to :back, notice: "Username and/or password missmatch"
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to :root
	end

end