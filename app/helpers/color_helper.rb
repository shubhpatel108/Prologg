module ColorHelper
	def color(index)
		if index%5 == 1
			return "danger"
		elsif index%5 == 2
			return "warning"
		elsif index%5 == 3
			return "info"
		elsif index%5 == 4
			return "primary"
		elsif index%5 == 0
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

	def color_star(index)
		if index%5 == 1
			return "danger"
		elsif index%5 == 2
			return "warning"
		elsif index%5 == 3
			return "info"
		elsif index%5 == 4
			return "active"
		elsif index%5 == 0
			return "success"
		end
	end

end