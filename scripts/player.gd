extends RigidBody2D
class_name  Player

@onready var canon: Marker2D = $Canon
@onready var canon_direction: Marker2D = $CanonDirection
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shoot_cooldown_timer: Timer = $ShootCooldownTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_sfx: AudioStreamPlayer = $ShootSFX
@onready var hurt_sfx: AudioStreamPlayer = $HurtSFX
@onready var propulsor_sfx: AudioStreamPlayer = $PropulsorSFX

@export var damage_shake: float = 0.3

@export var rotation_speed: float = 1.0
@export var default_speed: float = 100.0
@export var default_bullet_speed: float = 100.0
@export var bullet_damage: int = 1
@export var default_bullet_range: float = 100.0
@export var bullet_scale: float = 1.0
@export var default_shoot_cooldown: float = 0.3

@export var shoot_sounds: Array[AudioStream]

const BULLET = preload("res://scenes/bullet.tscn")
var speed: float
var shoot_cooldown: float
var bullet_range: float
var bullet_speed: float
var can_shoot = true

func _ready() -> void:
	speed = default_speed
	shoot_cooldown = default_shoot_cooldown
	bullet_range = default_bullet_range
	bullet_speed = default_bullet_speed

func _process(_delta: float) -> void:
	if Global.is_game_over:
		return
	
	var elements = get_colliding_bodies()
	
	for element in elements:
		if element.is_in_group("enemy"):
			element = element as Enemy
			animation_player.play("hurt")
			Global.current_health -= element.damage
			Global.camera.add_trauma(damage_shake)
			element.queue_free()
			
	if Input.is_action_pressed("attack") and can_shoot:
		shoot()
	

func _physics_process(_delta: float) -> void:
	if Global.is_game_over:
		set_propulsor(false)
		return

	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("move"):
		set_propulsor(true)
		apply_force(Vector2.RIGHT.rotated(rotation) * speed)
	else:
		set_propulsor(false)

func set_propulsor(value: bool):
	if value:
		if not propulsor_sfx.playing:
			propulsor_sfx.play()
	else:
		propulsor_sfx.stop()
	
	for element in get_tree().get_nodes_in_group("propulsor"):
		element = element as CPUParticles2D
		element.emitting = value
	

func shoot():
	var sound = shoot_sounds.pick_random()
	shoot_sfx.stream = sound
	shoot_sfx.play()
	can_shoot = false
	shoot_cooldown_timer.wait_time = shoot_cooldown
	shoot_cooldown_timer.start()
	
	var bullet = BULLET.instantiate()
	bullet.speed = bullet_speed
	bullet.position = canon.global_position
	bullet.rotation = rotation + bullet.rotation
	bullet.direction = canon.global_position.direction_to(canon_direction.global_position)
	bullet.damage = bullet_damage
	bullet.attack_range = bullet_range
	bullet.scale = Vector2(bullet_scale, bullet_scale)
	get_tree().current_scene.add_child(bullet)


func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true

func play_hurt_sfx():
	hurt_sfx.play()
	
