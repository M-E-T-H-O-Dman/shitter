class Reset_password

	def self.send(user)
		@link = "http://localhost:9393/users/set_new_password/#{user.password_token}"
	  RestClient.post "https://#{API_KEY}@api.mailgun.net/v2/sandbox6af052e0d94e4fd3a214cb775b2d1d81.mailgun.org/messages",
	  :from => "Mailgun Sandbox <postmaster@sandbox6af052e0d94e4fd3a214cb775b2d1d81.mailgun.org>",
	  :to => user.email,
	  :subject => "Reset Password",
	  :text => "Please follow this link #{@link}" 
	end
end