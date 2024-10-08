class_name Player
extends CharacterBody2D


const SPEED = 225.0
const JUMP_VELOCITY = -300.0
const PUSH_FORCE = 15
const MIN_PUSH_FORCE = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var checkpoint: Vector2
var paused: bool = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_timer = %CoyoteTimer
@onready var smoke = $Smoke

@onready var player_jump_scuffle = $Audio/PlayerJumpScuffle
@onready var player_landing_scuffle = $Audio/PlayerLandingScuffle
@onready var vo_player_jump = $Audio/VOPlayerJump
@onready var vo_player_push = $Audio/VOPlayerPush
@onready var vo_player_laugh = $Audio/VOPlayerLaugh
@onready var reset_stage_transition_in = $Audio/ResetStageTransitionIn
@onready var reset_stage_transition_out = $Audio/ResetStageTransitionOut


@onready var player_footstep_wood = $Audio/PlayerFootstepWood
var footstep_frames : Array = [1,3]

func _ready():
	set_meta("Player", self)
	checkpoint = position
	animated_sprite_2d.visible = false
	paused = true
	await get_tree().create_timer(5).timeout
	reset_stage_transition_out.play()
	smoke.emitting = true
	animated_sprite_2d.visible = true
	await smoke.finished
	paused = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		#print(animated_sprite_2d.animation)
		if (!animated_sprite_2d.is_playing() or animated_sprite_2d.animation == "idle" or animated_sprite_2d.animation == "walk"):
			animated_sprite_2d.play(("midair"))

	if paused == true:
		move_and_slide()
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0 and animated_sprite_2d.flip_h:
			animated_sprite_2d.flip_h = false
		elif direction < 0 and !animated_sprite_2d.flip_h:
			animated_sprite_2d.flip_h = true
		if is_on_floor() and animated_sprite_2d.animation != "walk":
			animated_sprite_2d.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if animated_sprite_2d.animation == "walk" or !animated_sprite_2d.is_playing():
			animated_sprite_2d.play("idle")
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()) :
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jump_start")
		player_jump_scuffle.play()
		vo_player_jump.play()
		
		
	
	# Pushing crates, only done while on ground
	if is_on_floor():
		for i in get_slide_collision_count():
			
			var collision = get_slide_collision(i) # Used to get collider, and then used to apply push
			var collision_obj = collision.get_collider() # Used to check to see if push is valid
			
			# Check if object is Movable, and is not above the maximum pushing velocity
			#HACK Pushing Velocity current applied via const from this class
			if collision_obj.is_in_group("Movable") and abs(collision_obj.get_linear_velocity().x) < SPEED * 0.75:

				var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
				# var pushDir := Vector2(velocity.x, 0).normalized()
				# print(pushDir)
				collision_obj.apply_central_impulse(collision.get_normal() * -push_force)
				#if animated_sprite_2d.animation != "push" and pushDir != Vector2.ZERO:
				#	print("about to push")
				#	animated_sprite_2d.play("push")
					

	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	
	# coyote timer, just left ground but not in midair yet
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	
	# if we were midair last frame, but are on floor now.
	if !was_on_floor and is_on_floor():
		animated_sprite_2d.play("landing")
		player_landing_scuffle.play()

func _input(event):
	if event.is_action_pressed("restart") and !paused:
		reset_stage_transition_in.play()
		velocity = Vector2.ZERO
		paused = true
		animated_sprite_2d.visible = false
		smoke.emitting = true
		await smoke.finished
		goToCheckpoint()
		animated_sprite_2d.visible = true
		paused = false

func goToCheckpoint():
	position = checkpoint

func pause(wait_time: int):
	paused = true
	await get_tree().create_timer(wait_time).timeout
	paused = false

func leave(theme: int):
		pause(10)
		
		animated_sprite_2d.play("walk")
		
		await shrink(2)
		
		if (theme != 0):
			AudioManager.change_tune(theme)
		
		

func shrink(end_time: int):
	var grow_time = 0
	while (grow_time < end_time):
		await get_tree().create_timer(0.01).timeout
		if (scale.x >= 0):
			scale.x -= .15
		else:
			scale.x = 0
		if (scale.y >= 0):
			scale.y -= .15
		else:
			scale.y = 0
		grow_time += .1
		
	animated_sprite_2d.visible = false

## Handle footstep sound trigger
func _on_animated_sprite_2d_frame_changed():
	if animated_sprite_2d.animation == "idle": return
	if animated_sprite_2d.animation == "midair" :return
	if animated_sprite_2d.animation == "jump_start": return
	
	if animated_sprite_2d.frame in footstep_frames: player_footstep_wood.play()

