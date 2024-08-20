extends VBoxContainer

@onready var current_selection : int = 1
@onready var selected : bool = false
@onready var move_sfx := $move
@onready var select_sfx := $select

@export var black_screen : ColorRect

func _process(delta):
	#Lets the player move up and down the menu
	if Input.is_action_just_pressed("jump") && current_selection > 1:
		current_selection -= 1
		move_sfx.play()
	if Input.is_action_just_pressed("crouch") && current_selection < 3:
		current_selection += 1
		move_sfx.play()
		
	#Awaits the selection input
	if Input.is_action_just_pressed("select"):
		if current_selection == 1:
			#Temp Timer system
			var timer : int = 0
			while (timer < 300):
				black_screen.modulate.a += 1 / 300
				timer += 1
			select_sfx.play()
			selected = true
			await select_sfx.finished
			AudioManager.change_tune(2)
			get_tree().change_scene_to_file("res://scenes/training_level.tscn")
		elif current_selection == 2:
			select_sfx.play()
			selected = true
			await select_sfx.finished
			get_tree().change_scene_to_file("res://scenes/credits.tscn")
		elif current_selection == 3:
			select_sfx.play()
			selected = true
			await select_sfx.finished
			get_tree().quit()
