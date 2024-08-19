extends Label

@export var type : int

func _process(delta):
	if (get_parent().current_selection != type):
		modulate.a = .50
	else:
		modulate.a = 1
