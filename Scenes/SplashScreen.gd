extends Node2D

var game_scene = preload("res://Scenes/Game.tscn").instantiate()

# uncomment to special full-screen browser builds
# I do this in order to get these Godot 4 games working on Raspberry Pi
func _input(event):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _process(_delta):
	if Input.is_action_just_pressed("start"):
		#get_tree().root.add_child(game_scene) # doesn't delete this scene
		#get_tree().change_scene_to_packed(game_scene) # not working
		get_tree().change_scene_to_file("res://Scenes/Game.tscn") # this works
