extends CharacterBody2D

var target
var speed: int = 1000
var bullet_damage: int
var path_name: String = ""


func _physics_process(_delta):
	var path_spawner_node = get_tree().get_root().get_node("Main/PathSpawner")
	for i: int in path_spawner_node.get_child_count():
		if path_spawner_node.get_child(i).name == path_name:
			target = path_spawner_node.get_child(i).get_child(0).get_child(0).global_position
	
	velocity = global_position.direction_to(target) * speed
	
	look_at(target)
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	if "SoldierA" in body.name:
		body.health -= bullet_damage
		queue_free()
