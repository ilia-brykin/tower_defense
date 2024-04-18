extends Panel

var current_tile

@onready var tower: PackedScene = preload("res://scenes/Towers/red_bullet_tower.tscn")


func _on_gui_input(event):
	var tower_instance: StaticBody2D = tower.instantiate()
	if event is InputEventMouseButton and event.button_mask == 1: # left click down
		add_child(tower_instance)
		tower_instance.process_mode = Node.PROCESS_MODE_DISABLED
		tower_instance.scale = Vector2(0.5, 0.5)
	elif event is InputEventMouseMotion and event.button_mask == 1: # left click down drag
		if get_child_count() > 1:
			get_child(1).global_position = event.global_position
	elif event is InputEventMouseButton and event.button_mask == 0: # mouse click up
		var drop_position: Vector2 = get_tree().get_root().get_node("Main").get_global_mouse_position()
		if drop_position.x < 5808:
			add_new_tower(tower_instance, drop_position)
		delete_second_child()
	else:
		delete_second_child()


func delete_second_child():
	if get_child_count() > 1:
		get_child(1).queue_free()


func add_new_tower(tower_instance: StaticBody2D, drop_position: Vector2) -> void:
	var towers_node: Node2D = get_tree().get_root().get_node("Main/Towers")
	tower_instance.global_position = drop_position
	towers_node.add_child(tower_instance)
	tower_instance.get_node("Area").hide()
