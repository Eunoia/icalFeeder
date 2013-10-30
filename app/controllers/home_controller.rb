class HomeController < ApplicationController
	def create
		@token = request.env['omniauth.auth']["token"]
		#save user to db
		redirect_to :getFeed
	end

	def hello
	end

	def getFeed
		#show user a link to their feed
	end

	def feed
		#look up user by params[:token]
		#get events from eventb
		#create ical feed
	end
end
