#tool
extends VoxelGeneratorScript

## Channel
const _CHANNEL = VoxelBuffer.CHANNEL_COLOR

## Blocks
var AIR = 0
var WATER = 1
var GRASS = 2
var SNOW = 3

## terrain constraints
const _heightmap_min_y := 0
const _heightmap_max_y := 500
const _heightmap_range := _heightmap_max_y - _heightmap_min_y
const _ocean_level := 100
const _snow_level := 200

## Noises
var _elevation_noise := FastNoiseLite.new()
var _moisture_noise := FastNoiseLite.new()
const _offset := 16

func get_noise(noise: FastNoiseLite, x: float, y: float) -> float:
	return noise.get_noise_2d(x / _offset, y / _offset) / 2 + .5

func get_block(e: float, m: float) -> int:
	return GRASS if e < _snow_level else SNOW

func _init():
	_elevation_noise.seed = 100001
	_elevation_noise.fractal_octaves = 6
	
	_moisture_noise.seed = 011110
	_moisture_noise.fractal_octaves = 6

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
	
	if origin_in_voxels.y > _heightmap_max_y:
		buffer.fill(AIR, _CHANNEL)
	elif origin_in_voxels.y + block_size < _heightmap_min_y:
		buffer.fill(GRASS, _CHANNEL)
	else:
		for x in block_size:
			var gx = origin_in_voxels.x + x
			for z in block_size:
				var gz = origin_in_voxels.z + z
				
				var nx = gx
				var ny = gz
				
				var e = pow(get_noise(_elevation_noise, nx, ny), 2) * _heightmap_range
				var m = get_noise(_moisture_noise, nx, ny)
				
				var block = get_block(e, m)
				
				for y in block_size:
					var y_block = AIR if y + origin_in_voxels.y > e else block
					y_block = WATER if y + origin_in_voxels.y < _ocean_level else y_block
					buffer.set_voxel(y_block, x, y, z, _CHANNEL)

	buffer.compress_uniform_channels()
