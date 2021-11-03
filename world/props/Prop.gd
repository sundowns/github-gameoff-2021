extends StaticBody

export(Vector3) var fixed_rotation_degrees = Vector3(-10, 0, 0)

func _ready():
	rotation_degrees = fixed_rotation_degrees
