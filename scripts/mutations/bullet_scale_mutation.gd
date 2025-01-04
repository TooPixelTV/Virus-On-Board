extends BaseMutation
class_name BulletScaleMutation

@export var min_value: float = 0.3
@export var max_value: float = 2.5

func _init() -> void:
	label = "Bullet scale"
	
func apply() -> bool:
	var rnd = randf_range(min_value, max_value)
	Global.player.bullet_scale = rnd
	
	return rnd > 1.0

func reset():
	Global.player.bullet_scale = 1.0
