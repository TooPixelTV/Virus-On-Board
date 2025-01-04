extends Area2D

@export var heal_value: int = 10

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bonus_sfx: AudioStreamPlayer = $BonusSFX

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.current_health = clamp(Global.current_health + heal_value, 0, Global.max_health)
		animation_player.play("heal")


func play_sfx():
	bonus_sfx.play()
