extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction: Vector2 # Direction of the player

# State
var is_shooting = false

# Animation var
var flipH = false
var anim_name: String = "idle"

func _physics_process(_delta: float) -> void:
	# Movement
	var vy = Input.get_axis("move_up", "move_down")
	var vx = Input.get_axis("move_left", "move_right")
	var iv = Vector2(vx, vy).normalized()
	direction = iv
	self.velocity = iv * SPEED
	move_and_slide()
	
	# Animation
	if direction != Vector2.ZERO:
		anim_name = "walk"
	elif is_shooting:
		anim_name = "shoot_arrow"
	else:
		anim_name = "idle"
	sprite.play(anim_name)
	if direction.x < 0:
		flipH = true
	else:
		flipH = false
	sprite.set_flip_h(flipH)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart_scene"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("fire"):
		is_shooting = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_name == "shoot_arrow":
		is_shooting = false
	pass # Replace with function body.
