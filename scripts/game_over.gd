extends CanvasLayer
class_name GameOver

@onready var survived_time: Label = $Panel/VBoxContainer/SurvivedTime
@onready var total_kills: Label = $Panel/VBoxContainer/TotalKills

func set_score(score: int, kills: int):
	survived_time.text = "You survived " + str(score) + " seconds."
	total_kills.text = "You killed " + str(kills) + " enemies."

func _on_restart_btn_pressed() -> void:
	get_tree().reload_current_scene()
	Global.reset_game()
