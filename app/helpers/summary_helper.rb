module SummaryHelper

	def lang_adjective
		lang = @all_langs.keys.first
		
		algo_count = @algo_langs[lang]
		algo_count = 0 if algo_count.nil?

		app_count = @application_langs[lang]
		app_count = 0 if app_count.nil?

		if app_count > 8 or algo_count > 50
			"supperlative"
		elsif (app_count > 3 or algo_count > 20)
			"middling"
		elsif (algo_count > 29)
			"middling"
		else
			"neopyte"
		end
	end

	def lang_adj_tt(adj)
		case adj
		when "superlative"
			"with more than 8 repositories or 50 algorithms problems"
		when "middling"
			"with more than 3 repositories or 30 algorithms problems"
		when "neopyte"
			"a starter who is enthusiastic and progressive"
		end
	end

	def over_all_adjective
		lang = @all_langs.keys.first
		count = @all_langs[lang]
		count = 0 if count.nil?
		if count > 70
			"a staunch"
		elsif count > 20
			"a neotoric"
		else
			"an aspiting"
		end
	end

	def over_all_tt(adj)
		case adj
		when "a staunch"
			"on Top of the world"
		when "a neotoric"
			"Second in hierarchy, after 'Staunch'"
		when "an aspiting"
			"last in hierarchy but quickly quickly progressing"
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

	def gender3
		if @user.gender
			"him"
		else
			"her"
		end
	end

	def linkedin_skills
		skills = @user.linkedin_skills.slice(0..2)
		if skills.empty?
			""
		else
			(" and is an appreciable enthusiast to learn about <span class='text-danger style-words' data-toggle='sum' data-placement='top' title='profoundly endorsed by others'>" + skills.to_sentence + "</span>").html_safe
		end
	end

	def tags
		@user.tags.slice(0..2).to_sentence
	end

	def day_adjective
		days = @user.github_profile.data["punch_card"]["days"]

		weekend_avg = (days[0] + days[6]) / 2
		week_days_avg = days[1..5].sum / 5

		if weekend_avg > week_days_avg
			"weekend".html_safe
		elsif weekend_avg < week_days_avg
			"weekdays".html_safe
		else
			"all week long".html_safe
		end
	end

	def time_adjective(graph = nil)
		time = @user.github_profile.data["punch_card"]["time"]

		night = time[0..2].sum + time[7]
		day = time[3..6].sum

		if graph.nil?
			if night > day
				"'s <span class=\"style-words text-success\">a nocturnal developer </span>,".html_safe
			else
				" <span class=\"style-words text-success\"> develops in parallel with his #{gender2} job</span>,".html_safe
			end
		else
			if night > day
				"nocturnal"
			else
				"midday"
			end
		end
	end
end
