/// @description Insert description here
// You can write your code in this editor

// Do not forget to call the camera's update method
// camera.Direction = global.camdir;
if(keyboard_check_pressed(vk_f3)) {
	camera.Orthographic = !camera.Orthographic;
	if(camera.Orthographic) {
		camera.Target = new BBMOD_Vec3(0, 0, 0);
		camera.Position = new BBMOD_Vec3(1000, 0, 0);
		camera.Width = window_get_width();
		camera.Height = window_get_height();

		camera.DirectionUp = global.camup;
		camera.ZNear = -32768;
		camera.ZFar = 32768;
	} else {	
		camera.Target = new BBMOD_Vec3(0, 0, 0);
		camera.Position = new BBMOD_Vec3(1000, 0, -1000);

		camera.DirectionUp = global.camup;
		camera.ZNear = 0.1;
		camera.ZFar = 32768;
		camera.Fov = 60;
	}
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
