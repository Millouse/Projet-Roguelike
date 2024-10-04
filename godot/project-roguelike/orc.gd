extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shape_body: CollisionShape2D = $CollisionShape2D

var anim_death = false

# Stats
var hp = 50

func _ready() -> void:
	EventBus.arrow_hit.connect(_on_signal_arrow_hit)

func _physics_process(delta: float) -> void:
	if hp <= 0 and not anim_death:
		anim_death = true
		sprite.play("die")
		await get_tree().create_timer(5).timeout
		call_deferred("free")
	if hp > 0:
		sprite.play("idle")
	pass
	
func _on_signal_arrow_hit():
	hp -= 10
	print(hp)
