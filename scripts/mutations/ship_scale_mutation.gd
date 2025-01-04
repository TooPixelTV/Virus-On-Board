extends BaseMutation
class_name ShipScaleMutation

@export var min_scale: float = 0.1
@export var max_scale: float = 2

func _init() -> void:
	label = "Ship scale"
	
func apply() -> bool:
	var rnd_scale = randf_range(min_scale, max_scale)
	apply_scale(Vector2(rnd_scale, rnd_scale))
	
	return rnd_scale > 1.0

func reset():
	apply_scale(Vector2.ONE)

func apply_scale(scale: Vector2):
	Global.player.sprite_2d.scale = scale
	Global.player.collision_shape_2d.scale = scale
