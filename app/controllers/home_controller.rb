class HomeController < ApplicationController

	def hello
	end

	def store_token
		# binding.pry
		@token = request.env['omniauth.auth'].credentials.token
		session['token'] = @token
		@url = "http://127.0.0.1:3000/feed/#{@token}"
		redirect_to feed_path(token:@token)
	end

	def view
		@token = session['token']
	end

	def feed
		#show webpage with info if your a browser, else render iCal
		#look up user by params[:token]
		#get events from eventb
		#create ical feed
		respond_to do |format|
			format.html
			format.ics {
				eb_client = EventbriteClient.new({ access_token: params[:token]})
				json = JSON.parse(eb_client.user_list_tickets.body)["user_tickets"][1]["orders"]
				feed = RiCal.Calendar do |cal|
					puts "#"*80
					puts cal.class
					puts "#"*80
					json.each do |eb_event|
						eb_event = eb_event["order"]["event"]
						cal.event do |event|
							event.summary = eb_event["title"]
							event.description = eb_event["description"]
							event.dtstart =  DateTime.parse eb_event["start_date"]
							event.dtend = DateTime.parse eb_event["end_date"]
							v = eb_event["venue"]
							venue = "#{v['name']}, #{v['address']}, #{v['city']}, #{v['region']}, #{v['postal_code']}"
							event.location = venue
							# event.add_attendee "john.glenn@nasa.gov"
					    end
					end
				end
				render text: feed,  mime_type: Mime::Type["text/calendar"]
			}
		end
	end
end
