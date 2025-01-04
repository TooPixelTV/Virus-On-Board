extends Node

signal game_is_over

var has_twitch_connection: bool = false
var is_game_over: bool = false
var camera: MyCamera
var player: Player
var game_over: GameOver
var warning_layer: CanvasLayer
var current_time: int = 0
var current_kills: int = 0
var max_virus_progression: int = 100
var virus_progression: int = 0
var max_health: int = 100
var current_health = max_health

func _process(_delta: float) -> void:
	if current_health <= 0:
		current_health = 0
		game_is_over.emit()
		is_game_over = true
		game_over.set_score(current_time, current_kills)
		game_over.show()

func reset_game():
	is_game_over = false
	current_kills = 0
	current_time = 0
	virus_progression = 0
	current_health = max_health
