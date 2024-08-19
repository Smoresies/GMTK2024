extends VBoxContainer

@onready var current_selection : int = 1

func _process(delta):
	#Lets the player move up and down the menu
	if Input.is_action_just_pressed("jump") && current_selection > 1:
		current_selection -= 1
	if Input.is_action_just_pressed("crouch") && current_selection < 3:
		current_selection += 1
		
	#Awaits the selection input
	if Input.is_action_just_pressed("restart"):
		if current_selection == 1:
			get_tree().change_scene_to_file("res://scenes/training_level.tscn")
		elif current_selection == 2:
			pass
			#Will eventually take the player to the credits scene or something
			#get_tree().change_scene("res://scenes/training_level.tscn")
		elif current_selection == 3:
			get_tree().quit()
