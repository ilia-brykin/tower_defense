extends Label


func _process(_delta):
	self.text = "Health: " + str(Game.health)
