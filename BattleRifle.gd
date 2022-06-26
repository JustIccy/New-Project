extends MeshInstance

var damage = 17
var is_equipped = false
onready var ROF = $ROF
onready var BR_Anim = $BR_Anim
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("fire") && ROF.is_stopped() && is_equipped == true:
		if BR_Anim.is_playing():
			ROF.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
