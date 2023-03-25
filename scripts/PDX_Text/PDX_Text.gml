function str_repeat(str, cnt) {
	var v = "";
	for(var i =0; i< cnt; i++) {
		v = v + str;
	}
	return v;
}
function ShowFloatText(txt, floatval, tot = 0, dec = 0, _depth = 0, colour = c_white) {
        ShowText(txt + string_format(floatval, tot, dec), _depth, colour);
}

function ShowInt64Text(txt, intval, _depth = 0, colour = c_white) {
        ShowText(txt + string(intval), _depth, colour);
}

function ShowBoolText(txt, boolval, _depth = 0, colour = c_white) {
        if(boolval) {
                ShowText(txt + " TRUE", _depth, colour);
        } else {
                ShowText(txt + " FALSE", _depth, colour);
        }
}

function ShowText(txt, _depth = 0, colour = c_white) {
        draw_set_color(colour);
        if(string_length(txt) > 80) {
                txt = string_copy(str_repeat("    ", _depth) + txt, 1, 80) + "...";
        }
        draw_text(global.cursor_x, global.cursor_y, str_repeat("    ", _depth) + txt);
        global.cursor_y += global.screen_info.line_height;
        
}

function ShowStructText(structvar, _depth = 0, colour = c_white) {
		if(_depth > 10) {
			throw("Possible Runaway Recursion");
		}

		if(is_instanceof(structvar, BBMOD_Vec3)) {
			ShowText(" : { X: " + string_format(structvar.X, 4, 6) + 
						", Y: " + string_format(structvar.Y, 4, 6) + 
						", Z: " + string_format(structvar.Z, 4, 6) + " }", _depth);
		} else {
			var keys = variable_struct_get_names(structvar);
			for (var i = array_length(keys)-1; i >= 0; --i) {
	            var k = keys[i];
	            var v = structvar[$ k];
	            /* Use k and v here */
	            if(is_string(v)) {
	                ShowText(k + " : " + v, _depth);
	            } else if(is_bool(v)) {
	                ShowBoolText(k + " : ", v, _depth);
	            } else if(is_real(v)) {
	                ShowFloatText(k + " : ", v, 5, 3, _depth);
	            } else if(is_int64(v)) {
	                ShowInt64Text(k + " : ", v, _depth);
	            } else if(is_struct(v)) {
					ShowText(k + "{} : ", _depth);
	                ShowStructText(v, _depth + 1);
	            } else if(is_array(v)) {
					ShowText(k + "[] : ", _depth);
					for(var _i = 0; _i < array_length(v); _i++) {
						ShowStructText(v[_i], _depth + 1);
					}
	            } else {
					ShowText(k + " : Unknown", _depth);
	            }
	        }
		}
        
}
