KEY_NAME = {
	127 => 'backspace',
	27 => 'escape',
	258 => 'down',
	9 => 'tab',
	10 => 'enter',
	19 => 'ctrl_s',
	2 => 'ctrl_b'
}

KEY = {
	:backspace => 127,
	:escape => 27,
	:down => 258,
	:tab => 9,
	:enter => 10,
	:ctrl_s => 19,
	:ctrl_b => 2
}

class Loop

	def initialize(window, provider, display, input, database)
		@window = window
		@provider = provider
		@display = display
		@input = input
		@database = database
		@breadcrumbs = []
	end

	def save_session_data(path, start_line)
		session = Session.new({
			:id => SecureRandom.uuid,
			:timestamp => Time.now, 
			:path => path,
			:start_line => start_line,
			:character_count => @input.get_character_count, 
			:duration => @input.get_duration,
			:error_count => @input.get_error_count
		})
		@database.add_session(session)
	end

	def show_summary
		headers = ["timestamp", "cpm", "length (characters)", "accuracy (%), path"]
		rows = @database.get_all_sessions.slice(0..20).map { |s| 
			[
				s.timestamp, 
				(s.character_count / s.duration.to_f * 60).to_i, 
				s.character_count, 
				((s.character_count - s.error_count) / s.character_count.to_f * 100).to_i,
				s.path
			] 
		}
		@window << Table.new(rows.unshift(headers)).to_s
	end

	def start
		text = @provider.get_text
		@display.load(text)
		@input.load(text, @display.last_line + 2)

		current_mode = :typing
		mode_handlers = { 
			:typing => Proc.new { |key|
				if key 
					@breadcrumbs.push(KEY_NAME[key] || key.to_s)
				end
				if key == KEY[:backspace]
					@input.erase
				elsif key == KEY[:escape]
					exit(0)
				elsif key == KEY[:down]
					@window.clear
					@window.setpos(0, 0)
					text = @provider.get_text
					@display.load(text)
					@input.load(text, @display.last_line + 2)
				elsif key == KEY[:tab]
					@input.tab
				elsif key == KEY[:enter]
					@input.new_line
				elsif key == KEY[:ctrl_s]
					@window.clear
					@window.setpos(0, 0)
					@provider.mark_text_used
					text = @provider.get_text
					@display.load(text)
					@input.load(text, @display.last_line + 2)
				elsif key == KEY[:ctrl_b]
					log("breadcrumbs: #{@breadcrumbs.join(' ')}")
					@breadcrumbs = []
				elsif key != nil
					if @input.type(key.to_s)
						@breadcrumbs = []
						current_mode = :stats
						@window.clear
						@window.setpos(0, 0)
						@provider.mark_text_used
						save_session_data(text[:path], text[:start_line])
						@input.reset
						show_summary
					end
				end
				if current_mode == :typing
					@display.set_index(@input.get_index)
				end
			},
			:stats => Proc.new { |key|
				if key == KEY[:enter]
					current_mode = :typing
					@window.clear
					@window.setpos(0, 0)
					text = @provider.get_text
					@display.load(text)
					@input.load(text, @display.last_line + 2)
				elsif key == KEY[:escape]
					exit(0)
				end
			}
		}

		loop do
			mode_handlers[current_mode].call(@window.getch)
			@window.refresh
			if current_mode == :typing
				push(@window, @display.last_line+1, 0) do 
					@window.clrtoeol
					@window.attron(color_pair(COLOR_BLUE)) { @window << @input.get_status}
				end
				@display.set_error(@input.get_current_error_count > 0)
			end
		end

	end
end
