module SummaryHelper

	def lang_adjective
		lang = @all_langs.keys.first
		
		algo_count = @algo_langs[lang]
		algo_count = 0 if algo_count.nil?

		app_count = @application_langs[lang]
		app_count = 0 if app_count.nil?

		if app_count > 8 or algo_count > 50
			"supperlative"
		elsif (app_count > 3 and algo_count > 20)
			"middling"
		elsif (algo_count > 29)
			"middling"
		else
			"neopyte"
		end
	end

	def over_all_adjective
		lang = @all_langs.keys.first
		count = @all_langs[lang]
		if count > 70
			"a staunch"
		elsif count > 20
			"a neotoric"
		else
			"an aspiting"
		end
	end

	def gender
		if @user.gender
			"He"
		else
			"She"
		end
	end

	def gender1
		if @user.gender
			"lad"
		else
			"lass"
		end
	end

	def gender2
		if @user.gender
			"his"
		else
			"her"
		end
	end

	def linkedin_skills
		skills = @user.linkedin_skills.slice(0..2)
		if skills.empty?
			""
		else
			" and is an appreciable enthusiast to learn about " + skills.to_sentence
		end
	end

	def tags
		@user.tags.slice(0..2).to_sentence
	end
end
