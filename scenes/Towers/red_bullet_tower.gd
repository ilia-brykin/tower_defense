extends StaticBody2D

var bullet: PackedScene = preload("res://scenes/Towers/red_bullet.tscn")

var bullet_damage: int = 5
var path_name
var current_targets: Array = []
var current


func _process(_delta):
	if is_instance_valid(current):
		self.look_at(current.global_position)
	else:
		for i: int in $BulletContainer.get_child_count():
			$BulletContainer.get_child(i).queue_free()


func _on_tower_body_entered(body) -> void:
	if "SoldierA" in body.name:
		var temp_array: Array = []
		current_targets = $Tower.get_overlapping_bodies()
		for item in current_targets:
			if "SoldierA" in item.name:
				temp_array.append(item)
		
		var current_target = null
		for i in temp_array:
			if current_target == null:
				current_target = i.get_node("../")
			else:
				if i.get_parent().get_progress() > current_target.get_progress():
					current_target = i.get_node("../")
		
		current = current_target
		path_name = current_target.get_parent().name
		
		var bullet_instance: CharacterBody2D = bullet.instantiate()
		bullet_instance.path_name = path_name
		bullet_instance.bullet_damage = bullet_damage
		$BulletContainer.add_child(bullet_instance)
		bullet_instance.global_position = $Aim.global_position



func _on_tower_body_exited(_body) -> void:
	current_targets = $Tower.get_overlapping_bodies()


func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.button_mask == 1: # left click down
		var towers_node: Node2D = get_tree().get_root().get_node("Main/Towers")
		for child: StaticBody2D in towers_node.get_children():
			if child.name != self.name:
				child.get_node("Upgrade/UpgradePanel").hide()
		$Upgrade/UpgradePanel.visible = !$Upgrade/UpgradePanel.visible
		$Upgrade/UpgradePanel.global_position = self.position + Vector2(-572, 81)
