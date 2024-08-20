extends Area2D

@export var SPRINGFORCE: float = 1000
@onready var spring_animator = $SpringAnimator


func _on_body_entered(body):
		#print(body)
	if body is Player:
		# var vectorTo: Vector2 = (position.direction_to(body.position) + transform.y).normalized()
		#print(transform.y)
		# Transform.y WORKS, but player movement is current resetting horizontal to 0
		body.velocity = Vector2.UP * SPRINGFORCE
		#print(body.velocity)
		spring_animator.play("bounce")
		await spring_animator.animation_finished
		spring_animator.play("default")
