extends CharacterBody2D
class_name Enemy

@export var health: int = 2
@export var speed: float = 50.0
@export var damage: int = 20
@export var die_sounds: Array[AudioStream]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var die_sfx: AudioStreamPlayer = $DieSFX

var target: RigidBody2D

func _ready() -> void:
	die_sfx.finished.connect(queue_free)
	animation_player.animation_finished.connect(_on_damage_anim_end)
	target = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	var direction = position.direction_to(target.position)
	velocity = direction * speed
	move_and_slide()

func take_damage(value:int):
	health -= value
	
	collision_shape_2d.set_deferred("disabled", true)
	if health <= 0:
		animation_player.play("Global/die")
		Global.camera.add_trauma(0.2)
	else:
		animation_player.play("hurt")


func _on_damage_anim_end(_anim_name: String):
	collision_shape_2d.disabled = false
	
func play_die_sfx():
	Global.current_kills += 1
	var selected_sound = die_sounds.pick_random()
	die_sfx.stream = selected_sound
	die_sfx.play()
