class HomeController < ApplicationController
	def create
		@token = "EEBKZ7Z753B567RO6XVH"
		@url = "http://127.0.0.1:3000/feed/#{@token}"
	end

	def hello
	end

	def getFeed
	end

	def feed
		#look up user by params[:token]
		#get events from eventb
		#create ical feed
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
			    end
			end
		end
		render text: feed
	end
end
