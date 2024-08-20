extends Node2D

@onready var current_track = 0
@onready var track_1 = $"Devious"
@onready var track_2 = $"Mischief"
@onready var track_3 = $"Trouble"

func _ready():
	if !track_2.playing || !track_3.playing:
		track_1.play()
		current_track = 1

func change_tune(tune: int):
	if current_track == 1:
		track_1.stop()
	elif current_track == 2:
		track_2.stop()	
	elif current_track == 3:
		track_3.stop()	
		
	if (tune == 1):
		track_1.play()
	elif (tune == 2):
		track_2.play()
	elif (tune == 3):
		track_3.play()
	
	current_track = tune
