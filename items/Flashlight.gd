extends Item

onready var light: SpotLight = $SpotLight
onready var initial_energy_level: float = $SpotLight.light_energy

export var is_on := true

func use():
	is_on = not is_on
	if is_on:
		light.light_energy = initial_energy_level
	else:
		light.light_energy = 0
