class Session

	attr_reader :id, :timestamp, :path, :start_line, :character_count, :error_count, :duration

	def initialize(options)
		@id = options[:id]
		@timestamp = options[:timestamp]
		@path = options[:path]
		@start_line = options[:start_line]
		@character_count = options[:character_count]
		@duration = options[:duration]
		@error_count = options[:error_count]
	end
end
