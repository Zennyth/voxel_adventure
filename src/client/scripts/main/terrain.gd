extends VoxelTerrain

var serializer: VoxelBlockSerializer = VoxelBlockSerializer.new() 
var voxels: VoxelBuffer = VoxelBuffer.new()

func sync_chunk(buffer: StreamPeerBuffer, size: int, voxels_position: Vector3i):
	serializer.deserialize(buffer, voxels, size, true)
	
	try_set_block_data(voxels_position, voxels)
