extends Panel

var current_tile: Vector2i
var grass_tile: Vector2i = Vector2i(4, 5)

@onready var tower: PackedScene = preload("res://scenes/Towers/red_bullet_tower.tscn")


func _on_gui_input(event) -> void:
	if Game.gold < 10:
		return
		
	var tower_instance: StaticBody2D = tower.instantiate()
	if event is InputEventMouseButton and event.button_mask == 1: # left click down
		add_child(tower_instance)
		tower_instance.process_mode = Node.PROCESS_MODE_DISABLED
		tower_instance.scale = Vector2(0.5, 0.5)
	elif event is InputEventMouseMotion and event.button_mask == 1: # left click down drag
		if get_child_count() > 1:
			get_child(1).global_position = event.global_position
			
			current_tile = get_current_tile()
			change_area_for_tower()
			
	elif event is InputEventMouseButton and event.button_mask == 0: # mouse click up
		var drop_position: Vector2 = get_mouse_position()
		if drop_position.x < 5808:
			add_new_tower(tower_instance, drop_position)
		delete_second_child()
	else:
		delete_second_child()


func delete_second_child() -> void:
	if get_child_count() > 1:
		get_child(1).queue_free()


func get_mouse_position() -> Vector2:
	return get_tree().get_root().get_node("Main").get_global_mouse_position()


func add_new_tower(tower_instance: StaticBody2D, drop_position: Vector2) -> void:
	if current_tile == grass_tile:
		var targets: Array = get_child(1).get_node("TowerDetector").get_overlapping_bodies() # TODO: not working
		if targets.size() == 0:
			var towers_node: Node2D = get_tree().get_root().get_node("Main/Towers")
			tower_instance.global_position = drop_position
			towers_node.add_child(tower_instance)
			tower_instance.get_node("Area").hide()
			Game.gold -= 10


func get_current_tile() -> Vector2i:
	var tile_map_node: TileMap = get_tree().get_root().get_node("Main/TileMap")
	var tile: Vector2i = tile_map_node.local_to_map(get_mouse_position())
	return tile_map_node.get_cell_atlas_coords(0, tile, false)


func change_area_for_tower() -> void:
	var targets: Array = get_child(1).get_node("TowerDetector").get_overlapping_bodies() # TODO: not working
	
	if current_tile == grass_tile and targets.size() == 0:
		get_child(1).get_node("Area").modulate = Color(0, 255, 0, 0.3)
	else:
		get_child(1).get_node("Area").modulate = Color(255, 255, 255, 0.3)
