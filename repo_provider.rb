require './logger'
require './constants'

class RepoProvider

	def initialize(arg, whitelist_pattern, blacklist_pattern, repos_dir, chunk_size)
		@repo = Repo.new(arg, repos_dir)
		@chunk_size = chunk_size
		@whitelist_pattern = whitelist_pattern
		@blacklist_pattern = blacklist_pattern
	end

	def get_text
		@path, @use_count, @start_line_index = @repo.get(@whitelist_pattern, @blacklist_pattern)
		content = File.open(@path).read.scrub
		pattern = /\/\*.*?license.*?\*\//im
		# content_without_license_comments = content.sub(pattern, '').lstrip.chomp

		max_index_length = lines.size.to_s.size
		lines = content.lines.each_with_index.map{ |v,i| 
			padded_line_number = i.to_s.rjust(max_index_length)
			text = v.chomp.gsub("\t", ' ' * CONSOLE_TAB_WIDTH)
			initial_whitespace = text.match(/^\s*/)[0]
			if initial_whitespace
				text.sub!(/^\s*/, '·' * initial_whitespace.size)
			end
			[padded_line_number, text]
		}
		end_line_index= @start_line_index + @chunk_size-1
		@end_line_index = end_line_index > lines.size ? 0 : end_line_index

		chunk = lines[@start_line_index..@end_line_index]
		while chunk.first[1].strip.empty?
			chunk = chunk[1..-1]
		end
		while chunk.last[1].strip.empty?
			chunk = chunk[0..-2]
		end
		return {
			:path => @path,
			:lines => chunk,
			:start_line => @start_line_index,
			:size => lines.size
		}
	end

	def mark_text_used
		all_text_used = @end_line_index == 0
		@repo.set(@path, all_text_used ? @use_count + 1 : @use_count, @end_line_index+1)
	end
end
