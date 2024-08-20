extends Node2D

@onready var track_1 = $"Devious"
@onready var track_2 = $"Mischief"
@onready var track_3 = $"Trouble"


func _ready():
	
	if !track_2.playing || !track_3.playing:
		track_1.play()

func change_tune(tune: int):
	if (tune == 2):
		track_1.stop()
		track_2.play()
	elif (tune == 3):
		track_2.stop()
		track_3.play()
	pass # Replace with function body.
