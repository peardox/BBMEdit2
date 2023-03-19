/// @description Insert description here
// You can write your code in this editor

if(model.is_animated && !is_undefined(model.animationPlayer)) {
	model.animationPlayer.change(global.resources.Animations[animIdx], true);
	model.animationPlayer.update(delta_time);
}
renderer.update(delta_time);