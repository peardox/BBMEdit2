/// @description Insert description here
// You can write your code in this editor
if(global.dorot) {
	global.rot = wrap(++global.rot, 360);
}
if(keyboard_check_pressed(vk_space)) {
	rn = wrap(++rn, 64);
	model.BBox.Reorient(setRotationBase(rn));
}
if(keyboard_check_pressed(vk_f5)) {
	rn = 0;
	model.BBox.Reorient(setRotationBase(rn));
}
setRotationBase(rn);

if(keyboard_check(vk_escape)) {
	game_end();
}

if(keyboard_check(vk_shift)) {
	if(keyboard_check_pressed(vk_pageup)) {
		tx = tx - 0.5;
	}
	if(keyboard_check_pressed(vk_pagedown)) {
		tx = tx + 0.5;
	}
	if(keyboard_check_pressed(vk_right)) {
		ty = ty - 0.5;
	}
	if(keyboard_check_pressed(vk_left)) {
		ty = ty + 0.5;
	}
	if(keyboard_check_pressed(vk_up)) {
		tz = tz + 0.5;
	}
	if(keyboard_check_pressed(vk_down)) {
		tz = tz - 0.5;
	}
}
if(keyboard_check_pressed(vk_insert)) {
	tx = 0;
	ty = 0;
	tz = 0;
}


if(keyboard_check_pressed(ord("3"))) {
	global.rax = wrap(++global.rax, 4) & 3;
	rn = global.rax | (global.ray << 2) | (global.raz << 4);
	model.BBox.Reorient(setRotationBase(rn));
}

if(keyboard_check_pressed(ord("2"))) {
	global.ray = wrap(++global.ray, 4) & 3;
	rn = global.rax | (global.ray << 2) | (global.raz << 4);
	model.BBox.Reorient(setRotationBase(rn));
}

if(keyboard_check_pressed(ord("1"))) {
	global.raz = wrap(++global.raz, 4) & 3;
	rn = global.rax | (global.ray << 2) | (global.raz << 4);
	model.BBox.Reorient(setRotationBase(rn));
}

if(keyboard_check_pressed(ord("R"))) {
	global.dorot = !global.dorot;
	if(!global.dorot) {
		global.rot = 0;
	}
}

if(keyboard_check_pressed(ord("B"))) {
	global.display_bb = !global.display_bb;
}

if(keyboard_check_pressed(ord("T"))) {
	global.display_br = !global.display_br;
}

if(keyboard_check_pressed(ord("M"))) {
	global.display_model = !global.display_model;
}

if(keyboard_check_pressed(ord("X"))) {
	global.display_axis = !global.display_axis;
}

if(keyboard_check_pressed(ord("I"))) {
	global.display_info = !global.display_info;
}