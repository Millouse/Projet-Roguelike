extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Scene
var arrow = preload("res://arrow.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction: Vector2 # Direction of the player

# State
var is_shooting = false
var is_dashing = false

# Animation var
var flipH = false
var anim_name: String = "idle"

#func _ready() -> void:
	#animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))

func _physics_process(_delta: float) -> void:
	# Movement
	var vy = Input.get_axis("move_up", "move_down")
	var vx = Input.get_axis("move_left", "move_right")
	var iv = Vector2(vx, vy).normalized()
	direction = iv
	self.velocity = iv * SPEED
	move_and_slide()
	
	# Animation
	var mousePos = get_global_mouse_position().normalized()
	if direction.x < 0:
		flipH = true
	elif direction.x > 0:
		flipH = false
	if is_shooting:
		# Turn animation if aim behind the player
		if position.normalized().x - mousePos.normalized().x > 0:
			flipH = true
		else:
			flipH = false
	sprite.set_flip_h(flipH)
	if is_shooting:
		anim_name = "shoot_arrow"
	elif is_dashing:
		anim_name = "dash"
	elif direction != Vector2.ZERO:
		anim_name = "walk"
	else:
		anim_name = "idle"
	sprite.play(anim_name)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart_scene"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("fire"):
		if is_shooting == false:
			is_shooting = true
			await get_tree().create_timer(0.5).timeout
			shoot_arrow()
		
	if Input.is_action_just_pressed("dash"):
		is_dashing = true
		


func _on_animated_sprite_2d_animation_finished() -> void:
	print(anim_name)
	if anim_name == "shoot_arrow":
		is_shooting = false
	if anim_name == "dash":
		is_dashing = false

func shoot_arrow() -> void:
	# Instanciate one arrow
	var arrow_scene = arrow.instantiate()
	arrow_scene.position = self.position
	arrow_scene.direction_arrow = (position - get_global_mouse_position()).normalized()
	# Rotate toward mouse
	arrow_scene.look_at(get_global_mouse_position())
	get_parent().add_child(arrow_scene)
