module ApplicationHelper

	#gets the html styling classes for each flash message type
	def flash_class(type)
		case type
	 		when "success" then "ui green message"
	 		when "notice" then "ui blue message"
	 		when "danger" then "ui red message"
	 	end
	end
end
