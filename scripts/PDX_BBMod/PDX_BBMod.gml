// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function PDX_AABB(model = undefined) constructor {
	Min = undefined;
	Max = undefined;
	Size = undefined;
	rRotation = undefined;
	rTranslation = undefined;
	Pivot = undefined;

	static Reset = function(model) {
		if(is_instanceof(model, BBMOD_Model)) {
			if(is_instanceof(model.Meshes[0], BBMOD_Mesh) && !is_undefined(model.Meshes[0].BboxMin) && !is_undefined(model.Meshes[0].BboxMax)) {
				Min = new BBMOD_Vec3(model.Meshes[0].BboxMin.X, model.Meshes[0].BboxMin.Y, model.Meshes[0].BboxMin.Z);
				Max = new BBMOD_Vec3(model.Meshes[0].BboxMax.X, model.Meshes[0].BboxMax.Y, model.Meshes[0].BboxMax.Z);
				var _meshcnt = array_length(model.Meshes);
			} else {
				throw("model has no Bounding Box in PDX_AABB.Reset");
			}
			if(_meshcnt > 1) {
				for(var _m=1; _m<_meshcnt; _m++) {
					if(is_instanceof(model.Meshes[_m], BBMOD_Mesh) && !is_undefined(model.Meshes[_m].BboxMin) && !is_undefined(model.Meshes[_m].BboxMax)) {
							Min.X = min(Min.X, model.Meshes[_m].BboxMin.X);
							Min.Y = min(Min.Y, model.Meshes[_m].BboxMin.Y);
							Min.Z = min(Min.Z, model.Meshes[_m].BboxMin.Z);
							Max.X = max(Max.X, model.Meshes[_m].BboxMax.X);
							Max.Y = max(Max.Y, model.Meshes[_m].BboxMax.Y);
							Max.Z = max(Max.Z, model.Meshes[_m].BboxMax.Z);
						}
					}
				}
				
			rTranslation = NegateVec3(model.RootNode.Transform.GetTranslation());
			rRotation = NegateVec3(QuatToEuler(model.RootNode.Transform.GetRotation()));
			Size = new BBMOD_Vec3(	Max.X - Min.X, 
									Max.Y - Min.Y,
									Max.Z - Min.Z);
									   
			Pivot = new BBMOD_Vec3(	0-(Min.X + (Size.X / 2)), 
									0-(Min.Y + (Size.Y / 2)), 
									0-(Min.Z + (Size.Z / 2)));
		
		} else {
			throw("model is not an instanbce of BBMOD_Model in PDX_AABB.Reset");
		}
	}	

	if(is_instanceof(model, BBMOD_Model)) {
		Reset(model);
	}

}

function PDX_BoundingBox(model = undefined) : PDX_AABB(model) constructor {
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

	static Initialise = function(model) {
		if(is_instanceof(model, BBMOD_Model)) {
			if(is_undefined(Min)) {
				throw("Illegal model - no Bounding Box");
			} else {
				AxisRotation = new BBMOD_Vec3(0);
				Original = new PDX_AABB(model);
				Translation = RotBBox(Original.Pivot, new BBMOD_Vec3(0));
			}
		}
	}


	static Reorient = function(Vec3) {
		var _res = undefined;
		
		if(is_instanceof(Vec3, BBMOD_Vec3)) {
			AxisRotation = Vec3;
			
//			var _nBBox = { Min: RotBBox(new BBMOD_Vec3(Min.X, Min.Y, Min.Z), Original.Pivot),
//						   Max: RotBBox(new BBMOD_Vec3(Max.X, Max.Y, Max.Z), Original.Pivot) 
//						   }
			var _nBBox = { Min: RotBBox(new BBMOD_Vec3(Original.Min.X, Original.Min.Y, Original.Min.Z), Original.Pivot),
						   Max: RotBBox(new BBMOD_Vec3(Original.Max.X, Original.Max.Y, Original.Max.Z), Original.Pivot) 
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
		Initialise(model);
	}

}

function PDX_Model(_file=undefined, trepeat = false, animated = false, rotx = 0, roty = 0, rotz = 0, unitscale = 1, _sha1=undefined) : BBMOD_Model(_file, _sha1) constructor {
	BBox = undefined;
	Ground = undefined;
	mscale = undefined;
	mname = undefined;
	mpath = undefined;
	z = undefined;
	mRotation = undefined;
	mTranslation = undefined;
	xoff = 0;
	yoff = 0;
	zoff = 0;
	is_animated = animated;
	animations = array_create(0);
	animationPlayer = undefined;
	animation_index = 0;
		
	RootTrans = undefined;
	RootRot = undefined;
	
	if(!is_undefined(_file)) {
//		self = BBMOD_RESOURCE_MANAGER.load(_file, _sha1, function(_err, _res){});
		x = 0;
		y = 0; 
		z = 0;


		mRotation = new BBMOD_Vec3(0, 0, 0);
		mTranslation = new BBMOD_Vec3(0, 0, 0);
		mscale = global.size; // sbdbg - Placeholder
		mname = strip_ext(_file);
		mpath = extract_path(_file);
		BBox = new PDX_BoundingBox(self);
		BBox.Reorient(new BBMOD_Vec3(rotx, roty, rotz));
		BBox.Normalize(unitscale);
		if(!is_undefined(BBox)) {
			Ground = min(BBox.Max.Z, BBox.Min.Z); // sbdbg - needs to account for axis + be adjustable
			var matcnt = array_length(Materials);
			if(matcnt > 1) {
				show_debug_message(mname + " has " + string(matcnt) + " materials");
			}
			for(var m = 0; m < matcnt; m++) {
				if(mpath == "") {
					var texfile = MaterialNames[m];
				} else {
					var texfile = mpath + MaterialNames[m];
				}
				var matidx = get_materials(texfile, trepeat, animated);
		
				if(matidx != -1) {
					Materials[m] = global.resources.Materials[matidx];
				}
			}
			if(is_animated) {
				_load_animations(mpath);
				animation_index = 0;
				animationPlayer = new BBMOD_AnimationPlayer(self);
				animationPlayer.change(global.resources.Animations[animations[animation_index]], true);
			}			

		}
	}
	
	static get_camdist = function(_p) {
		var _xd = (oCamera.camera.Position.X - _p.X);
		var _yd = (oCamera.camera.Position.Y - _p.Y);
		var _zd = (oCamera.camera.Position.Z - _p.Z);

		return { dist: sqrt((_xd * _xd) + (_yd * _yd) + (_zd * _zd)), axis: new BBMOD_Vec3(_xd, _yd, _zd) };
	}

	static __toscr = function(_v, _vOrientation) {
		var tp = matrix_transform_vertex(_vOrientation.Raw, _v.X, _v.Y, _v.Z);
		var vv = new BBMOD_Vec3(tp[0], tp[1], tp[2]);
		var _c = get_camdist(vv);
		
		var scr =  oCamera.camera.world_to_screen(vv);
		return new BBMOD_Vec3(scr.X,scr.Y, _c.dist);
	}
	
	static __get_slice_z = function(_z, useOriginal) { // e.g. _z = model.BBox.Min.Z
		var _vScale = mscale * BBox.Scale;
		var _vOrientation = undefined;
		if(useOriginal) {
			_vOrientation = Orientate(true);
		} else {
			_vOrientation = new BBMOD_Matrix()
				.RotateZ(global.rot)
				.Scale(_vScale, _vScale, _vScale)
				;
		}
		var _p = array_create(4);
		_p[0] = new BBMOD_Vec3(BBox.Min.X, BBox.Min.Y, _z);
		_p[1] = new BBMOD_Vec3(BBox.Min.X, BBox.Max.Y, _z);
		_p[2] = new BBMOD_Vec3(BBox.Max.X, BBox.Min.Y, _z);
		_p[3] = new BBMOD_Vec3(BBox.Max.X, BBox.Max.Y, _z);

		var _s = array_create(4);
		for(var _i = 0; _i < 4; _i++) {
			_s[_i] = __toscr(_p[_i], _vOrientation);
		}
		
		return _s;
	}
	
	static  __get_bounding_rectangle = function() {
		var _minz = __get_slice_z(BBox.Min.Z);
		var _maxz = __get_slice_z(BBox.Max.Z);

		var _pminx = min(_minz[0].X, _minz[1].X, _minz[2].X, _minz[3].X, _maxz[0].X, _maxz[1].X, _maxz[2].X, _maxz[3].X);
		var _pminy = min(_minz[0].Y, _minz[1].Y, _minz[2].Y, _minz[3].Y, _maxz[0].Y, _maxz[1].Y, _maxz[2].Y, _maxz[3].Y);
		var _pminz = min(_minz[0].Z, _minz[1].Z, _minz[2].Z, _minz[3].Z, _maxz[0].Z, _maxz[1].Z, _maxz[2].Y, _maxz[3].Z);
		var _pmaxx = max(_minz[0].X, _minz[1].X, _minz[2].X, _minz[3].X, _maxz[0].X, _maxz[1].X, _maxz[2].X, _maxz[3].X);
		var _pmaxy = max(_minz[0].Y, _minz[1].Y, _minz[2].Y, _minz[3].Y, _maxz[0].Y, _maxz[1].Y, _maxz[2].Y, _maxz[3].Y);
		var _pmaxz = max(_minz[0].Z, _minz[1].Z, _minz[2].Z, _minz[3].Z, _maxz[0].Z, _maxz[1].Z, _maxz[2].Z, _maxz[3].Z);

		return { Min: new BBMOD_Vec3(_pminx, _pminy, _pminz), Max: new BBMOD_Vec3(_pmaxx, _pmaxy, _pmaxz ),	
				 Width: abs(_pmaxx - _pminx), Height: abs(_pmaxy - _pminy), Depth: abs(_pmaxz - _pminz)
			   };
	}

	static __draw_bounds = function(_brect, _colour) {
		draw_set_color(_colour);

		draw_line(floor(_brect.Min.X) - 1, floor(_brect.Min.Y) - 1,  ceil(_brect.Max.X) + 1, floor(_brect.Min.Y) - 1); // Top line
		draw_line(floor(_brect.Min.X) - 1, floor(_brect.Min.Y) - 1, floor(_brect.Min.X) - 1,  ceil(_brect.Max.Y) + 1); // Left line
		draw_line( ceil(_brect.Max.X) + 1, floor(_brect.Min.Y) - 1,  ceil(_brect.Max.X) + 1,  ceil(_brect.Max.Y) + 1); // Right line 
		draw_line(floor(_brect.Min.X) - 1,  ceil(_brect.Max.Y) + 1,  ceil(_brect.Max.X) + 1,  ceil(_brect.Max.Y) + 1); // Bottom line
	}

	static DrawBoundingRect = function(_colour = c_yellow) {
		draw_set_color(_colour);
		var _brect = __get_bounding_rectangle();
		__draw_bounds(_brect, _colour);	
		
		return _brect;
	}
	
	static MakeColourLerp = function(_qty, _cminmax) {
		var _Ar = _cminmax.ColourA & $FF;
		var _Ag = (_cminmax.ColourA >> 8) & $FF;
		var _Ab = (_cminmax.ColourA >> 16) & $FF;
		var _Br = _cminmax.ColourB & $FF;
		var _Bg = (_cminmax.ColourB >> 8) & $FF;
		var _Bb = (_cminmax.ColourB >> 16) & $FF;

		var _red = round(lerp(_Br, _Ar, _qty));
		var _green = round(lerp(_Bg, _Ag, _qty));
		var _blue = round(lerp(_Bb, _Ab, _qty));

		return make_colour_rgb(_red, _green, _blue);
	}
	
	static MakeDepthColour = function(_depth, _cminmax) {
		var _c = (_depth - _cminmax.Min) * (1 / _cminmax.Range);

		return MakeColourLerp(_c, _cminmax);
	}
	
	static DrawDepthLine = function(_point1, _point2, _cminmax) {
		draw_line_colour(_point1.X, _point1.Y, _point2.X, _point2.Y, 
						MakeDepthColour(_point1.Z, _cminmax), 
						MakeDepthColour(_point2.Z, _cminmax));
	}
	
	static DrawColourLine = function(_point1, _point2, _colour) {
		draw_line_colour(_point1.X, _point1.Y, _point2.X, _point2.Y, _colour, _colour);
	}
	
	static DrawBoundingBox =  function(_colourFar = 31, _colourNear = 255, useOriginal = false) {
		var _minz = undefined;
		var _maxz = undefined;
		if(useOriginal) {
			_minz = __get_slice_z(BBox.Original.Min.Z, true);
			_maxz = __get_slice_z(BBox.Original.Max.Z, true);
		} else {
			_minz = __get_slice_z(BBox.Min.Z);
			_maxz = __get_slice_z(BBox.Max.Z);
		}
		var _cminmax = { Min: min(_minz[0].Z, _minz[1].Z, _minz[2].Z, _minz[3].Z, _maxz[0].Z, _maxz[1].Z, _maxz[2].Z, _maxz[3].Z),
						 Max: max(_minz[0].Z, _minz[1].Z, _minz[2].Z, _minz[3].Z, _maxz[0].Z, _maxz[1].Z, _maxz[2].Z, _maxz[3].Z),
						 ColourA: _colourFar, ColourB: _colourNear, Range: 0 };
		_cminmax.Range = abs(_cminmax.Max - _cminmax.Min);
		if(_cminmax.Range == 0) {
			_cminmax.Range = 1;
		}


		// Draw bottom
		DrawDepthLine(_minz[0], _minz[1], _cminmax);
		DrawDepthLine(_minz[0], _minz[2], _cminmax);
		DrawDepthLine(_minz[3], _minz[1], _cminmax);
		DrawDepthLine(_minz[3], _minz[2], _cminmax);

/*
		DrawColourLine(_minz[0], _minz[1], $00FF00);
		DrawColourLine(_minz[0], _minz[2], $007F00);
		DrawColourLine(_minz[3], _minz[1], $003F00);
		DrawColourLine(_minz[3], _minz[2], $00BF00);
*/	

		// Draw sides
		DrawDepthLine(_minz[2], _maxz[2], _cminmax);
		DrawDepthLine(_minz[3], _maxz[3], _cminmax);
		DrawDepthLine(_minz[0], _maxz[0], _cminmax);
		DrawDepthLine(_minz[1], _maxz[1], _cminmax);

		// Drap top
		DrawDepthLine(_maxz[0], _maxz[1], _cminmax);
		DrawDepthLine(_maxz[0], _maxz[2], _cminmax);
		DrawDepthLine(_maxz[3], _maxz[1], _cminmax);
		DrawDepthLine(_maxz[3], _maxz[2], _cminmax);
		
		return { Top: _maxz, Bottom: _minz , CMiz: _cminmax }

	}
	
	static drawAxes = function(_colour = c_grey) {
		var _scr =  oCamera.camera.world_to_screen(new BBMOD_Vec3(0,0,0));
		var _x = 0; // canvas_get_width() / 2;
		var _y = 0; // canvas_get_height() / 2;
		
		draw_set_color(_colour);
		draw_line(_x, _scr.Y, _x + canvas_get_width(), _scr.Y);
		draw_line(_scr.X, _y, _scr.X, _y + canvas_get_height());
		
	}

	static Orientate = function(useOriginal = false) {
		var _tScale = mscale * BBox.Scale;
		if(useOriginal) {
			return new BBMOD_Matrix()
				.RotateZ(global.rot)
				.Scale(_tScale, _tScale, _tScale)
				.RotateEuler(mRotation)
//				.Translate(mTranslation)
				;
		} else {
			return new BBMOD_Matrix()
				.Translate(BBox.rTranslation)
				.RotateEuler(BBox.rRotation)
				.RotateEuler(BBox.AxisRotation)
				.Translate(BBox.Translation)
				.RotateZ(global.rot)
				.Scale(_tScale, _tScale, _tScale)
				.RotateEuler(mRotation)
				.Translate(mTranslation)
				;
		}			
		
	}
	
	static draw = function() {

		var o = Orientate();
		o.ApplyWorld();

		
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
		_clone.mpath = mpath;
		_clone.is_animated = is_animated;
		_clone.x = 0;
		_clone.y = 0;
		_clone.z = 0;
		_clone.xrot = xrot;
		_clone.yrot = yrot;
		_clone.zrot = zrot;
		_clone.mRotation = new BBMOD_Vec3(0, 0, 0);
		_clone.mTranslation = new BBMOD_Vec3(0, 0, 0);

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

	static _load_animations = function(dir) {
		var _cnt = array_length(global.resources.Animations);
		var _i = 0;
		var _flist = [];
	
		var _bfile = file_find_first(dir + "/*.bbanim", fa_none); 
	
		if (_bfile != "") {
			while (_bfile != "") {
				_flist[_i++] = dir + "/" + _bfile;
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
	

}




