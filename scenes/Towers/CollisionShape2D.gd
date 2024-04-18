extends CollisionShape2D


func _ready():
	hide()


func _draw():
	var center: Vector2i = Vector2i(0, 0)
	var radius: int = get_parent().get_parent().local_range
	var color: Color = Color(0, 255, 0, 0.3)
	draw_circle(center, radius, color)
