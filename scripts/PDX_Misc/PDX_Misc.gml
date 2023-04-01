// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function get_hypotenuse(_p1, _p2, _p3) {
	var _width = (_p3.X - _p1.X);
	var _height = (_p1.Y - _p2.Y);
	
	return { hypot: sqrt((_width * _width) + (_height * _height)), width: _width, height: _height };
}

function make_reference_plane(_trial_width = 1, _theta = undefined) {
	if(is_undefined(_theta)) {
		_theta = global.rot;
	}
	
	var _p = array_create(4);
	_p[0] = new BBMOD_Vec3(-0.5, -0.5, 0);
	_p[1] = new BBMOD_Vec3( 0.5, -0.5, 0);
	_p[2] = new BBMOD_Vec3( 0.5,  0.5, 0);
	_p[3] = new BBMOD_Vec3(-0.5,  0.5, 0);

	var _s = array_create(4);
	_s[0] = toscr(_p[0], _trial_width, _theta);
	_s[1] = toscr(_p[1], _trial_width, _theta);
	_s[2] = toscr(_p[2], _trial_width, _theta);
	_s[3] = toscr(_p[3], _trial_width, _theta);

	var _rv = undefined;

	var _leastxval = infinity;
	var _leastyval = infinity;
	var _leastxidx = 0;
	var _leastyidx = 0;
	var _leastxcnt = 0;
	var _leastycnt = 0;
	var _mostxval = -infinity;
	var _mostyval = -infinity;
	var _mostxidx = 0;
	var _mostyidx = 0;
	var _mostxcnt = 0;
	var _mostycnt = 0;
	
	for(var _x = 0; _x < 4; _x++) {
		if(_s[_x].X < _leastxval) {
			_leastxcnt = 0;
			_leastxval = _s[_x].X;
		}
		if(_s[_x].X == _leastxval) {
			_leastxidx = _x;
			_leastxcnt++;
		}
	}

	for(var _y = 0; _y < 4; _y++) {
		if(_s[_y].Y < _leastyval) {
			_leastycnt = 0;
			_leastyval = _s[_y].Y;
		}
		if(_s[_y].Y == _leastyval) {
			_leastyidx = _y;
			_leastycnt++;
		}
	}

	for(var _x = 3; _x >= 0; _x--) {
		if(_s[_x].X > _mostxval) {
			_mostxcnt = 0;
			_mostxval = _s[_x].X;
		}
		if(_s[_x].X == _mostxval) {
			_mostxidx = _x;
			_mostxcnt++;
		}
	}

	for(var _y = 3; _y >= 0; _y--) {
		if(_s[_y].Y > _mostyval) {
			_mostycnt = 0;
			_mostyval = _s[_y].Y;
		}
		if(_s[_y].Y == _mostyval) {
			_mostyidx = _y;
			_mostycnt++;
		}
	}

	var _width = abs(_mostxval - _leastxval);
	var _height = abs(_mostyval - _leastyval);
	if((_leastxcnt == 1) && (_leastycnt == 1)) { // Normal Plane on angle
		// Get bottom left co-ordinates from leftmost and bottommost co-ordinates
		var _bottom_left = { X: _s[_leastxidx].X, Y: _s[_mostyidx].Y };
		
		// Calc the resulting triangle
		// Hypotenuse not definitely needed but may prove useful for adjusting the scale of the base plane of AABB
		var _ref_tri = get_hypotenuse(_bottom_left, _s[_leastxidx], _s[_mostyidx]);
		
		var _prop_width = abs(_ref_tri.width / _width); // Proportional width of Reference Triangle
		var _prop_height = abs(_ref_tri.height / _height); // Proportional width of Reference Triangle
		if(_width == 0) { // Don't Div Zero
			_width = 0.0001;
		}
		
		_rv = { width: _width,
			   height: _height,
			   scale: _trial_width * (_trial_width / (_width)),
			   pwidth: _prop_width,
			   pheight: _prop_height,
			   reftri: _ref_tri,
			 }
			
	} else if((_leastxcnt == 2) && (_leastycnt == 2)) { // Flat Plane
		_rv = { width: _width,
				height: _height,
				scale: _trial_width * (_trial_width / (_width)),
				pwidth: 1,
				pheight: _height / _width,
				reftri: undefined
				} 
	} else if((_leastxcnt == 4) || (_leastycnt == 4)) { // Zero width / height Plane
		_rv = { width: _width,
				height: _height,
				scale: _trial_width * (_trial_width / (_width)),
				pwidth: 1,
				pheight: _height / _width,
				reftri: undefined
				} 
	} else {
		throw("Wierd angles - unhandled - " + string(_leastxcnt) + 
			", " + string(_leastycnt) +
			", " + string(_leastxval) + 
			", " + string(_mostxval) + 
			", " + string(_leastyval) + 
			", " + string(_mostyval) 
		);
	}

	return _rv;
}

function get_existing_material(matimg) {
	var idx = -1;
	var matcnt = array_length(global.resources.Materials);
	for(var i = 0; i<matcnt; i++) {
		if(global.resources.Materials[i].matname == matimg) {
			idx = i;
			break;
		}
	}
	return idx;
}

function get_materials(matfile, trepeat = false, animated = false) {
	var matimg = false;
		
	matfile = strip_ext(matfile, true);
	var _matisimage = false;
	if(file_exists(matfile + ".png")) {
		matimg = matfile + ".png";
		_matisimage = true;
	} else if(file_exists(matfile + ".jpg")) {
		matimg = matfile + ".jpg";
		_matisimage = true;
	} else {
		matimg = matfile + ".mat";
	}
	
	if(_matisimage) {
		var _midx = get_existing_material(matimg);
		if(_midx != -1) {
			return _midx;
		}
		var matcnt = array_length(global.resources.Materials);

		var _sprcnt = array_length(global.resources.Sprites);
		global.resources.Sprites[_sprcnt] = sprite_add(matimg, 0, false, true, 0, 0);
		if(animated) {
			global.resources.Materials[matcnt] = BBMOD_MATERIAL_DEFAULT.clone();
		} else {
			global.resources.Materials[matcnt] = BBMOD_MATERIAL_DEFAULT.clone();
		}
		global.resources.Materials[matcnt].set_shader(BBMOD_ERenderPass.DepthOnly, BBMOD_SHADER_DEFAULT_DEPTH);
		global.resources.Materials[matcnt].matname = matimg;
		global.resources.Materials[matcnt].Path = matimg;
		if(sprite_exists(global.resources.Sprites[_sprcnt])) {
			var _mattex = sprite_get_texture(global.resources.Sprites[_sprcnt], 0);
			global.resources.Materials[matcnt].BaseOpacity = _mattex;
			global.resources.Materials[matcnt].Repeat = trepeat;
			return matcnt;
		} else {
			show_debug_message("Sprite missing " +  matimg);
		}
	} else {
		var _midx = get_existing_material(matimg);
		if(_midx != -1) {
			return _midx;
		}
		var already_missed = false;
		var miscnt = array_length(global.resources.Missing);
		for(var i=0; i<miscnt; i++) {
			if(global.resources.Missing[i] == matfile) {
				already_missed = true;
			}
		}
		if(!already_missed) {
			global.resources.Missing[miscnt] = matfile;		
			show_debug_message("Missing material : " + matfile);
		}
	}
	return -1;
}

function extract_path(_fname) {
	var _v = string_length(filename_name(_fname));
	var _p = string_copy(_fname, 1, string_length(_fname) - _v);
	if(string_char_at(_p, string_length(_p) - 1) == "/") {
		_p = string_copy(_fname, 1, string_length(_p) - 1);
	}
	if(string_char_at(_p, string_length(_p) - 1) == "/") {
		_p = string_copy(_fname, 1, string_length(_p) - 1);
	}
	return _p;
}

function strip_ext(_fname, include_dir = false) {
	if(include_dir) {
		var _v = _fname;
	} else {
		var _v = filename_name(_fname);
	}
	return string_copy(_v, 1, string_length(_v) - string_length(filename_ext(_v)));
}

function check_ext(_fn, _ext) {
	var _res = false;
	
	if(string_lower(filename_ext(_fn)) == string_lower(_ext)) {
		_res = true;
	}
	
	return _res;
}

function load_models_from(_dir, _autofile = "") {
	// Remove trailing slashes
	while(string_char_at(_dir, string_length(_dir)) == "/") {
		_dir = string_delete(_dir, string_length(_dir), 1);
	}
	
	var _i = array_length(global.resources.Models);
	array_resize(global.resources.Models, _i + 1000);
	var _cnt = 0;
	var _fmask = "";

	if(os_type == os_windows) {
		_fmask = _dir + "/*.bbmod";
	} else {
		_fmask = _dir + "/*";
	}
	var _bfile = file_find_first(_fmask, fa_none); 
	
	while (_bfile != "") {
		if(check_ext(_bfile, ".bbmod")) {
			if(_autofile == _dir + "/" + _bfile) {
				global.autoindex = _i;
			}
			global.resources.Models[_i + _cnt++] = new PDX_Model(_dir + "/" + _bfile);
		}
		_bfile = file_find_next();
	}
	
	array_resize(global.resources.Models, _i + _cnt);

	file_find_close();

	return _cnt;
}

function scan_subdirs(dir) {
	// Remove trailing slashes
	while(string_char_at(dir, string_length(dir)) == "/") {
		dir = string_delete(dir, string_length(dir), 1);
	}
	
	var _dirs = array_create(100, "");
	var _cnt = 0;
	var _fmask = dir + "/*.*";
	
	var _bfile = file_find_first(_fmask, fa_directory); 
	
	while (_bfile != "") {
		_dirs[_cnt++] = dir + "/" + _bfile;
		_bfile = file_find_next();
	}
	
	array_resize(_dirs, _cnt);

	file_find_close();

	return _dirs;
}

function add_mtl_colour(matcol, r, g, b) {
	var _matidx = array_length(global.resources.Materials);
	var _mat = BBMOD_MATERIAL_DEFAULT.clone();
//	_mat.set_shader(BBMOD_ERenderPass.DepthOnly, BBMOD_SHADER_DEFAULT_DEPTH);
	_mat.matname = matcol + ".mat";
	_mat.set_base_opacity(new BBMOD_Color(round(255 * r), round(255 * g), round(255 * b), 1));
	global.resources.Materials[_matidx] = _mat;
}

function get_autofile(_ext = ".bbmod") {
	var _ret = "";
	if(parameter_count() == 2) {
		var _fn = parameter_string(1);
		if(check_ext(_fn, ".bbmod")) {
			_ret = _fn;
		}
	}
	return _ret;
}

function QuatToEuler(Quat) {
	if(is_instanceof(Quat, BBMOD_Quaternion)) {
		var _euler = new BBMOD_Matrix(Quat.ToMatrix()).ToEuler();
		return new BBMOD_Vec3(_euler[0], _euler[1], _euler[2]);
	} else {
		throw("Hissy fit with non-Quaternion in QuatToEuler");
	}
}

function NegateVec3(v) {
	if(is_instanceof(v, BBMOD_Vec3)) {
		v.X = -v.X; 
		v.Y = -v.Y; 
		v.Z = -v.Z; 
		return v;
	} else {
		throw("Hissy fit with non-Vec3 in NegateVec3");
	}
}

function get_sprite_assets() {
    var surf,no,i,ds_map;
    ds_map = argument0;
    surf = surface_create(1,1);
    no = sprite_create_from_surface(surf,0,0,1,1,false,false,0,0);
    surface_free(surf);
    sprite_delete(no);
    for (i=0; i<no; i+=1) {
        if (sprite_exists(i)) {
            ds_map_add(ds_map,sprite_get_name(i),i);
        }
    }
    return 0;
}

function zsort_vec3(_s) {
	var _al = array_length(_s) - 1;
	for(var _i = 0; _i < _al; _i++) {
		if(_s[_i].Z > _s[_i+1].Z) {
			var _t = _s[_i];
			_s[_i] = _s[_i+1];
			_s[_i+1] = _t;
		}
	}
}

function ysort_vec3(_s) {
	var _al = array_length(_s) - 1;
	for(var _i = 0; _i < _al; _i++) {
		if(_s[_i].Y > _s[_i+1].Y) {
			var _t = _s[_i];
			_s[_i] = _s[_i+1];
			_s[_i+1] = _t;
		}
	}
}

function xsort_vec3(_s) {
	var _al = array_length(_s) - 1;
	for(var _i = 0; _i < _al; _i++) {
		if(_s[_i].X > _s[_i+1].X) {
			var _t = _s[_i];
			_s[_i] = _s[_i+1];
			_s[_i+1] = _t;
		}
	}
}

function MakeCameraPositionVector() {
	var _CamRad = 1000;

	var _CamVec3 = new BBMOD_Vec3(_CamRad, 0, 0);
	var _RotYZ = new BBMOD_Vec3(0, global.camVAngle, global.camHAngle);
	var _MatR = new BBMOD_Matrix()
		.RotateEuler(_RotYZ);
	var _tv = matrix_transform_vertex(_MatR.Raw, _CamVec3.X, _CamVec3.Y, _CamVec3.Z);
	return new BBMOD_Vec3(_tv[0], _tv[1], _tv[2]);	
}

function canvas_get_width() {
	if(OSINFO.ostype == os_gxgames) {
		return browser_width;
	} else {
		return window_get_width();
	}
}

function canvas_get_height() {
	if(OSINFO.ostype == os_gxgames) {
		return browser_height;
	} else {
		return window_get_height();
	}
}

function set_camera(_camera) {
	if(_camera.Orthographic) {
		_camera.Target = new BBMOD_Vec3(0, 0, 0);
		_camera.Position = MakeCameraPositionVector();

		_camera.Width = canvas_get_width() * (global.camDistance / 1000);
		_camera.Height = canvas_get_height() * (global.camDistance / 1000);
		_camera.DirectionUp = 0;
		_camera.Direction = 0;
		_camera.ZNear = -32768;
		_camera.ZFar = 32768;
	} else {	
//		_camera.destroy();
//		_camera = new BBMOD_BaseCamera();
		_camera.Target = new BBMOD_Vec3(0, 0, 0);
//		_camera.Position = new BBMOD_Vec3(1000, 0, 1000);
		_camera.Position = MakeCameraPositionVector();
		_camera.Direction = global.camup;
		_camera.ZNear = 0.1;
		_camera.ZFar = 32768;
		_camera.Fov = 60;
	}
}

function wrap(v, vmax) {
	while(v >= vmax) {
		v -= vmax;
	}
	while(v < 0) {
		v += vmax;
	}
	
	return v;
}

function make_sprite(sfile) {
	var _image = sprite_add(sfile, 0, false, true, 0, 0);
	var _required_width = sprite_get_width(_image);
	var _required_height = sprite_get_height(_image);

	show_debug_message("Image = " + sfile + " - " + string(_required_width) + " x " + string(_required_height));
	var _surf = surface_create(_required_width, _required_height);
	surface_set_target(_surf);
	draw_clear_alpha(c_black, 0);
	draw_sprite(_image, 0, 0, 0);
	surface_reset_target();
	sprite_delete(_image);
			
	return sprite_create_from_surface(_surf, 0, 0, _required_width, _required_height, false, false, 0, 0);
}	

function set_screen(req_fs = false, fnt = undefined, font_size = 24) {
	var design_width = 1280;
	var design_height = 800;
	var design_aspect = design_width / design_height;
	var design_min_axis = min(design_width, design_height);
	if(window_get_fullscreen()) {
		req_fs = true;
	}
	var display_width = canvas_get_width();
	var display_height = canvas_get_height();
	if(display_width < global.min_width) {
		if(!req_fs) {
			display_width = global.min_width;
		}
	}
	if(display_height < global.min_height) {
		if(!req_fs) {
			display_height = global.min_height;
		}
	var display_aspect = display_width / display_height;
	}
	var display_min_axis = min(display_width, display_height);

	var game_scale = 1;
	var game_width = display_width;

	if(design_min_axis <> display_min_axis) {
		game_scale = display_min_axis / design_min_axis;
	}

	var game_height = display_height; // * game_scale;

//	var game_aspect = game_width / game_height;
	room_width = game_width;
	room_height = game_height;
	
	if(!req_fs) {
		window_set_size(game_width, game_height);
	}
	
	surface_resize(application_surface, game_width, game_height);

	display_set_gui_size(game_width, game_height);

	if(!req_fs) {
		window_set_position(floor((display_get_width() - game_width) / 2),
							floor((display_get_height() - game_height) / 2));
	}
	var cam = camera_create();
	var viewmat = matrix_build_lookat(game_width / 2, game_height / 2, -10, game_width / 2, game_height / 2, 0, 0, 1, 0);
	var projmat = matrix_build_projection_ortho(game_width, game_height, 1.0, 32000.0);
	camera_set_view_mat(cam, viewmat);
	camera_set_proj_mat(cam, projmat);
	camera_apply(cam);
	
	var _size = 16;
	var _cur_font = draw_get_font();
	
	if(!is_undefined(fnt)) {
		if(file_exists(fnt)) {
			var _line_height = ceil(font_size * (4 / 3));
			main_font = font_add(fnt, font_size, false, false, 32, 128);
			draw_set_font(main_font);
		}
	} else if(_cur_font != -1) {
		var _line_height = _size;
	} else {
		var _line_height = _size;
	}

	window_set_fullscreen(req_fs);
	
	var _scr = {
		dpi_x: display_get_dpi_x(),
		dpi_y: display_get_dpi_y(),
		display_width: display_get_width(),
		display_height: display_get_height(),
		display_aspect: display_get_width() / display_get_height(),
		game_width: game_width,
		game_height: game_height,
		game_scale: game_scale,
		line_height: _line_height,
		font_size: font_size
	}
	
	return _scr;

}

// Load a json file
function load_json(afile) {
	var _res = undefined;
	
	if(file_exists(afile)) {
		var _file = file_text_open_read(afile);
		try {
			var _data = file_text_read_string(_file);
			_res = json_parse(_data);
		} catch(_exception) { 
			throw("Error : in " + afile + " load " + _exception.message);
			_res = undefined;
		} finally {
			file_text_close(_file);
		}
	} else {
		show_debug_message("Can't find : " + afile);
	}
	
	return _res;
}

function export_pdx_modellist() {
	var _l = array_create(array_length(global.resources.Models), "");
	for(var _i = 0; _i < array_length(global.resources.Models); _i++) {
		_l[_i] = global.resources.Models[_i].mpath +
				 global.resources.Models[_i].mname + ".bbmod";
	}
	save_json("c:\\temp\\localModels.json", _l);
}

// Save a json file
function save_json(afile, data) {
	var _res = undefined;

	try {
		var _json = json_stringify(data);

		var _file = file_text_open_write(afile);
		try {
			file_text_write_string(_file, _json);
		} catch(_exception) { 
			show_debug_message("Save - Error : in " + afile + " save " + _exception.message);
			_res = undefined;
			game_end();
		} finally {
			file_text_close(_file);
		}
	} catch(_exception) { 
			show_debug_message("Save - Caught JSON Error : " + _exception.message);
	}
	
	return _res;
}

function load_bin(afile) {
	var _res = undefined;
	
	if(file_exists(afile)) {
		var _file = file_bin_open(afile, 0);
		try {
			var _size = file_bin_size(_file);
			_res = array_create(_size);
			file_bin_seek(_file, 0);
			for(var i = 0; i<_size; i++) { 
				_res[i] = file_bin_read_byte(_file);
			}
		} catch(_exception) { 
			throw("Error : in " + afile + " load " + _exception.message);
			_res = undefined;
		} finally {
			file_bin_close(_file);
		}
	} else {
		show_debug_message("Can't find : " + afile);
	}
	
	return _res;
}

function dirsep() {
	if(os_type == os_windows) {
		return "\\";
	} else {
		return "/";
	}
}

function SelectConfigPath() {
	_info = {os: "UnKnown", 
			 user: "UnKnown", 
			 home: "UnKnown", 
			 gpu:  "UnKnown",
			 is_deck: false,
			 os_info: undefined,
			 supported: false, 
			 have_steam: false,
			 steam_active: false,
			 userdata: "",
			 shortcuts: false,
			 ostype: os_type,
			 steam: {
				app_id: 0,
				account_id: 0,
				user_id: 0,
				is_logged_in: false,
				},
			};
			
	var _osinfo = os_get_info();
	var _osi = json_parse(json_encode(_osinfo));
			 
	_info.os_info = _osi;
	
	switch(os_type) {
		case os_linux : _info.os="Linux"; break;
		case os_gxgames : _info.os="GXC"; break;
		case os_windows : _info.os="Windows"; break;
		case os_macosx : _info.os="Mac"; break;
	}
	
	if(os_type == os_linux) {
		_info.user = environment_get_variable("USER");
		var _home = "/home/" + _info.user;
		if(directory_exists(_home)) {
			_info.home = _home;
			var _basedata = _home + "/.local/share/Steam";
			if(directory_exists(_basedata)) {
				_info.basedata = _basedata;
			}
			if(string_copy(_info.os_info.gl_renderer_string, 1, 19) == "AMD Custom GPU 0405") {
				_info.is_deck = true;
				_info.supported = true;
			}
		}
		_info.gpu = _info.os_info.gl_renderer_string;
	}
	
	
	if(os_type == os_windows) {
		_info.user = environment_get_variable("USERNAME");
		var _home = "Z:\\home\\deck"; // Windows mapping of Linux
		if(directory_exists(_home)) {
			_info.home = _home;
			var _basedata = _home + "\\.local\\share\\Steam";
			if(directory_exists(_basedata)) {
				_info.basedata = _basedata;
/*				
				if(file_exists(_basedata + "\\test.json")) {
					_info.steam.account_id = "67389366";
					_info.steam_active = true;
					_info.is_deck = true;
				}
*/
			}
		}
		if(string_copy(_info.os_info.video_adapter_description, 1, 19) == "AMD Custom GPU 0405") {
			_info.is_deck = true;
			_info.supported = true;
		}
		_info.gpu = _info.os_info.video_adapter_description;
	}
	
	
	if(extension_exists("Steamworks")) {
		if(steam_initialised()) {
			_info.have_steam = true;

			_info.steam_active = true;
			_info.steam.app_id = steam_get_app_id();
			_info.steam.account_id = string(steam_get_user_account_id());
			_info.steam.user_id = steam_get_user_steam_id();
			_info.steam.is_logged_in = steam_is_user_logged_on();
		}
	}

	if(_info.steam_active) {
		var _shortcuts = _basedata + dirsep() + "userdata" + dirsep() + _info.steam.account_id + dirsep() + "config" + dirsep() + "shortcuts.vdf";
		if(file_exists(_shortcuts)) {
			_info.shortcuts = load_bin(_shortcuts);
			if(is_undefined(_info.shortcuts)) {
				_info.shortcuts = false;
			}
		}
	}
	
	return _info;
}

function GetAABB(_model, _node=undefined, _transform=undefined, _outMin=undefined, _outMax=undefined)
{
    var _returnAABB = (_node == undefined);

    _node ??= _model.RootNode;
    _transform ??= new BBMOD_DualQuaternion();
    _outMin ??= new BBMOD_Vec3(infinity);
    _outMax ??= new BBMOD_Vec3(-infinity);

    _transform = _transform.Mul(_node.Transform);

    for (var i = 0; i < array_length(_node.Meshes); ++i)
    {
        var _meshIndex = _node.Meshes[i];
        var _mesh = _model.Meshes[_meshIndex];
        _outMin.Minimize(_transform.Transform(_mesh.BboxMin)).Copy(_outMin);
        _outMax.Maximize(_transform.Transform(_mesh.BboxMax)).Copy(_outMax);
    }

    for (var i = 0; i < array_length(_node.Children); ++i)
    {
        var _child = _node.Children[i];
        GetAABB(_model, _child, _transform, _outMin, _outMax);
    }

    if (_returnAABB)
    {
        return new BBMOD_AABBCollider().FromMinMax(_outMin, _outMax);
    }
}

/*
var _aabb = GetAABB(model); // Returns a BBMOD_AABBCollider
bbmod_material_reset();
_aabb.DrawDebug();
bbmod_material_reset();
*/

function setRotationBase(v) {
	var _rx, _ry, _rz;
	
	v = v & 63;
	
	_rx = v & 3;
	_ry = (v >> 2) & 3;
	_rz = (v >> 4) & 3;
	
	return new BBMOD_Vec3( _rx * 90, _ry * 90, _rz * 90);

}

global.is_game_restarting = false;
#macro OSINFO global.info
OSINFO = SelectConfigPath();


