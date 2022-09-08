extends ClockSynchronizer

var decimal_collector: float = 0
var latency_array = []
var latency = 0
var delta_latency = 0
var client_clock = 0

func _physics_process(delta: float) -> void:
	client_clock += int(delta * 1000) + delta_latency
	delta_latency = 0
	decimal_collector += (delta * 1000) - int(delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00

func calc_client_clock(server_time: int, client_time: int):
	latency = (get_unit() - client_time) / 2
	client_clock = server_time + latency

func determine_latency(client_time: int):
	latency_array.append((get_unit() - client_time) / 2)
	if latency_array.size() == 9:
		var total_latency = 0
		latency_array.sort()
		var mid_point = latency_array[4]
		for i in range(latency_array.size() - 1, -1, -1):
			if latency_array[i] > (2 * mid_point) and latency_array[i] > 20:
				latency_array.remove_at(i)
			else:
				total_latency += latency_array[i]
		delta_latency = ( total_latency / latency_array.size()) - latency
		latency = total_latency / latency_array.size()
		Debug.update_debug_property(DebugProperty.DebugPropertyKey.LATENCY_NETWORK, latency)
		Debug.update_debug_property(DebugProperty.DebugPropertyKey.DELTA_LATENCY_NETWORK, delta_latency)
		latency_array.clear()
