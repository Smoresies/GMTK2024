extends Sprite2D

@export var SPRINGFORCE: float = 1000


func _on_area_2d_body_entered(body):
	if body.get_meta("Player"):
		var vectorTo: Vector2 = (position.direction_to(body.position) + transform.y).normalized()
		body.velocity += Vector2.UP * SPRINGFORCE
