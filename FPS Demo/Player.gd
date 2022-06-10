extends KinematicBody

const MOUSE_SENSITIVITY: float = 0.2
const MOVE_SPEED: float = 3.0 
const GRAVITY_ACCELERATION: float = 5.0
const JUMP_FORCE: float = 3.0

onready var look_pivot: Spatial = $LookPivot
onready var anim_player = $AnimationPlayer
onready var camera = $Head/Camera
onready var raycast = $Head/Camera/Raycast

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var damage = 10;
var input_move: Vector3 = Vector3()
var gravity_local: Vector3 = Vector3()	
var snap_vector: Vector3 = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
 # Replace with function body.
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-1*event.relative.x) * MOUSE_SENSITIVITY)
		look_pivot.rotate_x(deg2rad(event.relative.y)*MOUSE_SENSITIVITY)
		look_pivot.rotation.x = clamp(look_pivot.rotation.x,deg2rad(-90),deg2rad(90))

func _physics_process(delta):
	input_move = get_input_direction() * MOVE_SPEED
	if not is_on_floor():
		gravity_local += GRAVITY_ACCELERATION * Vector3.DOWN * delta
	else:
		gravity_local = Vector3.ZERO
	
	snap_vector = Vector3.DOWN
	if is_on_floor():
		snap_vector = -get_floor_normal()
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap_vector = Vector3.ZERO
		gravity_local = Vector3.UP * JUMP_FORCE
		
	move_and_slide_with_snap(input_move + gravity_local, snap_vector, Vector3.UP)
	

func get_input_direction() -> Vector3:
	var z: float = (
		Input.get_action_strength("forward") - Input.get_action_strength("backward")
	)
	var x: float = (
		Input.get_action_strength("left") - Input.get_action_strength("right")
	)
	return transform.basis.xform(Vector3(x,0,z)).normalized()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
