extends StaticBody2D

var bullet: PackedScene = preload("res://scenes/Towers/red_bullet.tscn")

var bullet_damage: int = 5
var path_name
var current_targets: Array = []
var current

var reload: float = 0
var local_range: int = 400
var start_shooting: bool = false

@onready var timer: Timer = $Upgrade/ProgressBar/Timer


func _process(_delta):
	$Upgrade/ProgressBar.global_position = self.position + Vector2(-64, -81)
	if is_instance_valid(current):
		self.look_at(current.global_position)
		if timer.is_stopped():
			timer.start()
	else:
		for i: int in $BulletContainer.get_child_count():
			$BulletContainer.get_child(i).queue_free()
	update_powers()


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


func shoot():
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


func _on_timer_timeout() -> void:
	shoot()


func _on_range_pressed() -> void:
	local_range += 30


func _on_atack_speed_pressed() -> void:
	if reload <= 2:
		reload += 0.1
	timer.wait_time = 3 - reload


func _on_power_pressed() -> void:
	bullet_damage += 1


func update_powers():
	$Upgrade/UpgradePanel/HBoxContainer/Range/Label.text = str(local_range)
	$Upgrade/UpgradePanel/HBoxContainer/AtackSpeed/Label.text = str(3 - reload)
	$Upgrade/UpgradePanel/HBoxContainer/Power/Label.text = str(bullet_damage)
	$Tower/CollisionShape2D.shape.radius = local_range


func _on_range_mouse_entered():
	$Tower/CollisionShape2D.show()


func _on_range_mouse_exited():
	$Tower/CollisionShape2D.hide()
