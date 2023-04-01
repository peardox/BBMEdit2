/// @description Insert description here
// You can write your code in this editor
if(global.dorot) {
	global.rot = wrap(global.rot + 0.25, 360);
}
if(keyboard_check_pressed(vk_space)) {
	rn = wrap(++rn, 64);
	ActiveModel.BBox.Reorient(setRotationBase(rn));
}
if(keyboard_check_pressed(vk_f5)) {
	rn = 0;
	ActiveModel.BBox.Reorient(setRotationBase(rn));
}
setRotationBase(rn);

if(keyboard_check(vk_escape)) {
	game_end();
}

if(keyboard_check_pressed(vk_add)) {
	modelIndex = wrap(++modelIndex, modelCount);
}
if(keyboard_check_pressed(vk_subtract)) {
	modelIndex = wrap(--modelIndex, modelCount);
}
if(keyboard_check_pressed(vk_tab)) {
	global.tabidx = wrap(++global.tabidx, array_length(global.tabs));
	modelIndex = global.tabs[global.tabidx];
}

if(keyboard_check(vk_shift)) {
	if(keyboard_check_pressed(vk_tab)) {
		global.tabidx = wrap(--global.tabidx, array_length(global.tabs));
		modelIndex = global.tabs[global.tabidx];
	}

	if(keyboard_check_pressed(vk_pageup)) {
		ActiveModel.mTranslation.X = wrap(tx -1, 360);
	}
	if(keyboard_check_pressed(vk_pagedown)) {
		ActiveModel.mTranslation.X = wrap(tx + 1, 360);
	}
	if(keyboard_check_pressed(vk_right)) {
		ActiveModel.mTranslation.Y = wrap(ty - 1, 360);
	}
	if(keyboard_check_pressed(vk_left)) {
		ActiveModel.mTranslation.Y = wrap(ty + 1, 360);
	}
	if(keyboard_check_pressed(vk_up)) {
		ActiveModel.mTranslation.Z = wrap(tz + 1, 360);
	}
	if(keyboard_check_pressed(vk_down)) {
		ActiveModel.mTranslation.Z = wrap(tz - 1, 360);
	}
}

if(keyboard_check(vk_control)) {
	if(keyboard_check_pressed(vk_right)) {
		global.rot = wrap(global.rot - 1, 360);
	}
	if(keyboard_check_pressed(vk_left)) {
		global.rot = wrap(global.rot + 1, 360);
	}
}

if(keyboard_check_pressed(vk_home)) {
	modelIndex = wrap(++modelIndex, modelCount);
}
if(keyboard_check_pressed(vk_end)) {
	modelIndex = wrap(--modelIndex, modelCount);
}
if(keyboard_check_pressed(vk_tab)) {
	global.tabidx = wrap(++global.tabidx, array_length(global.tabs));
	modelIndex = global.tabs[global.tabidx];
}

if(keyboard_check(vk_alt)) {
	if(keyboard_check_pressed(vk_pageup)) {
		ActiveModel.mRotation.X = wrap(ActiveModel.mRotation.X - 1, 360);
	}
	if(keyboard_check_pressed(vk_pagedown)) {
		ActiveModel.mRotation.X = wrap(ActiveModel.mRotation.X + 1, 360);
	}
	if(keyboard_check_pressed(vk_right)) {
		ActiveModel.mRotation.Y = wrap(ActiveModel.mRotation.Y - 1, 360);
	}
	if(keyboard_check_pressed(vk_left)) {
		ActiveModel.mRotation.Y = wrap(ActiveModel.mRotation.Y + 1, 360);
	}
	if(keyboard_check_pressed(vk_up)) {
		ActiveModel.mRotation.Z = wrap(ActiveModel.mRotation.Z + 1, 360);
	}
	if(keyboard_check_pressed(vk_down)) {
		ActiveModel.mRotation.Z = wrap(ActiveModel.mRotation.Z - 1, 360);
	}
}
if(keyboard_check_pressed(vk_insert)) {
	tx = 0;
	ty = 0;
	tz = 0;
	rx = 0;
	ry = 0;
	rz = 0;
	ActiveModel.Rotation = BBMOD_Vec3(0);
	ActiveModel.Translation = BBMOD_Vec3(0);
}

if(keyboard_check_pressed(ord("S"))) {
	export_pdx_modellist();
}

if(keyboard_check_pressed(ord("3"))) {
	global.rax = wrap(++global.rax, 4) & 3;
	rn = global.rax | (global.ray << 2) | (global.raz << 4);
	ActiveModel.BBox.Reorient(setRotationBase(rn));
}

if(keyboard_check_pressed(ord("2"))) {
	global.ray = wrap(++global.ray, 4) & 3;
	rn = global.rax | (global.ray << 2) | (global.raz << 4);
	ActiveModel.BBox.Reorient(setRotationBase(rn));
}

if(keyboard_check_pressed(ord("1"))) {
	global.raz = wrap(++global.raz, 4) & 3;
	rn = global.rax | (global.ray << 2) | (global.raz << 4);
	ActiveModel.BBox.Reorient(setRotationBase(rn));
}

if(keyboard_check_pressed(ord("R"))) {
	global.dorot = !global.dorot;
	if(!global.dorot) {
//		global.rot = 0;
	}
}

if(keyboard_check_pressed(ord("B"))) {
	global.display_bb = !global.display_bb;
}

if(keyboard_check_pressed(ord("O"))) {
	global.display_bb = !global.display_obb;
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