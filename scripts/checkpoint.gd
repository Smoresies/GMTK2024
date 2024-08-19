extends Sprite2D


func _on_checkpoint_body_entered(body):
	if body is Player:
		body.checkpoint = get_parent().position
		self.visible = true
