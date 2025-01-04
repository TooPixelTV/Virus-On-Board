extends Node2D

@export var story_lines: Array[CanvasLayer] = []

@onready var menu_ui: CanvasLayer = $MenuUI
@onready var story_ui: CanvasLayer = $StoryUI
@onready var ship_sprite: Sprite2D = $MenuUI/ShipSprite
@onready var twitch_channel_input: LineEdit = $MenuUI/VBoxContainer/TwitchConnection/TwitchChannelInput

var current_story: int = -1
var in_story = false

func _process(delta: float) -> void:
	ship_sprite.look_at(get_global_mouse_position())
	
	if in_story and (Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("move")):
		next_story()

func _on_start_btn_pressed() -> void:
	var twitch_channel = twitch_channel_input.text.strip_edges()
	if twitch_channel.length() > 0:
		VerySimpleTwitch.login_chat_anon(twitch_channel)
		Global.has_twitch_connection = true
	
	menu_ui.hide()
	story_ui.show()
	in_story = true
	next_story()

func next_story():
	current_story += 1
	
	if current_story > story_lines.size() - 1:
		start_game()
	else:
		for story in story_lines:
			story.hide()
		
		story_lines[current_story].show()
		
	
	
func start_game():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
