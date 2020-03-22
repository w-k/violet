class Table
	def initialize(body, headers = nil)
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
		@headers = headers
		@body = body 
	end

	def to_s
		column_count = [@body.map{|r| r.size}.max, @headers ? @headers.length : 0].max
		column_widths = Array.new(column_count).fill(0)
		@body.each do |row|
			(0...row.length).each do |i| 
				if row[i].to_s.length > column_widths[i]
					column_widths[i] = row[i].to_s.length
				end
			end
		end
		if @headers
			(0...@headers.length).each do |i| 
				if @headers[i].to_s.length > column_widths[i]
					column_widths[i] = @headers[i].to_s.length
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


		if @headers
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

			# header
			header = ""
			header += @vertical
			column_widths.each_with_index do |width, index|
				value = @headers[index]
				if value.class == String
					padding = " " * (width - value.length)
					header += " " + value + padding + " " +@vertical
				elsif value.class == Integer or value.class  == Float
					padding = " " * (width - value.to_s.length)
					header += " " + padding + value.to_s + " " + @vertical
				end
			end
			header += "\n\r"
		end


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

		# body
		body = ""
		@body.each_with_index do |row, row_index|
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
		if @headers
			result += header
			result += header_line
		end
		result += body
		result += bottom

		return result
	end
end
