extends Weapon
class_name Armed

# References
var animation_player

# Weapon States
var is_firing = false
var is_reloading = false

# Weapon Parameters
export var ammo_in_mag = 12
export var extra_ammo = 108
onready var mag_size = ammo_in_mag

export var damage = 25
export var fire_rate = 0.3

# Effects
export(PackedScene) var impact_effect
export(NodePath) var muzzle_flash_path
onready var muzzle_flash = get_node(muzzle_flash_path)


# Optional
export var equip_speed = 0.5
export var unequip_speed = 0.5
export var reload_speed = 0.6

# Fire Single
func fire_single():
	if not is_reloading:
		if ammo_in_mag > 0:
			if not is_firing:
				is_firing = true
				animation_player.get_animation("Fire").loop = false
				animation_player.play("Fire", -1.0, fire_rate)


				var wait_time = animation_player.current_animation_length / fire_rate
				yield(get_tree().create_timer(wait_time), "timeout")
				is_firing = false

# Fire Cycle
func fireCycle():
	if not is_reloading:
		if ammo_in_mag > 0:
			if not is_firing:
				is_firing = true
				animation_player.get_animation("Fire").loop = true
				animation_player.play("Fire", -1.0, fire_rate)
			
			return
		
		elif is_firing:
			fire_stop()

func fire_stop():
	is_firing = false
	animation_player.get_animation("Fire").loop = false


func fire_bullet():    # Will be called from the animation track
	muzzle_flash.emitting = true
	update_ammo("consume")
	
	ray.force_raycast_update()
	
	if ray.is_colliding():
		var impact = Global.instantiate_node(impact_effect, ray.get_collision_point())
		impact.emitting = true


# Reload
func reload():
	if ammo_in_mag < mag_size and extra_ammo > 0:
		is_firing = false
		
		animation_player.play("Reload", -1.0, reload_speed)
		is_reloading = true


# Equip/Unequip Cycle
func equip():
	animation_player.play("Equip", -0.5, equip_speed)
	is_reloading = false

func unequip():
	animation_player.play("Unequip", -0.5, unequip_speed)

func is_equip_finished():
	if is_equipped:
		return true
	else:
		return false

func is_unequip_finished():
	if is_equipped:
		return false
	else:
		return true



# Show/Hide Weapon
func show_weapon():
	visible = true

func hide_weapon():
	visible = false



# Animation Finished
func on_animation_finish(anim_name):
	match anim_name:
		"Unequip":
			is_equipped = false
		"Equip":
			is_equipped = true
		"Reload":
			is_reloading = false
			update_ammo("reload")



# Update Ammo
func update_ammo(action = "Refresh", additional_ammo = 0):
	
	match action:
		"consume":
			ammo_in_mag -= 1
		
		"reload":
			var ammo_needed = mag_size - ammo_in_mag
			
			if extra_ammo > ammo_needed:
				ammo_in_mag = mag_size
				extra_ammo -= ammo_needed
			else:
				ammo_in_mag += extra_ammo
				extra_ammo = 0
		
		"add":
			extra_ammo += additional_ammo
			
	
	var weapon_data = {
		"Name" : weapon_name,
		"Image" : weapon_image,
		"Ammo" : str(ammo_in_mag),
		"ExtraAmmo" : str(extra_ammo)
	}
	
	weapon_manager.update_hud(weapon_data)	
