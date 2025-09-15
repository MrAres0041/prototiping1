extends VoxelGeneratorScript

func _generate_block(out_buffer: VoxelBuffer, origin_in_voxels: Vector3i, lod: int) -> void:
	for z in out_buffer.get_size().z:
		for x in out_buffer.get_size().x:
			for y in out_buffer.get_size().y:
				var wx = origin_in_voxels.x + x
				#var wy = origin_in_voxels.y + y
				var wy = y + 10
				var wz = origin_in_voxels.z + z
				
				print("origin y:", origin_in_voxels.y, " local y:", y, " -> wy:", wy)


				# Altura del terreno base (plano en y=10)
				var h = 10
				var id : int

				if wy < h - 1:
					id = 2 # tierra
					#print("Y printed: ", wy)
				elif wy == h - 1:
					id = 1 # pasto
					#print("Y printed: ", wy)
				else:
					id = 0 # aire
					#print("Y printed: ", wy)

				out_buffer.set_voxel(id, x, y, z, VoxelBuffer.CHANNEL_TYPE)
				print("set voxel at", Vector3(wx, wy, wz), "->", id)
