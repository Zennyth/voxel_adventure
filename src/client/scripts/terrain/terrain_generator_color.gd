#tool
extends VoxelGeneratorScript

const _continentalness_heightmap = preload("res://assets/terrain/generation/heightmap_continentalness.tres")
const _erosion_heightmap = preload("res://assets/terrain/generation/heightmap_erosion.tres")
const _peaks_and_valleys_heightmap = preload("res://assets/terrain/generation/heightmap_peaks_and_valleys.tres")

## Colors
const _CHANNEL = VoxelBuffer.CHANNEL_COLOR

## Blocks
var AIR = 0 #color_to_16(Color(0, 0, 0, 0))
var OCEAN = 1 #color_to_16(Color(0, 0, 255, 0.5))
const BEACH = 2
const SCORCHED = 3
const BARE = 4
const TUNDRA = 5
const SNOW = 6
const TEMPERATE_DESERT = 7
const SHRUBLAND = 8
const TAIGA = 9
var GRASSLAND = 10 #color_to_16(Color(0, 255, 0, 1))
const TEMPERATE_DECIDUOUS_DESERT = 11
const TEMPERATE_RAIN_FOREST = 12
const SUBTROPICAL_DESERT = 13
const TROPICAL_SEASONAL_FOREST = 14

var _offset := 1.5
var _heightmap_min_y := 0
var _heightmap_max_y := 100
var _heightmap_range := _heightmap_max_y - _heightmap_min_y
var _ocean_level := 0

var _continentalness_noise := FastNoiseLite.new()
var _erosion_noise := FastNoiseLite.new()
var _peaks_and_valleys_noise := FastNoiseLite.new()

func get_noise(noise: FastNoiseLite, x: float, y: float) -> float:
	return noise.get_noise_2d(x / _offset, y / _offset) / 2 + .5

func get_height_map(heightmap, noise: FastNoiseLite, x: float, y: float) -> int:
	return int(heightmap.interpolate_baked(get_noise(noise, x, y)) * _heightmap_range)

func _get_height_at(x: int, z: int) -> int:
	# var erosion = get_height_map(_erosion_heightmap, _erosion_noise, x, z)
	var continentalness = get_height_map(_continentalness_heightmap, _continentalness_noise, x, z)
	# var peaks_and_valleys = get_height_map(_peaks_and_valleys_heightmap, _peaks_and_valleys_noise, x, z)
	return continentalness
	# return int((erosion * 0.33 + continentalness * 0.34 + peaks_and_valleys * 0.33))

func get_block(height: int) -> int:
	return GRASSLAND if height > _ocean_level else OCEAN


func _init() -> void:
	_continentalness_noise.seed = randi()
	# _continentalness_noise.octaves = 2
	# _continentalness_noise.period = 128.0
	_continentalness_heightmap.bake()
	
	_erosion_noise.seed = randi()
	# _erosion_noise.octaves = 6
	# _erosion_noise.period = 128.0
	_erosion_heightmap.bake()
	
	_peaks_and_valleys_noise.seed = randi()
	# _peaks_and_valleys_noise.octaves = 4
	# _peaks_and_valleys_noise.period = 128.0
	_peaks_and_valleys_heightmap.bake()


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
	# buffer.set_channel_depth(_CHANNEL, VoxelBuffer.DEPTH_16_BIT)

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
	if origin_in_voxels.y > _heightmap_max_y:
		buffer.fill(AIR, _CHANNEL)
	elif origin_in_voxels.y + block_size < _heightmap_min_y:
		buffer.fill(BARE, _CHANNEL)
	else:
		
		for x in block_size:
			var gx = origin_in_voxels.x + x
			for z in block_size:
				var gz = origin_in_voxels.z + z
				
				var height = _get_height_at(gx, gz)
				var block = get_block(height)
				
				for y in block_size:
					buffer.set_voxel(AIR if y + origin_in_voxels.y > height and y + origin_in_voxels.y > _ocean_level else block, x, y, z, _CHANNEL)

	buffer.compress_uniform_channels()



static func _get_chunk_seed_2d(cpos: Vector3) -> int:
	return int(cpos.x) ^ (31 * int(cpos.z))
