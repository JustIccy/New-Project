extends KinematicBody

#Delcare Variables
const SWAY = 50
const VSWAY =30

var speed = 10
var h_acceleration = 3
var air_acceleration = 1
var normal_acceleration = 6
var gravity = 20
var jump = 15
var full_contact = false
var damage = 10

var mouse_sensitivity = 0.03

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var head = $Head
onready var ground_check = $GroundCheck
#onready var anim_play = $Head/Camera/AnimationPlayer
onready var hand = $Head/Hand
onready var handlock = $Head/HandLock
onready var aimcast = $Head/Camera/RayCast
onready var muzzle = $Head/Hand/Magnum/Muzzle


#on game start keep mouse within window bounds
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	hand.set_as_toplevel(true)
	
#capture mouse movement and clamps the head to specific bounds on the x axis
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	hand.global_transform.origin = handlock.global_transform.origin
	hand.rotation.y = lerp_angle(hand.rotation.y, rotation.y, SWAY * delta)
	hand.rotation.x = lerp_angle(hand.rotation.x, head.rotation.x, VSWAY * delta)

#Physics function: Deals with player movement and speed
func _physics_process(delta):
	
	direction = Vector3()
	
	#firing weapon
	if Input.is_action_just_pressed("fire"):
		print("fired gun")
		if aimcast.is_colliding():
			var bullet = get_world().direct_space_state	
			var collision = bullet.interact_ray(muzzle.transform.origin, aimcast.get_collision_point())
			
			if collision:
				var target = collision.collider
				if target.is_in_group("Enemy"):
					print("hit target")
					target.health -= damage
	
	#Calculate to check if player is either on the ground or jumping, as well as calculating for slopes and acceleration
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
		#anim_play.stop()
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration
		
	#Tracks Player controls
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)
	
	#Plays headbobbing animation
	#if direction != Vector3():
	#	anim_play.play("Headbob")
		
		
		



