def log(line)
	File.open('./log.txt', 'a') { |file| file.write("#{line}\n")}
end
