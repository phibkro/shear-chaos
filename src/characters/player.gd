@tool
class_name Player
extends Area2D

signal hit

@export var sprite: AnimatedSprite2D:
	set(new_sprite):
		sprite = new_sprite
		update_configuration_warnings()
@export var death_sprite: AnimatedSprite2D
@export_range(0, 1000) var speed: int = 300
var isAlive = true

@onready var screen_size: Vector2 = get_viewport_rect().size

func _get_configuration_warnings():
	if not sprite:
		return ["Assign a sprite"]
	return []


func _ready():
	sprite.show()
	death_sprite.hide()


func _process(delta):
	if Engine.is_editor_hint():
		return
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


func _on_body_entered(_body):
	isAlive = false
	sprite.hide()
	death_sprite.show()
	death_sprite.play("default")
	$CollisionShape2D.set_deferred("disabled", true)
	hit.emit()


func start(pos):
	sprite.show()
	death_sprite.hide()
	isAlive = true
	position = pos
	$CollisionShape2D.disabled = false
