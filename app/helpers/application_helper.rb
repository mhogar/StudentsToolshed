module ApplicationHelper

	#gets the html styling classes for each flash message type
	def flash_class(type)
		case type
	 		when "notice" then "ui green message"
	 		when "info" then "ui blue message"
	 		when "warn" then "ui yellow message"
	 		when "alert" then "ui red message"
	 	end
	end
end
