extends ParallaxBackground

@export var speed: float = 0.5
@onready var camera_2d: Camera2D = $"../Camera2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position += Vector2.ONE * speed
