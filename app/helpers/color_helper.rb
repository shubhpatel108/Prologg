module ColorHelper
	def color(index)
		if index%4 == 1
			return "danger"
		elsif index%4 == 2
			return "warning"
		elsif index%4 == 3
			return "info"
		elsif index%4 == 0
			return "success"
		end
	end

	def color_status(status)
		if status=="OK"
			return "success"
		elsif status == "TIME_LIMIT_EXCEEDED"
			return "warning"
		elsif status == "RUNTIME_ERROR"
			return "info"
		else 
			return "danger"	
		end
	end
end