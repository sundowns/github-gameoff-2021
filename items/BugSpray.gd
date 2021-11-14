extends Item

onready var emitter: Position3D = $Emitter
export(PackedScene) var projectile_scene = preload("res://items/BugSprayProjectile.tscn")

func use():
	print('pew pew')
