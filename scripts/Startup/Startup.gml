// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.camera_ortho = true;
global.have_camera = false;
global.camdir = 0;
global.camVAngle = 0;
global.camHAngle = 0;
global.camDistance = 1000;
global.camup = -45;
global.frame = 0
global.rfps = 0;
global.running = false;

global.dorot = false;
global.rotctr = 0;
global.rotstep = 1;
global.rotctr = 0;
global.size = 512;
global.rot = 0;
global.fullscreen = false;
global.min_width = 1280;
global.min_height = 720;


global.camera_distance = 0;

global.use_peardox = true;

camera_destroy(camera_get_default());
