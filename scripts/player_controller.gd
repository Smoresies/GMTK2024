extends CharacterBody2D


const SPEED = 225.0
const JUMP_VELOCITY = -300.0
const PUSH_FORCE = 15
const MIN_PUSH_FORCE = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_meta("Player", self)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Pushing crates
	for i in get_slide_collision_count():
		
		var collision = get_slide_collision(i) # Used to get collider, and then used to apply push
		var collision_obj = collision.get_collider() # Used to check to see if push is valid
		
		# Check if object is Movable, and is not above the maximum pushing velocity
		#HACK Pushing Velocity current applied via const from this class
		if collision_obj.is_in_group("Movable") and abs(collision_obj.get_linear_velocity().x) < SPEED * 0.75:
			var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
			collision_obj.apply_central_impulse(collision.get_normal() * -push_force)

	move_and_slide()
