
def push(window, target_y, target_x)
	current_y = window.cury
	current_x = window.curx
	window.setpos(target_y, target_x)
	yield
	window.setpos(current_y, current_x)
end
