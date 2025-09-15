extends Node3D

@export var size:float = 16.0
@export_range(-1,1) var cut_off:float = 0.5

@onready var def_cube: CSGBox3D = $CSGBox3D
@onready var world_size:Vector3 = Vector3(size,size,size)


func _ready() -> void:
	var rng = FastNoiseLite.new()
	
	for x in range(world_size.x):
		for z in range(world_size.z):
			for y in range(world_size.y):
				var random = rng.get_noise_3d(x,y,z)
				if random > cut_off:
					var new_cube = def_cube.duplicate()
					new_cube.position = Vector3(x,y,z)
					add_child(new_cube)
	remove_child(def_cube)
