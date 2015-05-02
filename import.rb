require 'rubygems'
require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'

book = Spreadsheet.open 'languages.xls'
sheet = book.worksheet 0

sheet.each_with_index do |row, i|
	data = row[0]
	if not data.nil?
		data = data.chomp(' ')
		data = data.chomp('.')
		data = data.chomp(',')
		puts data
		Language.create(:name => data)
	end
end
