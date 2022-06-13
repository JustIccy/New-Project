extends KinematicBody

const MOUSE_SENSITIVITY: float = 0.2
const MOVE_SPEED: float = 3.0 
const GRAVITY_ACCELERATION: float = 5.0
const JUMP_FORCE: float = 3.0
const MAX_CAM_SHAKE = 0.1

onready var look_pivot: Spatial = $LookPivot
onready var anim_player = $AnimationPlayer
onready var camera = $LookPivot/Camera
onready var raycast = $LookPivot/Camera/RayCast


var damage = 10;
var input_move: Vector3 = Vector3()
var gravity_local: Vector3 = Vector3()	
var snap_vector: Vector3 = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-1*event.relative.x) * MOUSE_SENSITIVITY)
		look_pivot.rotate_x(deg2rad(event.relative.y)*MOUSE_SENSITIVITY)
		look_pivot.rotation.x = clamp(look_pivot.rotation.x,deg2rad(-90),deg2rad(90))
		


	
func fire():
	if Input.is_action_pressed("fire"):
		if not anim_player.is_playing():
			camera.translation = lerp(camera.translation, 
				Vector3(rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 
				rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 0), 0.1)
			print("fired a shot")
			if raycast.is_colliding():
				var target = raycast.get_collider()
				if target.is_in_group("Enemy"):
					print("hit target")
					target.health -= damage
					
		anim_player.play("AR")
	else:
		anim_player.stop()
		
func _physics_process(delta):
	
	fire()
	
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
	
	



