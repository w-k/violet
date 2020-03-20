require './push'



class Display
	
	attr_reader :last_line, :text

	def initialize(window)
		@window = window
		@error = false
		@page_size = 15
	end

	def set_error(error)
		if error != @error
			@error = error
			color = color_pair(COLOR_YELLOW)
			if @error
				color = color_pair(COLOR_RED)
			end
			push(@window, 2, 0) do 
				@text[:lines].each { |line| 
					@window.clrtoeol
					@window.setpos(@window.cury + 1, 0)
					@window.setpos(2, 0)
				}
				@window.attron(color) { 
					@window << @text[:lines].map {|l| "#{l[0]}: #{l[1]}"}.join("⏎\n")
				}
			end
		end
	end

	def set_index(index)
		if @error
			return
		end
		push(@window, 2, 0) do 
			@text[:lines].each { |line| 
				@window.clrtoeol
				@window.setpos(@window.cury + 1, 0)
				@window.setpos(2, 0)
			}
			for line_index in 0..@text[:lines].size-1
				line = @text[:lines][line_index]
				@window.attron(color_pair(COLOR_YELLOW)) { 
					@window << "#{line[0]}: "
				}
				if line_index < index[0]
					@window.attron(color_pair(COLOR_MAGENTA)) { 
						@window << line[1]
						if line_index < @text[:lines].size - 1
							@window << "⏎\n"
						end
					}
				elsif line_index == index[0] && index[1]
					@window.attron(color_pair(COLOR_MAGENTA)) { 
						@window << line[1][0..index[1]]
					}
					@window.attron(color_pair(COLOR_YELLOW)) { 
						@window << line[1][index[1]+1..-1]
						if line_index < @text[:lines].size - 1
							@window << "⏎\n"
						end
					}
				else
					@window.attron(color_pair(COLOR_YELLOW)) { 
						@window << line[1]
						if line_index < @text[:lines].size - 1
							@window << "⏎\n"
						end
					}
				end
			end
		end
	end

	def load(text)
		@text = text
		@window.attron(color_pair(COLOR_BLUE)) { 
			@window << "#{@text[:path]} #{@text[:size]}"
		}
		@window.setpos(@window.cury + 2, 0)
		@window.attron(color_pair(COLOR_YELLOW)) { 
			@window << @text[:lines].map {|l| "#{l[0]}: #{l[1]}"}.join("⏎\n")
		}
		@last_line = @window.cury
	end

end
