extends Node


enum {
	MAP_OK,
	MAP_FAILED,
	ROOT_IS_NULL,
}

static func get_error_string(p_err: int) -> String:
	var error_string: String = "Unknown error!"
	match p_err:
		MAP_FAILED:
			error_string = "Generic map error! (complain to Saracen)"
		ROOT_IS_NULL:
			error_string = "Root node is null!"
	
	return error_string
