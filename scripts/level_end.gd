extends Area2D

@export var theme_change: int = 0
@export var newScene: PackedScene
@onready var vo_stage_finish_stinger = $VOStageFinishStinger
@onready var mini_mischief_popup_in = $MiniMischiefPopupIn


func _on_body_entered(body):
	if body is Player:
		vo_stage_finish_stinger.play()
		mini_mischief_popup_in.play()
		await body.leave(theme_change)
		await mini_mischief_popup_in.finished
		get_tree().change_scene_to_packed(newScene)
