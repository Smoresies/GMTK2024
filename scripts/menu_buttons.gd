extends Label

@export var type : int
@onready var button := $Button

func _process(delta):
	if (get_parent().current_selection != type):
		modulate.a = .50
	else:
		if(get_parent().selected == true):
			button.modulate.a = .85
		modulate.a = 1
