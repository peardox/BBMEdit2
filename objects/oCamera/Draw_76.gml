/// @description Insert description here
// You can write your code in this editor
if( (canvas_get_width() <> surface_get_width(application_surface)) || 
	(canvas_get_height() <> surface_get_height(application_surface))) {
	set_screen(false);
	set_camera(camera); 
}