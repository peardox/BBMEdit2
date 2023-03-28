/// @description Insert description here
// You can write your code in this editor
rn = 0;
animIdx = 0;
modelCount = 0;
global.zzautofile = get_autofile();

if(global.zzautofile != "") {
	var sp = filename_path(global.zzautofile);
	modelCount = load_models_from(sp);
//	modelCount = load_models_from("E:\\Dungeon\\");
}
model = undefined;	

oCam = instance_create_layer(0, 0, layer, oCamera);
tx = 0;
ty = 0;
tz = 0;
if(modelCount > 0) {
	if(global.autoindex == -1) {
		var _idx = 0;// irandom(modelCount) - 1;
		model = global.resources.Models[_idx];
	} else {
		model = global.resources.Models[global.autoindex];
	}
} else if(global.zzautofile == "") {
	//	model = new PDX_Model("Character/Character.bbmod", true, false, 0, 0, 0, 1, { Size: { X: 3.62, Y: 1.05, Z: 3.76} });
	//	animIdx = 2;
	//	model = new PDX_Model("licensed/cat/Cat_Chubby.bbmod", true, false, 180, 270, 90);
	//	animIdx = 5;
	//	model = new PDX_Model("Boy/Boy.bbmod", true, false, 0, 0, 90);
	//	animIdx = 7;
	//	model = new PDX_Model("bloke/bloke.bbmod", true, false, 270, 0, 90);
	//	animIdx = 6;
//	model = new PDX_Model("licensed/Zerin/RetroMedievalKit/wall_detail.bbmod", false, true);
	// model = new PDX_Model("C:\\src\\BBEdit\\datafiles\\kaykit\\Dungeon\\banner_green.bbmod");
	//	model.Gimbal.Rotation.Y = 180;
	//	model = new PDX_Model("cube/hexa123-in-air.bbmod");
	//	model = new PDX_Model("cube/hexa123-in-air.bbmod", false, false, 270, 270, 180);

	//  model = new PDX_Model("cube/hexa123-ground.bbmod", false, false, 270, 270, 0);
	//	model = new PDX_Model("cube/hexa123.bbmod", false, false, 270, 180, 0);
	//	model = new PDX_Model("cube/cube-z-x-view.bbmod", false, false, 270, 180, 0);
	//	model = new PDX_Model("cube/defcube.bbmod", false, false, 0, 0, 0);
	//	model = new PDX_Model("cube/cube.bbmod", false, false, 270, 270, 0);

	// bbox = new PDX_Model("bbox.bbmod");
	if(is_undefined(model)) {
		model = new PDX_Model("cube/castle.bbmod");
	}
} else {
	if(file_exists(global.zzautofile)) {
		model = new PDX_Model(global.zzautofile);
	} else {
		model = new PDX_Model("cube/castle.bbmod");
	}
}
global.running = true;
