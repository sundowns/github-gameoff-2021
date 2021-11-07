extends Item

onready var light: SpotLight = $SpotLight
onready var sprite: Sprite3D = $Sprite3D
onready var initial_energy_level: float = $SpotLight.light_energy

export var is_on := true

func _ready():
	if is_on:
		sprite.frame = 1
	else:
		sprite.frame = 0

func use():
	is_on = not is_on
	if is_on:
		sprite.frame = 1
		light.light_energy = initial_energy_level
	else:
		sprite.frame = 0
		light.light_energy = 0
