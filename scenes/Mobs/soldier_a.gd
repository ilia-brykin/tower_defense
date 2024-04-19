extends CharacterBody2D

@export var speed: int = 300

var health: int = 10


func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + speed * delta)
	if get_parent().get_progress_ratio() == 1:
		Game.health -= 1
		death()
	
	if health <= 0:
		Game.gold += 1
		death()


func death():
	get_parent().get_parent().queue_free()
