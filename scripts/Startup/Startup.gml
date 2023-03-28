// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.camera_ortho = true;
global.have_camera = false;
global.camdir = 0;
global.camVAngle = 22.50;
global.camHAngle = 337.50;
global.camDistance = 1000;
global.camup = -45;
global.frame = 0
global.rfps = 0;
global.running = false;

global.rax = 0;
global.ray = 0;
global.raz = 0;

global.display_model = true;
global.display_info = false;
global.display_bb = true;
global.display_br = false;
global.display_axis = true;

global.dorot = false;
global.rotctr = 0;
global.rotstep = 1;
global.rotctr = 0;
global.size = 512;
global.rot = 0;
global.fullscreen = false;
global.min_width = 1280;
global.min_height = 720;


global.camera_distance = 0;

global.use_peardox = true;

camera_destroy(camera_get_default());

global.resources = {
    Animations: [], // <- Add Animations struct here
    Materials: [],
    Missing: [],
    Models: [],
    Files: [],
	Sprites: []
};

global.p_string = [];
global.zzautofile = "";
global.autoindex = -1;
global.debug = "";

function get_autofile() {
	var p_num = parameter_count();
	var _ret = "";
	
	var _fn = "";
	if(p_num > 0) {
		if(p_num == 2) {
			if(os_type == os_windows) {
				_fn = parameter_string(1);
			} else {
				_fn = parameter_string(1);
			}
			var _ext = string_lower(filename_ext(_fn));
			if((_ext == ".bbmod")) {
				_ret = _fn;
			}
		}
	}
	return _ret;
}
/*
var _s = "E:\\Dungeon\\*.bbmod";
my_function = external_define("PdxFindFile.dll", "pdx_find_first", dll_stdcall, ty_string, 2, ty_string, ty_real);
global.debug = external_call(my_function, _s, fa_none) + "\n";
external_free("PdxFindFile.dll");
*/