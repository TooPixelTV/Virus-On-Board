extends BaseMutation
class_name ShipSpeedMutation

@export var min_value: float = 10.0
@export var max_value: float = 300.0

func _init() -> void:
	label = "Ship speed"
	
func apply() -> bool:
	var rnd = randf_range(min_value, max_value)
	Global.player.speed = rnd
	
	return rnd > Global.player.default_speed

func reset():
	Global.player.speed = Global.player.default_speed
