extends Area2D

@export var theme_change: int = 0

func _on_body_entered(body):
	if body is Player:
		body.leave(theme_change)
