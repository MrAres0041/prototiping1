extends VoxelGeneratorScript
class_name Generator

@export var noise: FastNoiseLite

func _generate_block(out_buffer: VoxelBuffer, origin_in_voxels: Vector3i, lod: int) -> void:
	var size = out_buffer.get_size()

	for z in range(size.z):
		for x in range(size.x):
			for y in range(size.y):
				var wx = origin_in_voxels.x + x
				var wy = origin_in_voxels.y + y
				var wz = origin_in_voxels.z + z

				var h = int(noise.get_noise_2d(wx,wz) * 10.0 + 20.0)   # altura del terreno plano
				var id : int

				if wy < h - 1:
					id = 2  # tierra
				elif wy == h - 1:
					id = 1  # pasto
				else:
					id = 0  # aire

				out_buffer.set_voxel(id, x, y, z, VoxelBuffer.CHANNEL_TYPE)
