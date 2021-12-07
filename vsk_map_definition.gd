@tool
extends "res://addons/vsk_map/vsk_map_definition_runtime.gd"

const vsk_user_content_definition_helper_const = preload("res://addons/vsk_importer_exporter/vsk_user_content_definition_helper.gd")

var database_id: String = "" # For backwards compatibility

var editor_properties: RefCounted # vsk_user_content_definition_helper_const.VSKEditorProperties

func add_pipeline(p_node: Node) -> void:
	editor_properties.vskeditor_pipeline_paths.push_back(get_path_to(p_node))
	
func remove_pipeline(p_node: Node) -> void:
	editor_properties.vskeditor_pipeline_paths.erase(get_path_to(p_node))

func _get(p_property):
	return vsk_user_content_definition_helper_const.common_get(self, p_property)

func _set(p_property, p_value) -> bool:
	return vsk_user_content_definition_helper_const.common_set(self, p_property, p_value)

# Backwards compatibility
func _get_property_list():
	# FIXME: editor_properties.vskeditor_preview_type)
	var properties: Array = vsk_user_content_definition_helper_const.get_common_property_list("Camera")
	return properties

func _init():
	if !editor_properties:
		editor_properties = vsk_user_content_definition_helper_const.VSKEditorProperties.new()
