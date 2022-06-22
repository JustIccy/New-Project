extends MeshInstance

var damage = 25
var is_equipped = false
var bullet_delay = 0.3
onready var MG_Anim = $MG_Anim
onready var MG_Sound = $AudioStreamPlayer3D2
onready var ROF = $ROF
# Called when the node enters the scene tree for the first time.
func _ready():	
	
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("fire") && ROF.is_stopped() && is_equipped == true:
		MG_Anim.play("MG Animation")
		if MG_Anim.is_playing():
			ROF.start()
			MG_Sound.play()
		




func _on_Timer_timeout():
	pass # Replace with function body.
