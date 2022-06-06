extends Label3D

func init(entity: Entity):
	text = str(entity.id)

func get_stable_state(state: Dictionary):
	state['la'] = text

func set_stable_state(state: Dictionary):
	for key in state.keys():
		match key:
			'la':
				text = state['la']
