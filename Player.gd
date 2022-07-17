extends KinematicBody

#Delcare Variables
const SWAY = 40
const VSWAY =40

var full_contact = false


var speed = 12
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 2
onready var accel = ACCEL_DEFAULT
var gravity = 12
var jump = 10

var cam_accel = 40
var mouse_sense = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()


onready var head = $Head
onready var rect = $Head/Camera/TextureRect
onready var cam = $Head/Camera
onready var ground_check = $GroundCheck

onready var GunCam = $Head/Camera/ViewportContainer/Viewport/GunCam
onready var weapon_manager = $Head/Camera/weapons




#on game start keep mouse within window bounds
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	
#capture mouse movement and clamps the head to specific bounds on the x axis
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
	
func _process(delta):
	
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		cam.set_as_toplevel(true)
		cam.global_transform.origin = cam.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		cam.rotation.y = rotation.y
		cam.rotation.x = head.rotation.x
	else:
		cam.set_as_toplevel(false)
		cam.global_transform = head.global_transform

	GunCam.global_transform = cam.global_transform

#Physics function: Deals with player movement and speed
func _physics_process(delta):
	process_weapons()
	process_jump(delta)
	process_movement(delta)

func process_jump(delta):
#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
		
func process_movement(delta):
	
	direction = Vector3()
	
	
	#Calculate to check if player is either on the ground or jumping, as well as calculating for slopes and acceleration
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var h_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	
func process_weapons():
	if Input.is_action_just_pressed("No weapons"):
		weapon_manager.change_weapon("Empty")
	if Input.is_action_just_pressed("weapon1"):
		weapon_manager.change_weapon("Primary")

