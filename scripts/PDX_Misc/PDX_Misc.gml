// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

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

function wrap(v, max) {
	while(v > max) {
		v -= max;
	}
	while(v < 0) {
		v += max;
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

function set_screen(fnt = undefined, font_size = 24) {
	var design_width = 1280;
	var design_height = 800;
	var design_aspect = design_width / design_height;
	var design_min_axis = min(design_width, design_height);

	var display_width = display_get_width();
	var display_height = display_get_height();
	var display_aspect = display_width / display_height;
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
	
	window_set_size(game_width, game_height);

	surface_resize(application_surface, game_width, game_height);

	display_set_gui_size(game_width, game_height);


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

	window_set_fullscreen(true);
	
	var _scr = {
		dpi_x: display_get_dpi_x(),
		dpi_y: display_get_dpi_y(),
		display_width: display_width,
		display_height: display_height,
		display_aspect: display_aspect,
		game_width: game_width,
		game_height: game_height,
		game_scale: game_scale,
		line_height: _line_height,
		font_size: font_size
	}
	
	return _scr;

}

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

function setRotationBase(v) {
	var _rx, _ry, _rz;
	
	v = v & 63;
	
	_rx = v & 3;
	_ry = (v >> 2) & 3;
	_rz = (v >> 4) & 3;
	
	return new BBMOD_Vec3( _rx * 90, _ry * 90, _rz * 90);

}

global.is_game_restarting = false;
global.info = SelectConfigPath();