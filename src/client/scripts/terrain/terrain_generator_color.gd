#tool
extends VoxelGeneratorScript

## Colors
const _CHANNEL = VoxelBuffer.CHANNEL_COLOR

## Blocks
var AIR = color_to_16(Color(0.0, 0.0, 0.0, 0.0))
var GRASS = color_to_16(Color(0.0, 1.0, 0.0, .5))

static func clampi(x: int, minv: int, maxv: int) -> int:
	if x < minv:
		return minv
	if x > maxv:
		return maxv
	return x

static func color_to_16(c: Color) -> int:
	return (clampi(int(c.r * 15.0), 0, 15) << 12) | (clampi(int(c.g * 15.0), 0, 15) << 8) | (clampi(int(c.b * 15.0), 0, 15) << 4) | clampi(int(c.a * 15.0), 0, 15)


func _generate_block(buffer: VoxelBuffer, origin_in_voxels: Vector3i, lod: int) -> void:
	# Saves from this demo used 8-bit, which is no longer the default
	buffer.set_channel_depth(_CHANNEL, VoxelBuffer.DEPTH_16_BIT)

	# Assuming input is cubic in our use case (it doesn't have to be!)
	var block_size := int(buffer.get_size().x)
	var oy := int(origin_in_voxels.y)
	# TODO This hardcodes a cubic block size of 16, find a non-ugly way...
	# Dividing is a false friend because of negative values
	var chunk_pos := Vector3(
		int(origin_in_voxels.x) >> 4,
		int(origin_in_voxels.y) >> 4,
		int(origin_in_voxels.z) >> 4)
	
	buffer.fill(AIR if origin_in_voxels.y > 100 else GRASS, _CHANNEL)

	buffer.compress_uniform_channels()
