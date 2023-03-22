global.screen_info = set_screen();

camera = new BBMOD_BaseCamera();
// camera = new BBMOD_Camera();
camera.DirectionUpMax = 90;

if(global.camera_ortho) {
	camera.Orthographic = true;
	set_camera(camera); 
} else {	
	camera.Orthographic = false;
	set_camera(camera); 
}

global.have_camera = true;


renderer = new BBMOD_DefaultRenderer();
renderer.UseAppSurface = true;
renderer.RenderScale = 1;