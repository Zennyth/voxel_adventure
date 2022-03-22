extends VoxelTerrain

var serializer: VoxelBlockSerializer = VoxelBlockSerializer.new() 
var buffer: StreamPeerBuffer = StreamPeerBuffer.new()

func _on_data_block_entered(info: VoxelDataBlockEnterInfo) -> void:
	var size: int = serializer.serialize(buffer, info.get_voxels(), true)
	
	get_parent().send_chunk(info.get_network_peer_id(), buffer, size, info.get_position())
	buffer.clear()
