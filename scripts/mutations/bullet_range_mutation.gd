extends BaseMutation
class_name BulletRangeMutation

@export var min_value: float = 3.0
@export var max_value: float = 300.0

func _init() -> void:
	label = "Bullet range"

func apply() -> bool:
	var rnd = randf_range(min_value, max_value)
	Global.player.bullet_range = rnd
	
	return rnd > Global.player.default_bullet_range

func reset():
	Global.player.bullet_range = Global.player.default_bullet_range
