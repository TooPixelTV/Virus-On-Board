extends Area2D

@export var bonus_value: int = 10

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bonus_sfx: AudioStreamPlayer = $BonusSFX

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.virus_progression = clamp(Global.virus_progression - bonus_value, 0, Global.max_virus_progression)
		animation_player.play("explode")


func play_sfx():
	bonus_sfx.play()
