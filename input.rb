require './logger'

CONSOLE_TAB_WIDTH = 8

class Input
	def initialize(window)
		@window = window
		@has_errors = false
		@color = color_pair(COLOR_GREEN)
	end

	def load(reference_text, origin)
		@reference_text = reference_text[:lines].map{ |l| l[1] }
		@indentations = @reference_text.map{ |line| line.match(/^\s*/)[0]}
		@origin = origin 
		@window.setpos(origin, 0)
		@errors = 0
		@accumulated_errors = 0
		@window << @indentations[0]
		@typed_text = [@indentations[0].dup] 
		@start_time = Time.now
		@spaces = 0
	end

	def reset
		@reference_text = [""]
		@errors = 0
		@accumulated_errors = 0
		@typed_text = [""] 
		@start_time = Time.now
		@end_time = nil
		@spaces = 0
	end

	def at_end?
		@typed_text.length == @reference_text.length and @typed_text.last.length == @reference_text.last.length
	end

	def at_start?
		@typed_text == [@indentations[0]]
	end

	def write_to_screen
		@window.attron(@color) { 
			yield
		}
	end

	def with_error_checking
		yield
		new_error_state = has_errors?
		if new_error_state == @has_errors
			return 
		end
		@has_errors = new_error_state
		if @has_errors
			@errors +=1
			@accumulated_errors += 1
			@color = color_pair(RED_BACKGROUND)
		else
			@errors -=1
			@color = color_pair(COLOR_GREEN)
		end
		return @has_errors
	end

	def type(letter)
		if at_end?
			return
		end
		has_errors = with_error_checking {@typed_text.last << letter}
		write_to_screen {
			@window << letter
		}
		done = at_end? && !has_errors
		if done
			@end_time = Time.now
		end
		return done
	end

	def erase
		if at_start?
			return
		end
		# if !is_current_index_correct
		# 	@errors -=1
		# end
		if @typed_text.last == (@indentations[@typed_text.length - 1] || "")
			with_error_checking{
				@typed_text = @typed_text[0...-1]
			}
			@window.setpos(@window.cury - 1, get_length(@typed_text.last))
		else
			with_error_checking{
				@typed_text = @typed_text[0...-1].push(@typed_text.last[0...-1])
			}
			@window.setpos(@window.cury, @window.curx - 1)
			@window.delch
		end
	end

	def get_length(text)
		return text.chars.map{ |c| c == "\t" ? CONSOLE_TAB_WIDTH : 1}.sum
	end

	def tab
		4.times {
			with_error_checking {
				@typed_text << " " 
			}
			write_to_screen {
				@window << " " 
			}
		}
	end

	def new_line
		@window.setpos(@window.cury+1, 0)
		@window << @indentations[@typed_text.length] || ""
		with_error_checking {
			@typed_text.push(@indentations[@typed_text.length].dup || "")
		}
	end

	def has_errors? 
		@typed_text.each_with_index do |line,index|
			if index == @typed_text.size - 1
				if !@reference_text[index]
					return false
				end
				return !@reference_text[index].start_with?(line)
			end
			if line != @reference_text[index]
				return true
			end
		end
		return false
	end

	def get_duration
		return @end_time - @start_time
	end


	def get_character_count
		return @reference_text.map { |line| line.size }.sum
	end

	def get_status
		return "lines: #{@typed_text.length}/#{@reference_text.length} " + 
			"last line: #{@typed_text.last.length}/#{@reference_text.last.length} errors: #{@accumulated_errors}"
	end

	def get_error_count
		return @accumulated_errors
	end

	def get_current_error_count
		return @errors
	end

	def get_index
		return [@typed_text.length - 1, @typed_text.last.length == 0 ? nil : @typed_text.last.length - 1]
	end

end
