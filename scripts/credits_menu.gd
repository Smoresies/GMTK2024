extends VBoxContainer

@onready var current_selection : int = 1
@onready var selected : bool = false
@onready var select_sfx := $select

func _process(delta):
	if Input.is_action_just_pressed("select"):
		select_sfx.play()
		selected = true
		await select_sfx.finished
		get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")
