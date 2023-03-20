/// @description Insert description here
// You can write your code in this editor

// Do not forget to call the camera's update method
// camera.Direction = global.camdir;
if(keyboard_check_pressed(vk_f3)) {
	camera.Orthographic = !camera.Orthographic;
	set_camera(camera); 
}
if(!camera.Orthographic) {
	if(keyboard_check_pressed(vk_f1)) {
		camera.Position.Y *=2;
		camera.Fov /= 2;
	}
	if(keyboard_check_pressed(vk_f2)) {
		camera.Position.Y /=2;
		camera.Fov *= 2;
	}
	camera.Direction = global.rot;
}
camera.update(delta_time);

camera.apply(); 





if((global.frame % 60) == 15) {
	global.rfps = fps_real;
}
global.frame++;
