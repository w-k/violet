require 'sqlite3'

class Database

	def initialize
		@db = SQLite3::Database.new './test2.db'
		@db.execute("
			create table if not exists sessions (
				id text primary key, 
				timestamp text, 
				path text,
				start_line number,
				character_count number,
				duration number, 
				errors number
				);
		")
	end

	def add_session(session)
		@db.execute("insert into sessions values (?,?,?,?,?,?,?)", [
			session.id,
			session.timestamp.to_s,
			session.path,
			session.start_line,
			session.character_count,
			session.duration,
			session.error_count
		])
	end
	
	def get_all_sessions
		result = []
		@db.execute("select id, timestamp, path, start_line, character_count, duration, errors from sessions order by timestamp desc") do |row| 
			result.push(Session.new({
				:id => row[0],
				:timestamp => row[1], 
				:path => row[2], 
				:start_line=> row[3],
				:character_count=> row[4],
				:duration => row[5],
				:error_count=> row[6],
			}))
		end
		return result
	end

end
