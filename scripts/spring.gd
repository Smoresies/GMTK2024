extends Area2D

@export var SPRINGFORCE: float = 1000
@onready var spring_animator = $SpringAnimator


func _on_body_entered(body):
		#print(body)
	if body.get_meta("Player"):
		# var vectorTo: Vector2 = (position.direction_to(body.position) + transform.y).normalized()
		body.velocity = -transform.y * SPRINGFORCE
		spring_animator.play("bounce")
		await spring_animator.animation_finished
		spring_animator.play("default")
