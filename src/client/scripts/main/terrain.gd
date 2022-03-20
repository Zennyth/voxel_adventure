extends VoxelTerrain

var serializer: VoxelBlockSerializer = VoxelBlockSerializer.new() 
var buffer: StreamPeerBuffer = StreamPeerBuffer.new()

func sync_chunk(data_array: PackedByteArray, size: int, voxels_position: Vector3i):
	var voxels: VoxelBuffer = VoxelBuffer.new()
	buffer.set_data_array(data_array)
	serializer.deserialize(buffer, voxels, size, true)
	
	try_set_block_data(voxels_position, voxels)
