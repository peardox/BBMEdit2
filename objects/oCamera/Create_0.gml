global.screen_info = set_screen();

camera = new BBMOD_BaseCamera();
camera.DirectionUpMax = 90;

if(global.camera_ortho) {
	camera.Orthographic = true;

	camera.Target = new BBMOD_Vec3(0, 0, 0);
	camera.Position = new BBMOD_Vec3(1000, 0, 0);
	camera.Width = window_get_width();
	camera.Height = window_get_height();

	camera.DirectionUp = global.camup;
	camera.ZNear = -32768;
	camera.ZFar = 32768;
} else {	
	camera.Orthographic = false;
	camera.Target = new BBMOD_Vec3(0, 0, 0);
	camera.Position = new BBMOD_Vec3(-1000, 0, 1000);

	camera.DirectionUp = global.camup;
	camera.ZNear = 0.1;
	camera.ZFar = 32768;
	camera.Fov = 60;
}

global.have_camera = true;


