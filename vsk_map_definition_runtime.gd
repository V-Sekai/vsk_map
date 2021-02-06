extends Spatial
tool

class EntityInstance extends Resource:
	export(int) var parent_id: int
	export(int) var entity_id: int
	export(int) var properties_id: int
	export(Transform) var transform: Transform

export(Array) var map_resources: Array = []
export(Array) var entity_instance_list: Array = []
export(Array) var entity_instance_properties_list: Array = []

func _ready():
	if !Engine.is_editor_hint():
		if get_tree() and get_tree().current_scene == self and filename != "":
			var startup_manager: Node = get_tree().get_root().get_node_or_null("VSKStartupManager")
			if startup_manager:
				get_tree().current_scene = null
				startup_manager.map = get_filename()
				startup_manager.startup()
				queue_free()
				get_parent().remove_child(self)
