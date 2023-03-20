/// @description Insert description here
// You can write your code in this editor
if(global.dorot) {
	global.rotctr++
	if((global.rotctr % global.rotstep) == 0) {
		global.rot++;
		global.rotctr = 0;
		}
	}
global.rot = wrap(global.rot, 360);

if(keyboard_check(vk_escape)) {
	game_end();
}

if(keyboard_check(vk_left)) {
	global.rot = wrap(--global.rot, 360);
}
if(keyboard_check(vk_right)) {
	global.rot = wrap(++global.rot, 360);
}

