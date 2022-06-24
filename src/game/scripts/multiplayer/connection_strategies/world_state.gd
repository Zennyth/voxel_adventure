extends Node
class_name WorldState

###
# BUILT-IN
###

var entity_manager: EntityManager
var clock_synchronizer: ClockSynchronizer

func init(manager: EntityManager, clock: ClockSynchronizer):
	entity_manager = manager
	clock_synchronizer = clock

const STATE_KEYS = {
	TIME = 't',
	ENTITIES = 'e',
	
	ID = 'id',
	SCENE = 's',
	POSITION = 'p',
	ROTATION = 'r',
	
	LABEL = 'la',
    BINDALBE_SLOT = 'bs'
}


###
# DOC
# WorldState manages the world state of all synchronizable entities
###
