// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

global.resources = {
    Animations: [], // <- Add Animations struct here
    Materials: [],
    Missing: [],
    Models: [],
    Tiles: [],
	Sprites: []
};

function PDX_AABB(model = undefined, extbbox = undefined) constructor {
	Min = undefined;
	Max = undefined;
	Size = undefined;
	Pivot = undefined;

	static Reset = function(model, extbbox = undefined) {
		if(is_instanceof(model, BBMOD_Model)) {
			var _meshcnt = array_length(model.Meshes);
			if(_meshcnt > 0) {
				if(is_instanceof(model.Meshes[0], BBMOD_Mesh) && 
					!is_undefined(model.Meshes[0].BboxMin) && 
					!is_undefined(model.Meshes[0].BboxMax)) {
						Min = new BBMOD_Vec3(model.Meshes[0].BboxMin.X, model.Meshes[0].BboxMin.Y, model.Meshes[0].BboxMin.Z);
						Max = new BBMOD_Vec3(model.Meshes[0].BboxMax.X, model.Meshes[0].BboxMax.Y, model.Meshes[0].BboxMax.Z);

						for(var _m=1; _m<_meshcnt; _m++) {
							if(is_instanceof(model.Meshes[_m], BBMOD_Mesh) && 
								!is_undefined(model.Meshes[_m].BboxMin) && 
								!is_undefined(model.Meshes[_m].BboxMax)) {
									Min.X = min(Min.X, model.Meshes[_m].BboxMin.X);
									Min.Y = min(Min.Y, model.Meshes[_m].BboxMin.Y);
									Min.Z = min(Min.Z, model.Meshes[_m].BboxMin.Z);
									Max.X = max(Max.X, model.Meshes[_m].BboxMax.X);
									Max.Y = max(Max.Y, model.Meshes[_m].BboxMax.Y);
									Max.Z = max(Max.Z, model.Meshes[_m].BboxMax.Z);
							}
						}

					} else {
						if(is_struct(extbbox)) {
							if(variable_struct_exists(extbbox, "Size")) {
								Min = new BBMOD_Vec3(0, 0, 0);
								Max = new BBMOD_Vec3(extbbox.Size.X, extbbox.Size.Y, extbbox.Size.Z);
							} else {
								throw("Malformed External Bounding Box");
							}
						} else {
							throw("No Bounding Box");
						}
					}
			Size = new BBMOD_Vec3(	Max.X - Min.X, 
									Max.Y - Min.Y,
									Max.Z - Min.Z);
									   
			Pivot = new BBMOD_Vec3(	0-(Min.X + (Size.X / 2)), 
									0-(Min.Y + (Size.Y / 2)), 
									0-(Min.Z + (Size.Z / 2)));
		
			}			
		}
	}	

	var _a = debug_get_callstack(4);
	show_debug_message("In PXD_AABB - model = " + /* string(model) + */
			". extbbox = " + string(extbbox) +
			", Stack ...`n" + string(_a));
	if(is_instanceof(model, BBMOD_Model)) {
		Reset(model, extbbox);
	}

}

function PDX_BoundingBox(model = undefined, extbbox = undefined) : PDX_AABB(model, extbbox) constructor {
	Translation = undefined;
	AxisRotation = undefined;
	Original = undefined;
	Scale = 1;
	
	static RotBBox = function(Vec3, Pivot) {
		var matx = new BBMOD_Matrix()
			.Translate(Pivot)
			.RotateEuler(AxisRotation);
		var _tv = matrix_transform_vertex(matx.Raw, Vec3.X, Vec3.Y, Vec3.Z);
		var _rbb = new BBMOD_Vec3(_tv[0], _tv[1], _tv[2]);
		
		return _rbb;
	}

	static Initialise = function(model, extbbox) {
		if(is_instanceof(model, BBMOD_Model)) {
			if(is_undefined(Min)) {
				throw("Illegal model - no Bounding Box");
			} else {
				AxisRotation = new BBMOD_Vec3(0);
				Original = new PDX_AABB(model, extbbox);
				Translation = RotBBox(Pivot, new BBMOD_Vec3(0));
			}
		}
	}


	static Reorient = function(Vec3) {
		var _res = undefined;
		
		if(is_instanceof(Vec3, BBMOD_Vec3)) {
			AxisRotation = Vec3;
			
			var _nBBox = { Min: RotBBox(new BBMOD_Vec3(Original.Min.X, Original.Min.Y, Original.Min.Z), Pivot),
						   Max: RotBBox(new BBMOD_Vec3(Original.Max.X, Original.Max.Y, Original.Max.Z), Pivot) 
						   }

			var _sBBox = { Min: new BBMOD_Vec3(0, 0, 0), Max: new BBMOD_Vec3(0, 0, 0) };
			
			_sBBox.Min.X = min(_nBBox.Min.X, _nBBox.Max.X);
			_sBBox.Min.Y = min(_nBBox.Min.Y, _nBBox.Max.Y);
			_sBBox.Min.Z = min(_nBBox.Min.Z, _nBBox.Max.Z);
			_sBBox.Max.X = max(_nBBox.Min.X, _nBBox.Max.X);
			_sBBox.Max.Y = max(_nBBox.Min.Y, _nBBox.Max.Y);
			_sBBox.Max.Z = max(_nBBox.Min.Z, _nBBox.Max.Z);
			
			Min = _sBBox.Min;
			Max =  _sBBox.Max;
			Size = new BBMOD_Vec3(	Max.X - Min.X, 
									Max.Y - Min.Y,
									Max.Z - Min.Z);
			Pivot = new BBMOD_Vec3(	0-(Min.X + (Size.X / 2)), 
									0-(Min.Y + (Size.Y / 2)), 
									0-(Min.Z + (Size.Z / 2)));
			Translation = RotBBox(	Original.Pivot, new BBMOD_Vec3(0, 0, 0));
		}		
			
		return _res;
	}
	
	static Normalize = function(unitscale) {
		Scale = unitscale / max(Size.X, Size.Y, Size.Z);		
	}

	if(is_instanceof(model, BBMOD_Model)) {
		Initialise(model, extbbox);
	}

}

function PDX_Model(_file=undefined, animated = false, trepeat = false, rotx = 0, roty = 0, rotz = 0, unitscale = 1, extbbox = undefined, _sha1=undefined) : BBMOD_Model(_file, _sha1) constructor {
	BBox = undefined;
	Ground = undefined;
	mscale = undefined;
	mname = undefined;
	z = undefined;
	xoff = 0;
	yoff = 0;
	zoff = 0;
	is_animated = animated;
	animations = array_create(0);
	animationPlayer = undefined;
	animation_index = 0;
	animation_index = 0;
	
	
	if(!is_undefined(_file)) {
//		self = BBMOD_RESOURCE_MANAGER.load(_file, _sha1, function(_err, _res){});
		x = 0;
		y = 0; 
		z = 0;
		mscale = global.size; // sbdbg - Placeholder
		mname = __strip_ext(_file);
		BBox = new PDX_BoundingBox(self, extbbox);
		BBox.Reorient(new BBMOD_Vec3(rotx, roty, rotz));
		BBox.Normalize(unitscale);
		if(!is_undefined(BBox)) {
			Ground = min(BBox.Max.Z, BBox.Min.Z); // sbdbg - needs to account for axis + be adjustable
			var matcnt = array_length(Materials);
			if(matcnt > 1) {
				show_debug_message(mname + " has " + string(matcnt) + " materials");
			}
			var _path = __extract_path(_file);
			for(var m = 0; m < matcnt; m++) {
				if(_path == "") {
					var texfile = MaterialNames[m];
				} else {
					var texfile = _path + MaterialNames[m];
				}
				var matidx = _get_materials(texfile, trepeat, animated);
		
				if(matidx != -1) {
					Materials[m] = global.resources.Materials[matidx];
				}
			}
			if(is_animated) {
				_load_animations(_path);
				animation_index = 0;
				animationPlayer = new BBMOD_AnimationPlayer(self);
				animationPlayer.change(global.resources.Animations[animations[animation_index]], true);
			}			

		}
	}
	
	static toscr = function(v) {
		return oCamera.camera.world_to_screen(v);
	}
	
	static __get_slice_z = function(_z, _scale = 1) { // e.g. _z = model.BBox.Min.Z
		var _p = array_create(4);
		_p[0] = new BBMOD_Vec3((BBox.Min.X + xoff) * _scale, (BBox.Min.Y + yoff) * _scale, (_z + zoff) * _scale);
		_p[1] = new BBMOD_Vec3((BBox.Min.X + xoff) * _scale, (BBox.Max.Y + yoff) * _scale, (_z + zoff) * _scale);
		_p[2] = new BBMOD_Vec3((BBox.Max.X + xoff) * _scale, (BBox.Min.Y + yoff) * _scale, (_z + zoff) * _scale);
		_p[3] = new BBMOD_Vec3((BBox.Max.X + xoff) * _scale, (BBox.Max.Y + yoff) * _scale, (_z + zoff) * _scale);

		var _s = array_create(4);
		for(var _i = 0; _i < 4; _i++) {
			_s[_i] = toscr(_p[_i]);
		}
	
		zsort_vec3(_s);
		
		return _s;
	}
	
	static  __get_bounding_rectangle = function(_scale = 1) {
		var _minz = __get_slice_z(BBox.Min.Z, _scale);
		var _maxz = __get_slice_z(BBox.Max.Z, _scale);

		var _minx = min(_minz[0].X, _minz[1].X, _minz[2].X, _minz[3].X, _maxz[0].X, _maxz[1].X, _maxz[2].X, _maxz[3].X);
		var _miny = min(_minz[0].Y, _minz[1].Y, _minz[2].Y, _minz[3].Y, _maxz[0].Y, _maxz[1].Y, _maxz[2].Y, _maxz[3].Y);
		var _maxx = max(_minz[0].X, _minz[1].X, _minz[2].X, _minz[3].X, _maxz[0].X, _maxz[1].X, _maxz[2].X, _maxz[3].X);
		var _maxy = max(_minz[0].Y, _minz[1].Y, _minz[2].Y, _minz[3].Y, _maxz[0].Y, _maxz[1].Y, _maxz[2].Y, _maxz[3].Y);

		return { Min: { X: _minx, Y: _miny }, Max: { X: _maxx, Y: _maxy },
				 Width: abs(_maxx - _minx), Height: abs(_maxy - _miny)
			   };
	}

	static __draw_bounds = function(_brect, _colour = c_white) {
		draw_set_color(_colour);

		draw_line(floor(_brect.Min.X) - 1, floor(_brect.Min.Y) - 1,  ceil(_brect.Max.X) + 1, floor(_brect.Min.Y) - 1); // Top line
		draw_line(floor(_brect.Min.X) - 1, floor(_brect.Min.Y) - 1, floor(_brect.Min.X) - 1,  ceil(_brect.Max.Y) + 1); // Left line
		draw_line( ceil(_brect.Max.X) + 1, floor(_brect.Min.Y) - 1,  ceil(_brect.Max.X) + 1,  ceil(_brect.Max.Y) + 1); // Right line 
		draw_line(floor(_brect.Min.X) - 1,  ceil(_brect.Max.Y) + 1,  ceil(_brect.Max.X) + 1,  ceil(_brect.Max.Y) + 1); // Bottom line
	}
	
	static __fit_size = function() {
		var _size = max(BBox.Size.X, BBox.Size.Y, BBox.Size.Z);
		return _size;
	}

	static DrawBoundingRect = function(_colour = c_yellow) {
		draw_set_color(_colour);
		var _size = mscale * BBox.Scale; // 1;
		var _brect = __get_bounding_rectangle(_size);
		__draw_bounds(_brect, _colour);	
		
		return _brect;
	}
	
	static DrawBoundingBox =  function(_isortho = false, _colour = c_red, _colour2 = c_maroon) {
		var _size = mscale * BBox.Scale; // 1;
//		Orientate();
		var _minz = __get_slice_z(BBox.Min.Z, _size);
		var _maxz = __get_slice_z(BBox.Max.Z, _size);
//		array_push(_minz, _maxz);

		if(!_isortho) {
			draw_line_colour(_minz[0].X, _minz[0].Y, _maxz[0].X, _maxz[0].Y, _colour, _colour2);
			draw_line_colour(_minz[1].X, _minz[1].Y, _maxz[1].X, _maxz[1].Y, _colour, _colour2);
			draw_line_colour(_minz[2].X, _minz[2].Y, _maxz[2].X, _maxz[2].Y, _colour, _colour2);
			draw_line_colour(_minz[3].X, _minz[3].Y, _maxz[3].X, _maxz[3].Y, _colour, _colour2);

			draw_set_color(_colour2);
			draw_line(_maxz[0].X, _maxz[0].Y, _maxz[1].X, _maxz[1].Y);
			draw_line(_maxz[0].X, _maxz[0].Y, _maxz[2].X, _maxz[2].Y);
			draw_line(_maxz[3].X, _maxz[3].Y, _maxz[1].X, _maxz[1].Y);
			draw_line(_maxz[3].X, _maxz[3].Y, _maxz[2].X, _maxz[2].Y);
		}
		
		draw_set_color(_colour);
		draw_line(_minz[0].X, _minz[0].Y, _minz[1].X, _minz[1].Y);
		draw_line(_minz[0].X, _minz[0].Y, _minz[2].X, _minz[2].Y);
		draw_line(_minz[3].X, _minz[3].Y, _minz[1].X, _minz[1].Y);
		draw_line(_minz[3].X, _minz[3].Y, _minz[2].X, _minz[2].Y);

	}
	
	static drawAxes = function(_colour = c_grey) {
		var _scr =  oCamera.camera.world_to_screen(new BBMOD_Vec3(0,0,0));
		var _x = window_get_x();
		var _y = window_get_y();
		
		draw_set_color(_colour);
		draw_line(_x, _scr.Y, _x + window_get_width(), _scr.Y);
		draw_line(_scr.X, _y, _scr.X, _y + window_get_height());
		
	}

	static Orientate = function() {
//		var _t = __fit_size();
		// var _magic = 256; //  make_reference_plane(1 / max(BBox.Size.X, BBox.Size.Y));		var _rscale = mscale * BBox.Scale; // _magic.scale;
		var _tScale = mscale * BBox.Scale;
		return new BBMOD_Matrix()
			.RotateEuler(BBox.AxisRotation)
			.RotateZ(global.rot)
//			.Translate(BBox.Translation.X, 0 /* - BBox.Translation.Y */, BBox.Translation.Z)
			.Translate(0, 0, BBox.Translation.Z)
			.Scale(_tScale, _tScale, _tScale);
		
	}
	
	static draw = function(_scr_x = 0, _scr_y = 0, _scr_z = 0, xrot = 0, yrot = 0, zrot = 0 ) {

		Orientate().ApplyWorld();
		
		if(is_animated && !is_undefined(animationPlayer)) {
			animationPlayer.render();
		} else {
			render();
		}
	}
	
	
	static clone = function () {
		var _clone = new PDX_Model();
		copy(_clone);

		_clone.BBox = BBox;
		_clone.Ground = Ground;
		_clone.mscale = mscale;
		_clone.mname = mname;
		_clone.is_animated = is_animated;
		_clone.x = 0;
		_clone.y = 0;
		_clone.z = 0;
		_clone.xrot = xrot;
		_clone.yrot = yrot;
		_clone.zrot = zrot;

		var _ac = array_length(animations)
		_clone.animations = array_create(_ac);
		for(var _ai=0; _ai < _ac; _ai++) {
			_clone.animations[_ai] = animations[_ai];
		}
		
		_clone.animation_index = animation_index;
		_clone.animationPlayer = new BBMOD_AnimationPlayer(self);
		_clone.animationPlayer.PlaybackSpeed = global.animation_speed;				
		_clone.animationPlayer.change(global.resources.Animations[_clone.animations[_clone.animation_index]], true);

		return _clone;
	};

	static __strip_ext = function(_fname, include_dir = false) {
		if(include_dir) {
			var _v = _fname;
		} else {
			var _v = filename_name(_fname);
		}
		return string_copy(_v, 1, string_length(_v) - string_length(filename_ext(_v)));
	}

	static _load_animations = function(dir) {
		var _cnt = array_length(global.resources.Animations);
		var _i = 0;
		var _flist = [];
	
		var _bfile = file_find_first(dir + "\\*.bbanim", fa_none); 
	
		if (_bfile != "") {
			while (_bfile != "") {
				_flist[_i++] = dir + "\\" + _bfile;
				_bfile = file_find_next();
			}
		}
	
		file_find_close();

		array_sort(_flist, function(elm1, elm2) {
			    return elm1 > elm2;
			});
			
		var _fl = array_length(_flist);
		animations = array_create(_fl)
		
		for (var _f = 0; _f < _fl; _f++) {
			show_debug_message("Loading animation #" + string(_f) + " - " + _flist[_f]);
			animations[_f] = _f + _cnt;
			global.resources.Animations[_cnt + _f] = new BBMOD_Animation(_flist[_f]);
		}

		return _fl;
	}

	static __extract_path = function(_fname) {
		var _v = string_length(filename_name(_fname));
		var _p = string_copy(_fname, 1, string_length(_fname) - _v);
		if(string_char_at(_p, string_length(_p) - 1) == "/") {
			_p = string_copy(_fname, 1, string_length(_p) - 1);
		}
		if(string_char_at(_p, string_length(_p) - 1) == "\\") {
			_p = string_copy(_fname, 1, string_length(_p) - 1);
		}
		return _p;
	}

	
	static _get_materials = function(matfile, trepeat = false, animated = false) {
		var matimg = false;
		
		matfile = __strip_ext(matfile, true);
	
		if(file_exists(matfile + ".png")) {
			matimg = matfile + ".png";
		} else if(file_exists(matfile + ".jpg")) {
			matimg = matfile + ".jpg";
		} else {
			matimg = matfile;
		}
	
		if(is_string(matimg)) {
			var matcnt = array_length(global.resources.Materials);
			for(var i = 0; i<matcnt; i++) {
				if(global.resources.Materials[i].matname == matimg) {
					return i;
				}
			}
//			var sprtex = new BBMOD_Sprite(matimg);
//			var sprtex = sprite_add(matimg, 0, false, true, 0, 0);
			var _sprcnt = array_length(global.resources.Sprites);
			global.resources.Sprites[_sprcnt] = sprite_add(matimg, 0, false, true, 0, 0);
//			global.resources.Sprites[_sprcnt] = make_sprite(matimg);
//			sprite_prefetch(sprtex);
			if(animated) {
//				global.resources.Materials[matcnt] = BBMOD_MATERIAL_DEFAULT_ANIMATED.clone();
				global.resources.Materials[matcnt] = BBMOD_MATERIAL_DEFAULT.clone();
//				BBMOD_MATERIAL_DEFAULT.clone();
			} else {
				global.resources.Materials[matcnt] = BBMOD_MATERIAL_DEFAULT.clone();
			}
			global.resources.Materials[matcnt].set_shader(BBMOD_ERenderPass.DepthOnly, BBMOD_SHADER_DEFAULT_DEPTH);
			global.resources.Materials[matcnt].matname = matimg;
			global.resources.Materials[matcnt].Path = matimg;
			if(sprite_exists(global.resources.Sprites[_sprcnt])) {
				var _mattex = sprite_get_texture(global.resources.Sprites[_sprcnt], 0);

				global.resources.Materials[matcnt].BaseOpacity = _mattex;
				show_debug_message("Loaded material : " + matimg + " in " + mname);

				global.resources.Materials[matcnt].Repeat = trepeat;
				return matcnt;
			} else {
				throw("Sprite missing " +  matimg);
			}
		} else {
			var already_missed = false;
			var miscnt = array_length(global.resources.Missing);
			for(var i=0; i<miscnt; i++) {
				if(global.resources.Missing[i] == matfile) {
					already_missed = true;
				}
			}
			if(!already_missed) {
				global.resources.Missing[miscnt] = matfile;		
				show_debug_message("Missing material : " + matfile + " in " + mname);
			}
		}
		return -1;
	}

}
/*
	global.resources.Sprites[0] = skin;	
	global.resources.Materials[0] = BBMOD_MATERIAL_DEFAULT_ANIMATED.clone();
	global.resources.Materials[0].matname = "Character/skin";
	global.resources.Materials[0].set_shader(BBMOD_ERenderPass.DepthOnly, BBMOD_SHADER_DEFAULT_DEPTH);
	global.resources.Materials[0].BaseOpacity = sprite_get_texture(skin, 0);
*/