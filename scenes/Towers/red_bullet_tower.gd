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


func _on_tower_body_entered(body):
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



func _on_tower_body_exited(_body):
	current_targets = $Tower.get_overlapping_bodies()
