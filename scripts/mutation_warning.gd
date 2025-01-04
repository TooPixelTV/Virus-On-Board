extends CanvasLayer

@onready var warning_sound: AudioStreamPlayer = $WarningSound
@onready var warning_animation: AnimationPlayer = $WarningAnimation

func _process(_delta: float) -> void:
	if visible:
		if not warning_sound.playing:
			warning_sound.play()
		if not warning_animation.is_playing():
			warning_animation.play("warning")
	else:
		warning_sound.stop()
		warning_animation.stop()
