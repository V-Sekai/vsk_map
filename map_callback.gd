@tool
extends Node

const MAP_OK=0
const MAP_FAILED=1
const ROOT_IS_NULL=2
const EXPORTER_NODE_LOADED=3


static func get_error_str(p_err: int) -> String:
	var error_str: String = "Unknown error!"
	match p_err:
		MAP_FAILED:
			error_str = "Generic map error! (complain to Saracen)"
		ROOT_IS_NULL:
			error_str = "Root node is null!"
			
		EXPORTER_NODE_LOADED:
			error_str = "Exporter not loaded!"
	
	return error_str
