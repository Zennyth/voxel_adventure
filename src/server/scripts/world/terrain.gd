extends VoxelTerrain

var serializer: VoxelBlockSerializer = VoxelBlockSerializer.new() 
var buffer: StreamPeerBuffer = StreamPeerBuffer.new()

func _ready():
	print("terrain listener is ready !")
	pass

func _on_data_block_enter(info: VoxelDataBlockEnterInfo):
	var player_id: int = info.get_network_peer_id()
	print(player_id)
	if player_id != -1:
		var size: int = serializer.serialize(buffer, info.get_voxels(), true)
		var voxels_position: Vector3i = info.get_position()
		
		get_parent().send_chunk(player_id, buffer, size, voxels_position)
