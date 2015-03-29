module DateHelper
	def date_format(date_string)
		date = date_string.split(" ")
		date_comp = date[0].split(".")
		date[0] = [date_comp[2],date_comp[0],date_comp[1]].join("-")
		time_comp = date[1].split(":")
		time_comp << "00"
		date[1] = time_comp.join(":")
		return date.join(" ")
	end
end