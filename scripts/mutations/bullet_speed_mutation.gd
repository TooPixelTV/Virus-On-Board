extends BaseMutation
class_name BulletSpeedMutation

@export var min_value: float = 50.0
@export var max_value: float = 250.0

func _init() -> void:
	label = "Bullet speed"
	
func apply() -> bool:
	var rnd = randf_range(min_value, max_value)
	Global.player.bullet_speed = rnd
	
	return rnd > Global.player.default_bullet_speed

func reset():
	Global.player.bullet_speed = Global.player.default_bullet_speed
