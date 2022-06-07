@tool
extends EditorPlugin

const map_definition_editor_const = preload("./vsk_map_definition_editor.gd")
const map_definition_const = preload("./vsk_map_definition.gd")

var editor_interface : EditorInterface = null
var map_definition_editor : Control = null

var option_button: MenuButton = null

func _init():
	print("Initialising VSKMap plugin")

func _notification(p_notification: int):
	match p_notification:
		NOTIFICATION_PREDELETE:
			print("Destroying VSKMap plugin")

func _get_plugin_name() -> String:
	return "VSKMap"

func _menu_option(p_id : int) -> void:
	if map_definition_editor:
		map_definition_editor._menu_option(p_id)

func update_menu_options() -> void:
	if option_button:
		option_button.get_popup().clear()
		option_button.get_popup().add_item("Define Map", map_definition_editor_const.MENU_OPTION_INIT_MAP)
		option_button.get_popup().add_item("Export Map", map_definition_editor_const.MENU_OPTION_EXPORT_MAP)
		option_button.get_popup().add_item("Upload Map", map_definition_editor_const.MENU_OPTION_UPLOAD_MAP)

func _enter_tree() -> void:
	editor_interface = get_editor_interface()
	map_definition_editor = map_definition_editor_const.new(self)
	
	editor_interface.get_viewport().call_deferred("add_child", map_definition_editor, true)
	
	option_button = MenuButton.new()
	option_button.set_switch_on_hover(true)
	
	option_button.set_text("Map Definition")
	
	option_button.get_popup().id_pressed.connect(self._menu_option)
	option_button.hide()
	
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, option_button)

func _exit_tree() -> void:
	if option_button:
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, option_button)
		if option_button.is_inside_tree():
			option_button.get_parent().remove_child(option_button)
		option_button.queue_free()
	
	if map_definition_editor:
		if map_definition_editor.is_inside_tree():
			map_definition_editor.get_parent().remove_child(map_definition_editor)
		map_definition_editor.queue_free()

func _edit(p_object : Variant) -> void:
	map_definition_editor.edit(p_object)
	update_menu_options()

func _handles(p_object : Variant) -> bool:
	if not p_object is Node3D:
		return false
	return true

func _make_visible(p_visible : bool) -> void:
	if not map_definition_editor:
		return
	if (p_visible):
		if option_button:
			option_button.show()
	else:
		if option_button:
			option_button.hide()
		map_definition_editor.edit(null)
