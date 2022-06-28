extends RigidBody

var shoot = false
const DAMAGE = 100
const SPEED = 5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	
func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)

func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		queue_free()
	else:
		queue_free()
