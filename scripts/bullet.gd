extends CharacterBody2D

@export var speed: float = 1.0
@export var direction = Vector2.RIGHT
@export var damage: int = 1
@export var attack_range: float = 100.0

var start_position: Vector2

func _ready() -> void:
	start_position = global_position

func _process(_delta: float) -> void:
	if start_position.distance_to(global_position) >= attack_range:
		queue_free()
	
	velocity = direction * speed
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		queue_free()
