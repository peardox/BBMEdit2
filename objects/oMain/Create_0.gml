/// @description Insert description here
// You can write your code in this editor
global.tabs = [0];
function add_local_models(_local_dir) {
	var _mc = array_length(global.resources.Models);
	var _ld = scan_subdirs(_local_dir);
	if(array_length(_ld) > 0) {
		for(var _i = 0; _i < array_length(_ld); _i++) {
			var _ld2 = scan_subdirs(_ld[_i]);
			if(array_length(_ld2) > 0) {
				for(var _j = 0; _j < array_length(_ld2); _j++) {
					_mc += load_models_from(_ld2[_j]);
					global.tabs[array_length(global.tabs)] = _mc;
				}
			}
		}
	}
	array_resize(global.tabs,array_length(global.tabs)-1);

	return _mc;
}

rn = 0;
animIdx = 0;
modelCount = 0;
modelIndex = 0; // 382; // 0;

global.resources.Models[modelCount++] = new PDX_Model("cube/notflag.bbmod");
global.resources.Models[modelCount++] = new PDX_Model("cube/notflagrot.bbmod");
global.resources.Models[modelCount++] = new PDX_Model("cube/flagCheckers.bbmod");
global.resources.Models[modelCount++] = new PDX_Model("bloke/bloke.bbmod", false, true);

global.autofile = get_autofile();

if(global.autofile != "") {
	var sp = filename_path(global.autofile);
	load_models_from(sp, global.autofile);
}

	
if(os_type == os_gxgames) {
	var _fl = load_json("localModels.json");
	if(is_array(_fl)) {
		var _mc = array_length(_fl);
		global.resources.Models = array_create(_mc, undefined);
		
		for(var _i = 0; _i < _mc; _i++) {
			global.resources.Models[_i] = new PDX_Model(_fl[_i]);
		}
	}
} else {
	add_local_models("free");
	add_local_models("licensed");
}
modelCount = array_length(global.resources.Models);
model = undefined;	

oCam = instance_create_layer(0, 0, layer, oCamera);
tx = 0;
ty = 0;
tz = 0;
rx = 0;
ry = 0;
rz = 0;

if(modelCount == 0) {
	global.resources.Models[modelCount] = new PDX_Model("cube/castle.bbmod");
	modelCount = array_length(global.resources.Models);
}
model = global.resources.Models[modelIndex];
#macro ActiveModel global.resources.Models[modelIndex]

global.running = true;
