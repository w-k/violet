require 'curses'
require 'securerandom'
require 'git'
require 'uri'
require 'tty-prompt'

require_relative 'table'
require_relative 'database'
require_relative 'session'
require_relative 'input'
require_relative 'display'
require_relative 'repo'
require_relative 'repo_provider'
require_relative 'push'
require_relative 'loop'


db = Database.new

@repos_dir = './repos'

def get_repo_labels
	return Dir["#{@repos_dir}/*/*"].map { |dir| 
		dir.sub("#{@repos_dir}/", '')
	}
end

selected_repo = ARGV[0]

while true
	if selected_repo
		include Curses
		init_screen
		start_color
		cbreak
		noecho
		RED_BACKGROUND = 101
		init_pair(RED_BACKGROUND, COLOR_BLACK, COLOR_RED) 
		init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK) 
		init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_BLACK) 
		init_pair(COLOR_GREEN, COLOR_GREEN, COLOR_BLACK) 
		init_pair(COLOR_YELLOW, COLOR_YELLOW, COLOR_BLACK) 
		init_pair(COLOR_MAGENTA, COLOR_MAGENTA, COLOR_BLACK) 
		begin
			window = Curses::Window.new(0, 0, 1, 2)
			window.keypad = true
			window.timeout = 0
			display = Display.new(window)
			provider = RepoProvider.new(selected_repo, /.+\.(io|java|rb|go|ts|c)$/, /\/test\//, @repos_dir, 10)
			input = Input.new(window)
			Loop.new(window, provider, display, input, db).start
		ensure
			close_screen
		end
	else
		prompt = TTY::Prompt.new
		selected_repo = prompt.select("Select repository") do |menu|
			get_repo_labels.each { |label| 
				menu.choice label
			}
		end
	end
end
