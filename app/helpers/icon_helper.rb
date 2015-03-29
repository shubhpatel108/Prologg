module IconHelper
	def icon(categ)
		case categ
			when 'Design'
				return 'picture-o'
			when 'Development'
				return 'code'
			when 'Security'
				return 'life-bouy'
			when 'Wireframe'
				return 'pencil'
			when 'Test Scenarios'
				return 'cogs'
			when 'Test Suites'
				return 'file-code-o'
			when 'Assembly Competition'
				return 'puzzle-piece'
			else return ''
		end
	end	
end