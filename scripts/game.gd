extends Node2D

const HEAL = preload("res://scenes/heal.tscn")
const BONUS = preload("res://scenes/bonus.tscn")
const MUTATION_DISPLAY = preload("res://scenes/mutation_display.tscn")

@export var enemies: Array[PackedScene]
@export var mutations: Array[Resource]
@export var virus_progress_step:int  = 5
@export var virus_warning_threshold: int = 90
@export var max_mutations: int = 3

@onready var spawn_path_follow: PathFollow2D = $Player/SpawnPath/SpawnPathFollow
@onready var game_over: CanvasLayer = $GameOver
@onready var time_timer: Timer = $TimeTimer
@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var mutation_warning: CanvasLayer = $MutationWarning
@onready var mutations_list: VBoxContainer = $UI/MutationMargin/Mutations

@onready var heal_point_left: PathFollow2D = $Player/HealLeft/HealPointLeft
@onready var heal_point_right: PathFollow2D = $Player/HealRight/HealPointRight
@onready var heal_point_top: PathFollow2D = $Player/HealTop/HealPointTop
@onready var heal_point_down: PathFollow2D = $Player/HealDown/HealPointDown

@onready var heal_timer: Timer = $HealTimer

var mouse_cursor = load("res://assets/cursor.png")

func _ready() -> void:
	if Global.has_twitch_connection:
		VerySimpleTwitch.chat_message_received.connect(_handle_twitch_message)
	else:
		heal_timer.start()
	
	Input.set_custom_mouse_cursor(mouse_cursor)
	Global.player = get_tree().get_first_node_in_group("player")
	Global.game_over = game_over
	Global.game_is_over.connect(_on_game_over)
	Global.camera = camera_2d
	Global.warning_layer = mutation_warning

func spawn_item():
	var rand_pos = randf()
	spawn_path_follow.progress_ratio = rand_pos
	
	var instance = BONUS.instantiate()
	instance.global_position = spawn_path_follow.global_position
	get_tree().current_scene.add_child(instance)

func spawn_enemy():
	var selected = enemies.pick_random()
	
	var rand_pos = randf()
	spawn_path_follow.progress_ratio = rand_pos
	
	var instance = selected.instantiate()
	instance.global_position = spawn_path_follow.global_position
	get_tree().current_scene.add_child(instance)

func apply_mutations():
	for element in mutations_list.get_children():
		element.queue_free()
	
	for mutation in mutations:
		mutation = mutation as BaseMutation
		mutation.reset()
		
	var pool = mutations.duplicate(true)
	pool.shuffle()
	
	for i in max_mutations:
		var current_mutation = pool.pop_front() as BaseMutation
		var result = current_mutation.apply()
		
		var display_instance = MUTATION_DISPLAY.instantiate()
		display_instance.mutation_label = current_mutation.label
		display_instance.is_positive = result
		mutations_list.add_child(display_instance)

func virus_progress():
	Global.virus_progression += virus_progress_step
	
	var virus_percent = (float(Global.virus_progression * 100.0)) / float(Global.max_virus_progression)
	if virus_percent >= virus_warning_threshold:
		Global.warning_layer.show()
	else:
		Global.warning_layer.hide() 
	
	if Global.virus_progression >= Global.max_virus_progression:
		Global.virus_progression = 0
		apply_mutations()

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func _on_game_over():
	time_timer.stop()

func _on_virus_timer_timeout() -> void:
	virus_progress()

func _on_time_timer_timeout() -> void:
	Global.current_time += 1

func _on_item_timer_timeout() -> void:
	spawn_item()

func _handle_twitch_message(data: Chatter):
	if data.message.begins_with("!"):
		spawn_heal(data.message)

func spawn_heal(side: String):
	var position = Vector2.ZERO
	var rand_pos = randf()
	
	match side:
		"!top":
			heal_point_top.progress_ratio = rand_pos
			position = heal_point_top.global_position
		"!bottom":
			heal_point_down.progress_ratio = rand_pos
			position = heal_point_down.global_position
		"!left":
			heal_point_left.progress_ratio = rand_pos
			position = heal_point_left.global_position
		"!right":
			heal_point_right.progress_ratio = rand_pos
			position = heal_point_right.global_position
	
	if position != Vector2.ZERO:
		var instance = HEAL.instantiate()
		instance.global_position = position
		get_tree().current_scene.add_child(instance)

func _on_heal_timer_timeout() -> void:
	var side = ["!top", "!bottom", "!left", "!right"].pick_random()
	spawn_heal(side)
