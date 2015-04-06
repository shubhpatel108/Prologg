module LinksHelper

	def linkedin_link(uid)
		"http://www.linkedin.com/profile/view?id=" + uid
	end

	def github_link(username)
		"https://www.github.com/" + username
	end

	def codeforces_link(username)
		"http://www.codeforces.com/profile/" + username
	end

	def topcoder_link(handle)
		"https://www.topcoder.com/member-profile/" + handle
	end
end