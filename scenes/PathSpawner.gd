extends Node2D

@onready var path_scene: PackedScene = preload("res://scenes/Mobs/stage_path_1.tscn")


func _on_timer_timeout():
	var path_instance: Path2D = path_scene.instantiate()
	add_child(path_instance)
