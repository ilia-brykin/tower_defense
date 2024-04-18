extends ProgressBar


func _process(_delta):
	self.max_value = $Timer.wait_time
	self.value = $Timer.time_left
