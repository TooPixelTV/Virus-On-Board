extends CanvasLayer

@onready var virus_progress: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/VirusProgress
@onready var health_bar: ProgressBar = $HBoxContainer/HealthBar
@onready var time: Label = $MarginContainer/VBoxContainer/HBoxContainer2/Time
@onready var kills: Label = $MarginContainer/VBoxContainer/HBoxContainer3/Kills

func _ready() -> void:
	virus_progress.max_value = Global.max_virus_progression
	health_bar.max_value = Global.max_health

func _process(_delta: float) -> void:
	virus_progress.value = Global.virus_progression
	time.text = str(Global.current_time)
	kills.text = str(Global.current_kills)
	health_bar.value = Global.current_health
	
