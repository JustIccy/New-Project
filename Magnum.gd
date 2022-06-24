extends MeshInstance

var damage = 25
var is_equipped = false
onready var ROF = $ROF
onready var MG_Anim = $MG_Anim
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("fire") && ROF.is_stopped() && is_equipped == true:
		MG_Anim.play("MG_Anim")
		if MG_Anim.is_playing():
			ROF.start()


func _on_Timer_timeout():
	pass
