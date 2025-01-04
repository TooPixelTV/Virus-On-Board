extends HBoxContainer
class_name MutationDisplay

@export var mutation_label: String = ""
@export var is_positive: bool = true

@onready var label: Label = $Label
@onready var icon: TextureRect = $Icon

const UP_ARROW = preload("res://assets/up_arrow.png")
const DOWN_ARROW = preload("res://assets/down_arrow.png")

func _ready() -> void:
	label.text = mutation_label
	if is_positive:
		icon.texture = UP_ARROW
	else:
		icon.texture = DOWN_ARROW
