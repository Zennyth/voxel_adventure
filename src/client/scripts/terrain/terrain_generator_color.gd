#tool
extends VoxelGeneratorScript

const Structure = preload("./structure.gd")
const TreeGenerator = preload("./tree_generator.gd")
const HeightmapCurve = preload("res://assets/terrain/heightmap_curve.tres")

## Colors
const _CHANNEL = VoxelBuffer.CHANNEL_COLOR

const _moore_dirs = [
	Vector3(-1, 0, -1),
	Vector3(0, 0, -1),
	Vector3(1, 0, -1),
	Vector3(-1, 0, 0),
	Vector3(1, 0, 0),
	Vector3(-1, 0, 1),
	Vector3(0, 0, 1),
	Vector3(1, 0, 1)
]

var _heightmap_min_y := int(HeightmapCurve.min_value)
var _heightmap_max_y := int(HeightmapCurve.max_value)
var _heightmap_range := 0
var _heightmap_noise := FastNoiseLite.new()

var _frequency := .1
var _amplitude := 10


func _init() -> void:

	_heightmap_noise.seed = 131131
	_heightmap_noise.period = 128
	_heightmap_noise.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC  
	# _heightmap_noise.octaves = 4

	# IMPORTANT
	# If we don't do this `Curve` could bake itself when interpolated,
	# and this causes crashes when used in multiple threads
	HeightmapCurve.bake()


func _get_used_channels_mask() -> int:
	return 1 << _CHANNEL


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
	buffer.set_channel_depth(_CHANNEL, VoxelBuffer.DEPTH_8_BIT)

	# Assuming input is cubic in our use case (it doesn't have to be!)
	var block_size := int(buffer.get_size().x)
	var oy := int(origin_in_voxels.y)
	# TODO This hardcodes a cubic block size of 16, find a non-ugly way...
	# Dividing is a false friend because of negative values
	var chunk_pos := Vector3(
		int(origin_in_voxels.x) >> 4,
		int(origin_in_voxels.y) >> 4,
		int(origin_in_voxels.z) >> 4)

	_heightmap_range = _heightmap_max_y - _heightmap_min_y

	# Ground
#	if origin_in_voxels.y > _heightmap_max_y:
#		buffer.fill(0, _CHANNEL)
#	elif origin_in_voxels.y + block_size < _heightmap_min_y:
#		buffer.fill(1, _CHANNEL)
		
	for x in block_size:
		var gx = origin_in_voxels.x + x
		for z in block_size:
			var gz = origin_in_voxels.z + z
#			var x_offset = sin(gx * _frequency) * _amplitude
#			var z_offset = sin(gz * _frequency) * _amplitude
			var surface_y = _heightmap_min_y + _heightmap_noise.get_noise_2d(gx, gz) * _amplitude
			for y in block_size:
				buffer.set_voxel(1 if origin_in_voxels.y + y < surface_y else 0, x, y, z, _CHANNEL)

	buffer.compress_uniform_channels()





static func _get_chunk_seed_2d(cpos: Vector3) -> int:
	return int(cpos.x) ^ (31 * int(cpos.z))


func _get_height_at(x: int, z: int) -> int:
	var t = 0.5 + 0.5 * _heightmap_noise.get_noise_2d(x, z)
	return int(HeightmapCurve.interpolate_baked(t))
