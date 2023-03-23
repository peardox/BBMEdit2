if(keyboard_check_pressed(vk_f6)) {
	global.camVAngle = 0;		
	global.CamHAngle = 0;		
	set_camera(camera); 
}

if(keyboard_check_pressed(vk_f7)) {
	global.camVAngle = 30;		
	global.CamHAngle = 0;		
	set_camera(camera); 
}

if(keyboard_check_pressed(vk_f8)) {
	global.camVAngle = 35.26438968;		
	global.CamHAngle = 0;		
	set_camera(camera); 
}

if(keyboard_check_pressed(vk_f9)) {
	global.camVAngle = 45;		
	global.CamHAngle = 0;		
	set_camera(camera); 
}

if(keyboard_check_pressed(vk_f10)) {
	global.camVAngle = 90;		
	global.CamHAngle = 0;		
	set_camera(camera); 
}

if(!keyboard_check(vk_shift)) {
	if(keyboard_check_pressed(vk_right)) {
		global.camHAngle = wrap(global.camHAngle - 11.25, 360);
		set_camera(camera);
	}
	if(keyboard_check_pressed(vk_left)) {
		global.camHAngle = wrap(global.camHAngle + 11.25, 360);
		set_camera(camera);
	}
	if(keyboard_check_pressed(vk_down)) {
		global.camVAngle = clamp(global.camVAngle - 11.25, -90, 90);
		set_camera(camera);
	}
	if(keyboard_check_pressed(vk_up)) {
		global.camVAngle = clamp(global.camVAngle + 11.25, -90, 90);
		set_camera(camera);
	}
}

if(keyboard_check_pressed(ord("F"))) {
	global.fullscreen = !global.fullscreen;
	set_screen(global.fullscreen);
	set_camera(camera); 
}

