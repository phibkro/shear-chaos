@tool
extends Node

@export var player: Player:
	set(v):
		player = v
		update_configuration_warnings()
@export var mob_scene: PackedScene:
	set(v):
		mob_scene = v
		update_configuration_warnings()
@export var sfx_game_over: AudioStreamPlayer:
	set(v):
		sfx_game_over = v
		update_configuration_warnings()
@export var background_music: AudioStreamPlayer:
	set(v):
		background_music = v
		update_configuration_warnings()
var score: int

func _get_configuration_warnings():
	var warnings = []
	if not player:
		warnings.append("Assign missing Player")
	if not mob_scene:
		warnings.append("Assign missing mob scene")
	if not sfx_game_over:
		warnings.append("Assign missing game over sound")
	return warnings

func new_game():
	# Reset
	score = 0
	player.start($StartPosition.position)
	get_tree().call_group("mobs", "queue_free")
	$StartTimer.start()
	background_music.play()
	
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
	background_music.stop()
	sfx_game_over.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
