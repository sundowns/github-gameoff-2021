extends OmniLight

var initial_energy := 0.0
var is_active := false
export(float) var start_on := false

func _ready():
	initial_energy = light_energy
	if not start_on:
		light_energy = 0
	is_active = light_energy > 0

func toggle():
	if is_active:
		light_energy = 0
	else:
		light_energy = initial_energy
	is_active = not is_active
