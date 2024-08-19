class_name Player
extends CharacterBody2D


const SPEED = 225.0
const JUMP_VELOCITY = -300.0
const PUSH_FORCE = 15
const MIN_PUSH_FORCE = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var checkpoint: Vector2

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_timer = %CoyoteTimer

func _ready():
	set_meta("Player", self)
	checkpoint = position


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		print(animated_sprite_2d.animation)
		if !animated_sprite_2d.is_playing() and animated_sprite_2d.animation != "midair":
			animated_sprite_2d.play(("midair"))



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
	
	# Pushing crates, only done while on ground
	if is_on_floor():
		for i in get_slide_collision_count():
			
			var collision = get_slide_collision(i) # Used to get collider, and then used to apply push
			var collision_obj = collision.get_collider() # Used to check to see if push is valid
			
			# Check if object is Movable, and is not above the maximum pushing velocity
			#HACK Pushing Velocity current applied via const from this class
			if collision_obj.is_in_group("Movable") and abs(collision_obj.get_linear_velocity().x) < SPEED * 0.75:
				var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
				collision_obj.apply_central_impulse(collision.get_normal() * -push_force)

	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	
	# coyote timer, just left ground but not in midair yet
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	
	# if we were midair last frame, but are on floor now.
	if !was_on_floor and is_on_floor():
		animated_sprite_2d.play("landing")

func _input(event):
	if event.is_action_pressed("restart"):
		goToCheckpoint()
		#TODO Set this to an animation controller, have the player go back AFTER they have done animation

func goToCheckpoint():
	position = checkpoint
