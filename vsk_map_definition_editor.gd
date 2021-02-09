extends Control

const vsk_types_const = preload("res://addons/vsk_importer_exporter/vsk_types.gd")
const map_callback_const = preload("map_callback.gd")

var editor_plugin : EditorPlugin = null

var node : Node = null
var options : MenuButton = null
var err_dialog : AcceptDialog = null

var save_dialog : FileDialog = null

const OUTPUT_SCENE_EXTENSION = "scn"

enum {
	MENU_OPTION_EXPORT_MAP
	MENU_OPTION_UPLOAD_MAP
}

func export_map_local() -> void:
	save_dialog.add_filter("*.%s;%s" % [OUTPUT_SCENE_EXTENSION, OUTPUT_SCENE_EXTENSION.to_upper()]);
	
	save_dialog.popup_centered_ratio()
	save_dialog.set_title("Save Map As...")


func get_export_data() -> Dictionary:
	return {
		"root":editor_plugin.get_editor_interface().get_edited_scene_root(),
		"node":node
	}


func export_map_upload() -> void:
	if node and node is Node:
		var export_data_callback: FuncRef = FuncRef.new()
		export_data_callback.set_instance(self)
		export_data_callback.set_function("get_export_data")
		
		VSKEditor.show_upload_panel(export_data_callback, vsk_types_const.UserContentType.Map)
	else:
		printerr("Node is not valid!")
	
func edit(p_node : Node) -> void:
	node = p_node
	
	
func error_callback(p_err: int) -> void:
	if p_err != map_callback_const.MAP_OK:
		var error_string: String = map_callback_const.get_error_string(p_err)
		
		printerr(error_string)
		err_dialog.set_text(error_string)
		err_dialog.popup_centered_minsize()


func check_if_map_is_valid() -> bool:
	if ! node:
		return false
		
	return true


func _menu_option(p_id : int) -> void:
	var err: int = map_callback_const.MAP_OK
	match p_id:
		MENU_OPTION_EXPORT_MAP:
			if check_if_map_is_valid():
				export_map_local()
			else:
				map_callback_const.ROOT_IS_NULL
		MENU_OPTION_UPLOAD_MAP:
			if check_if_map_is_valid():
				export_map_upload()
			else:
				map_callback_const.ROOT_IS_NULL
				
	error_callback(err)

func setup_editor_interface(p_editor_interface : EditorInterface) -> void:
	pass

func _save_file_at_path(p_string : String) -> void:
	VSKExporter.export_map(editor_plugin.get_editor_interface().get_edited_scene_root(),\
	node,\
	p_string)

func _init(p_editor_plugin : EditorPlugin) -> void:
	editor_plugin = p_editor_plugin
	
	err_dialog = AcceptDialog.new()
	add_child(err_dialog)
	
	save_dialog = FileDialog.new()
	save_dialog.mode = FileDialog.MODE_SAVE_FILE
	save_dialog.access = FileDialog.ACCESS_FILESYSTEM
	save_dialog.popup_exclusive = true
	save_dialog.connect("file_selected", self, "_save_file_at_path")
	add_child(save_dialog)
	
	options = MenuButton.new()
	options.set_switch_on_hover(true)
	
	p_editor_plugin.add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, options)
	options.set_text("Map Definition")
	options.get_popup().add_item("Export Map", MENU_OPTION_EXPORT_MAP)
	options.get_popup().add_item("Upload Map", MENU_OPTION_UPLOAD_MAP)
	
	options.get_popup().connect("id_pressed", self, "_menu_option")
	
func _ready():
	pass
