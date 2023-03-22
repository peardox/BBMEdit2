/// @description Insert description here
// You can write your code in this editor
if(global.dorot) {
	global.rotctr++
	if((global.rotctr % global.rotstep) == 0) {
		global.rot++;
		global.rotctr = 0;
		}
	}
global.rot = wrap(global.rot, 360);

if(keyboard_check(vk_escape)) {
	game_end();
}

if(keyboard_check(vk_shift)) {
	if(keyboard_check_pressed(vk_left)) {
		tx = tx - 0.5;
	}
	if(keyboard_check_pressed(vk_right)) {
		tx = tx + 0.5;
	}

	if(keyboard_check_pressed(vk_up)) {
		ty = ty - 0.5;
	}
	if(keyboard_check_pressed(vk_down)) {
		ty = ty + 0.5;
	}

	if(keyboard_check_pressed(vk_pageup)) {
		tz = tz + 0.5;
	}

	if(keyboard_check_pressed(vk_pagedown)) {
		tz = tz - 0.5;
	}
}
if(keyboard_check_pressed(vk_insert)) {
	tx = 0;
	ty = 0;
	tz = 0;
}


if(keyboard_check_pressed(ord("R"))) {
	global.dorot = !global.dorot;
}