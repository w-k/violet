RECORD = {
	:change_count => 0,
	:path => 1,
	:use_count => 2,
	:line_index => 3
}

class Repo

	def initialize(arg, repos_dir)
		url = arg
		if url !~ URI::regexp
			url = "https://github.com/#{url}"
		end
		repo_name = url.split('/')[-2..-1].join("/").chomp(".git")
		@repo_path = "#{repos_dir}/#{repo_name}"
		if !exists(@repo_path)
			`git clone #{url} #{@repo_path}`
		end
		if !exists("#{@repo_path}/.violet")
			`cd #{@repo_path} && git log --pretty=format: --name-only \| sort \| uniq -c >> .violet`
		end
	end

	def sort_records(a,b)
		a_use_count = (a[RECORD[:use_count]] || 0).to_i
		b_use_count = (b[RECORD[:use_count]] || 0).to_i
		a_change_count = (a[RECORD[:change_count]]).to_i
		b_change_count = (b[RECORD[:change_count]]).to_i
		if a_use_count == b_use_count
			return b_change_count <=> a_change_count
		else
			return a_use_count <=> b_use_count
		end
	end

	def get(whitelist_pattern, blacklist_pattern)
		records = File.open("#{@repo_path}/.violet").readlines.map { |r| r.lstrip.split(" ")}
		records = records.filter{ |r| 
			r[RECORD[:path]] && 
			!File.directory?(r[RECORD[:path]]) && 
			r[RECORD[:path]].match(whitelist_pattern)
		}.reject{ |r| 
			r[RECORD[:path]].match(blacklist_pattern) || !exists("#{@repo_path}/#{r[RECORD[:path]]}")
		}
		if records.size > 0
			sorted_records = records.sort { |a,b| sort_records(a,b) }
			top = sorted_records[0]
			return "#{@repo_path}/#{top[RECORD[:path]]}", (top[RECORD[:use_count]] || 0).to_i, (top[RECORD[:line_index]] || 0).to_i
		end
	end

	def set(path, use_count, line_index)
		records = File.open("#{@repo_path}/.violet").readlines.map { |r| r.lstrip.split(" ")}
		path_in_repo = path.sub("#{@repo_path}/", '')
		record = records.bsearch { |r| 
			!r[RECORD[:path]] ? false : r[RECORD[:path]] >= path_in_repo 
		}
		record[RECORD[:use_count]] = use_count.to_s
		record[RECORD[:line_index]] = line_index.to_s
		output = records.map{ |r| r.join(" ")}.join("\n")
		File.open("#{@repo_path}/.violet", 'w') { |file| file.write(output)}
	end

	def exists(dir)
		return Dir.glob(dir).length != 0
	end

end
