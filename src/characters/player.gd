extends Area2D

signal hit
@export var sprite: AnimatedSprite2D
@export var speed := 300
var isAlive = true

var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not isAlive:
		return
	
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		sprite.flip_h = true
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		sprite.play("walk")
	else:
		sprite.play("idle")
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_body_entered(body):
	isAlive = false
	sprite.play("death")
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	isAlive = true
	position = pos
	$CollisionShape2D.disabled = false
