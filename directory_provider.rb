require './logger'

class DirectoryProvider

	def initialize(directory, whitelist_pattern, blacklist_pattern)
		@paths= Dir.glob("#{directory}/**/*").filter{ |p| !File.directory?(p) && p.match(whitelist_pattern)}.reject{ |p| p.match(blacklist_pattern) }
	end

	def get_text
		path = @paths[rand(@paths.length)]
		content = File.open(path).read.scrub
		pattern = /\/\*.*?license.*?\*\//im
		content_without_license_comments = content.sub(pattern, '').lstrip
		return {
			:path => path,
			:content => content_without_license_comments
		}
		# return {
		# 	:path => "foo/bar",
		# 	:content => "foo\n  bar\n\n"
		# }
	end
end
