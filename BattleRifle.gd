extends MeshInstance

var damage = 17
var bullet_delay = 0.8
var is_equipped = false
onready var BR_Anim = $BR_Anim
onready var BR_Sound = $BR_Sound
onready var ROF = $ROF
# Called when the node enters the scene tree for the first time.
func _ready():	
	
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("fire") && ROF.is_stopped() && is_equipped == true:
		BR_Anim.play("BR_anim")
		if BR_Anim.is_playing():
			ROF.start()
			BR_Sound.play()
		



func _on_Timer_timeout():
	pass
