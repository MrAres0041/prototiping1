extends Control
class_name MainMenu

@export var test_scene:PackedScene


func _on_test_scene_pressed() -> void:
	get_tree().change_scene_to_packed(test_scene)



func _on_quit_pressed() -> void:
	get_tree().quit()
