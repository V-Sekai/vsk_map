@tool
extends Node3D

class EntityInstance extends Resource:
	@export var parent_id: int
	@export var entity_id: int
	@export var properties_id: int
	@export var transform: Transform3D

@export var map_resources: Array # (Array) = []
@export var entity_instance_list: Array # (Array) = []
@export var entity_instance_properties_list: Array # (Array) = []

@export var database_id: String
@export_enum("VSK_PREVIEW_CAMERA", "VSK_PREVIEW_TEXTURE") var vskeditor_preview_type: int

@export var vskeditor_preview_texture : Texture2D
@export_node_path(Camera3D) var vskeditor_preview_camera_path
@export var vskeditor_pipeline_paths : Array[NodePath]

func _ready():
	if !Engine.is_editor_hint():
		if get_tree() and get_tree().current_scene == self and scene_file_path != "":
			var startup_manager: Node = get_tree().get_root().get_node_or_null("VSKStartupManager")
			if startup_manager:
				get_tree().current_scene = null
				startup_manager.map = get_scene_file_path()
				startup_manager.startup()
				queue_free()
				get_parent().remove_child(self)
