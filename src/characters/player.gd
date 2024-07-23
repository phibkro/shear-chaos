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
	var isMoving = false
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		sprite.flip_h = false
		isMoving = true
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		sprite.flip_h = true
		isMoving = true
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		isMoving = true
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		isMoving = true
	
	if isMoving:
		sprite.play("walk")
	else:
		sprite.play("idle")

	velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_body_entered(body):
	isAlive = false
	sprite.play("death")
	$CollisionShape2D.set_deferred("disabled", true)
	hit.emit()

func start(pos):
	isAlive = true
	position = pos
	$CollisionShape2D.disabled = false
