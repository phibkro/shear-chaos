extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("walk")

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
