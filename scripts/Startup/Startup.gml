// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.camera_ortho = true;
global.have_camera = false;
global.camdir = 0;
global.camVAngle = 0.00;
global.camHAngle = 0.00;
global.camDistance = 1000;
global.rot = 0;
global.camup = -45;
global.frame = 0
global.rfps = 0;
global.running = false;
global.display_obb = false;

global.rax = 0;
global.ray = 0;
global.raz = 0;
global.tabs = [0, 203, 370, 425, 548, 656, 795, 924, 1257, 1372, 1528, 1666];
global.tabidx = 0;
global.display_model = true;
global.display_info = false;
global.display_bb = true;
global.display_br = false;
global.display_axis = true;

global.dorot = false;
global.rotctr = 0;
global.rotstep = 1;
global.rotctr = 0;
global.size = 512;
global.fullscreen = false;
global.min_width = 1280;
global.min_height = 720;


global.camera_distance = 0;

global.use_peardox = true;

camera_destroy(camera_get_default());

global.resources = {
    Animations: [], // <- Add Animations struct here
    Materials: [],
    Missing: [],
    Models: [],
    Files: [],
	Sprites: []
};

global.p_string = [];
global.autofile = "";
global.autoindex = -1;
global.debug = "";

add_mtl_colour("free/Kenney/FantasyTown/_defaultMat", 1, 1, 1);
add_mtl_colour("free/Kenney/FantasyTown/foliage", 0.2588235, 0.7921569, 0.6034038);
add_mtl_colour("free/Kenney/FantasyTown/hay", 0.9490196, 0.854902, 0.6313726);
add_mtl_colour("free/Kenney/FantasyTown/roof", 0.2588235, 0.7921569, 0.6039216);
add_mtl_colour("free/Kenney/FantasyTown/roofLight", 0.4100658, 0.8962264, 0.7246404);
add_mtl_colour("free/Kenney/FantasyTown/roofRed", 0.8666667, 0.2588235, 0.3492543);
add_mtl_colour("free/Kenney/FantasyTown/roofRedLight", 1, 0.4198113, 0.5096469);
add_mtl_colour("free/Kenney/FantasyTown/stone", 0.6916608, 0.8617874, 0.9339623);
add_mtl_colour("free/Kenney/FantasyTown/stoneDark", 0.5032929, 0.6660821, 0.735849);
add_mtl_colour("free/Kenney/FantasyTown/water", 0.4941176, 1, 0.9332614);
add_mtl_colour("free/Kenney/FantasyTown/wood", 0.9150943, 0.6063219, 0.4359647);
add_mtl_colour("free/Kenney/FantasyTown/woodDark", 0.764151, 0.4663556, 0.2991723);

add_mtl_colour("free/Kenney/Racing/_defaultMat", 1, 1, 1);
add_mtl_colour("free/Kenney/Racing/bark", 0.8313726, 0.654902, 0.4235294);
add_mtl_colour("free/Kenney/Racing/carTire", 0.2666667, 0.2666667, 0.2666667);
add_mtl_colour("free/Kenney/Racing/glass", 0.2980392, 0.3764706, 0.4666667);
add_mtl_colour("free/Kenney/Racing/grass", 0.3019608, 0.5607843, 0.4313726);
add_mtl_colour("free/Kenney/Racing/grey", 0.945098, 0.9490196, 0.9647059);
add_mtl_colour("free/Kenney/Racing/pylon", 0.9607843, 0.7254902, 0.2588235);
add_mtl_colour("free/Kenney/Racing/road", 0.2666667, 0.2666667, 0.2666667);
add_mtl_colour("free/Kenney/Racing/red", 0.9098039, 0.3333333, 0.3254902);
add_mtl_colour("free/Kenney/Racing/sand", 0.7830189, 0.7193986, 0.5872642);
add_mtl_colour("free/Kenney/Racing/wall", 1, 0.9490196, 0.8705882);
add_mtl_colour("free/Kenney/Racing/white", 1, 1, 1); 

get_materials("cube/checkers", true);
add_mtl_colour("cube/_defaultMat", 1, 1, 1);
add_mtl_colour("cube/grey", 0.945098, 0.9490196, 0.9647059);
add_mtl_colour("cube/road", 0.2666667, 0.2666667, 0.2666667);

get_materials("free/Kenney/Racing/checkers", true);
get_materials("free/Kenney/RetroMedieval/bricks", true);
get_materials("free/Kenney/RetroMedieval/stones", true);
get_materials("free/Kenney/RetroMedieval/stonesPainted", true);
get_materials("free/Kenney/RetroMedieval/barrel", true);
get_materials("free/Kenney/RetroMedieval/fence", true);
get_materials("free/Kenney/RetroMedieval/planks", true);
get_materials("licensed/Zerin/RetroMedievalKit/bricks", true);
get_materials("licensed/Zerin/RetroMedievalKit/stones", true);
get_materials("licensed/Zerin/RetroMedievalKit/stonesPainted", true);
get_materials("licensed/Zerin/RetroMedievalKit/barrel", true);
get_materials("licensed/Zerin/RetroMedievalKit/fence", true);
get_materials("licensed/Zerin/RetroMedievalKit/planks", true);
