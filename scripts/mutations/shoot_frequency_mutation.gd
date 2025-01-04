extends BaseMutation
class_name ShootFrequencyMutation

@export var min_value: float = 0.1
@export var max_value: float = 2.0

func _init() -> void:
	label = "Shoot cooldown"
	
func apply() -> bool:
	var rnd = randf_range(min_value, max_value)
	Global.player.shoot_cooldown = rnd
	
	return rnd > Global.player.default_shoot_cooldown

func reset():
	Global.player.shoot_cooldown = Global.player.default_shoot_cooldown
