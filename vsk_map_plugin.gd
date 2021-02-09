extends EditorPlugin
tool

const map_definition_editor_const = preload("vsk_map_definition_editor.gd")
const map_definition_const = preload("vsk_map_definition.gd")

var editor_interface : EditorInterface = null
var map_definition_editor : Control = null


func _init() -> void:
	print("Initialising VSKMap plugin")


func _notification(p_notification: int):
	match p_notification:
		NOTIFICATION_PREDELETE:
			print("Destroying VSKMap plugin")


func get_name() -> String:
	return "VSKMap"


func _enter_tree() -> void:
	editor_interface = get_editor_interface()
	map_definition_editor = map_definition_editor_const.new(self)
	
	editor_interface.get_editor_viewport().add_child(map_definition_editor)
	
	map_definition_editor.options.hide()

func _exit_tree() -> void:
	map_definition_editor.queue_free()

func edit(p_object : Object) -> void:
	if p_object is Node and p_object.get_script() == map_definition_const:
		map_definition_editor.edit(p_object)

func handles(p_object : Object) -> bool:
	if p_object.get_script() == map_definition_const:
		return true
	else:
		return false

func make_visible(p_visible : bool) -> void:
	if (p_visible):
		if map_definition_editor:
			if map_definition_editor.options:
				map_definition_editor.options.show()
	else:
		if map_definition_editor:
			if map_definition_editor.options:
				map_definition_editor.options.hide()
			map_definition_editor.edit(null)
