extends Node

@export var mob_scene: PackedScene
@export var sfx_game_over: AudioStreamPlayer
var score: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func new_game():
	# Reset
	score = 0
	$Player.start($StartPosition.position)
	get_tree().call_group("mobs", "queue_free")
	$StartTimer.start()
	
	# Update hud
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout():
	score += 1
	
	$HUD.update_score(score)

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func game_over():
	sfx_game_over.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
