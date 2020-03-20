class Table
	def initialize(data)
		@top_left = '┌'
		@horizontal = '─'
		@vertical= '│'
		@middle_left = '├'
		@bottom_left = '└'
		@top_middle = '┬'
		@bottom_middle = '┴'
		@bottom_right = '┘'
		@middle_right = '┤'
		@middle_middle = '┼'
		@top_right = '┐'
		@data = data
	end

	def to_s
		column_count = @data.max { |row| row.length}
		column_widths = Array.new(column_count).fill(0)
		@data.each do |row|
			(0...row.length).each do |i| 
				if row[i].to_s.length > column_widths[i]
					column_widths[i] = row[i].to_s.length
				end
			end
		end

		result = ""

		# top
		top = ""
		top += @top_left
		column_widths.each_with_index do |width, index|
			(0...width+2).each { top += @horizontal}
			if index < (column_widths.length - 1)
				top += @top_middle
			end
		end
		top += @top_right +"\n\r"

		# header line
		header_line = ""
		header_line += @middle_left
		column_widths.each_with_index do |width, index|
			(0...width+2).each { header_line += @horizontal}
			if index < (column_widths.length - 1)
				header_line += @middle_middle
			end
		end
		header_line += @middle_right + "\n\r"

		# bottom
		bottom = ""
		bottom += @bottom_left
		column_widths.each_with_index do |width, index|
			(0...width+2).each { bottom += @horizontal}
			if index < (column_widths.length - 1)
				bottom+= @bottom_middle
			end
		end
		bottom += @bottom_right + "\n\r"

		# header
		header = ""
		header += @vertical
		column_widths.each_with_index do |width, index|
			value = @data[0][index]
			if value.class == String
				padding = " " * (width - value.length)
				header += " " + value + padding + " " +@vertical
			elsif value.class == Integer or value.class  == Float
				padding = " " * (width - value.to_s.length)
				header += " " + padding + value.to_s + " " + @vertical
			end
		end
		header += "\n\r"

		# body
		body = ""
		@data[1..-1].each_with_index do |row, row_index|
			body += @vertical
			column_widths.each_with_index do |width, index|
				value = row[index]
				if value.class == String
					padding = " " * (width - value.length)
					body += " " + value + padding + " " +@vertical
				elsif value.class == Integer or value.class  == Float
					padding = " " * (width - value.to_s.length)
					body += " " + padding + value.to_s + " " + @vertical
				end
			end
			body += "\n\r"
		end

		result += top
		result += header
		result += header_line
		result += body
		result += bottom

		@data.each do |row|
		end

		return result
	end
end
class Table
	def initialize(data)
		@top_left = '┌'
		@horizontal = '─'
		@vertical= '│'
		@middle_left = '├'
		@bottom_left = '└'
		@top_middle = '┬'
		@bottom_middle = '┴'
		@bottom_right = '┘'
		@middle_right = '┤'
		@middle_middle = '┼'
		@top_right = '┐'
		@data = data
	end

	def to_s
		column_count = @data.max { |row| row.length}
		column_widths = Array.new(column_count).fill(0)
		@data.each do |row|
			(0...row.length).each do |i| 
				if row[i].to_s.length > column_widths[i]
					column_widths[i] = row[i].to_s.length
				end
			end
		end

		result = ""

		# top
		top = ""
		top += @top_left
		column_widths.each_with_index do |width, index|
			(0...width+2).each { top += @horizontal}
			if index < (column_widths.length - 1)
				top += @top_middle
			end
		end
		top += @top_right +"\n\r"

		# header line
		header_line = ""
		header_line += @middle_left
		column_widths.each_with_index do |width, index|
			(0...width+2).each { header_line += @horizontal}
			if index < (column_widths.length - 1)
				header_line += @middle_middle
			end
		end
		header_line += @middle_right + "\n\r"

		# bottom
		bottom = ""
		bottom += @bottom_left
		column_widths.each_with_index do |width, index|
			(0...width+2).each { bottom += @horizontal}
			if index < (column_widths.length - 1)
				bottom+= @bottom_middle
			end
		end
		bottom += @bottom_right + "\n\r"

		# header
		header = ""
		header += @vertical
		column_widths.each_with_index do |width, index|
			value = @data[0][index]
			if value.class == String
				padding = " " * (width - value.length)
				header += " " + value + padding + " " +@vertical
			elsif value.class == Integer or value.class  == Float
				padding = " " * (width - value.to_s.length)
				header += " " + padding + value.to_s + " " + @vertical
			end
		end
		header += "\n\r"

		# body
		body = ""
		@data[1..-1].each_with_index do |row, row_index|
			body += @vertical
			column_widths.each_with_index do |width, index|
				value = row[index]
				if value.class == String
					padding = " " * (width - value.length)
					body += " " + value + padding + " " +@vertical
				elsif value.class == Integer or value.class  == Float
					padding = " " * (width - value.to_s.length)
					body += " " + padding + value.to_s + " " + @vertical
				end
			end
			body += "\n\r"
		end

		result += top
		result += header
		result += header_line
		result += body
		result += bottom

		@data.each do |row|
		end

		return result
	end
end

class Table
	def initialize(data)
		@top_left = '┌'
		@horizontal = '─'
		@vertical= '│'
		@middle_left = '├'
		@bottom_left = '└'
		@top_middle = '┬'
		@bottom_middle = '┴'
		@bottom_right = '┘'
		@middle_right = '┤'
		@middle_middle = '┼'
		@top_right = '┐'
		@data = data
	end

	def to_s
		column_count = @data.max { |row| row.length}
		column_widths = Array.new(column_count).fill(0)
		@data.each do |row|
			(0...row.length).each do |i| 
				if row[i].to_s.length > column_widths[i]
					column_widths[i] = row[i].to_s.length
				end
			end
		end

		result = ""

		# top
		top = ""
		top += @top_left
		column_widths.each_with_index do |width, index|
			(0...width+2).each { top += @horizontal}
			if index < (column_widths.length - 1)
				top += @top_middle
			end
		end
		top += @top_right +"\n\r"

		# header line
		header_line = ""
		header_line += @middle_left
		column_widths.each_with_index do |width, index|
			(0...width+2).each { header_line += @horizontal}
			if index < (column_widths.length - 1)
				header_line += @middle_middle
			end
		end
		header_line += @middle_right + "\n\r"

		# bottom
		bottom = ""
		bottom += @bottom_left
		column_widths.each_with_index do |width, index|
			(0...width+2).each { bottom += @horizontal}
			if index < (column_widths.length - 1)
				bottom+= @bottom_middle
			end
		end
		bottom += @bottom_right + "\n\r"

		# header
		header = ""
		header += @vertical
		column_widths.each_with_index do |width, index|
			value = @data[0][index]
			if value.class == String
				padding = " " * (width - value.length)
				header += " " + value + padding + " " +@vertical
			elsif value.class == Integer or value.class  == Float
				padding = " " * (width - value.to_s.length)
				header += " " + padding + value.to_s + " " + @vertical
			end
		end
		header += "\n\r"

		# body
		body = ""
		@data[1..-1].each_with_index do |row, row_index|
			body += @vertical
			column_widths.each_with_index do |width, index|
				value = row[index]
				if value.class == String
					padding = " " * (width - value.length)
					body += " " + value + padding + " " +@vertical
				elsif value.class == Integer or value.class  == Float
					padding = " " * (width - value.to_s.length)
					body += " " + padding + value.to_s + " " + @vertical
				end
			end
			body += "\n\r"
		end

		result += top
		result += header
		result += header_line
		result += body
		result += bottom

		@data.each do |row|
		end

		return result
	end
end
