

if(model.is_animated && !is_undefined(model.animationPlayer)) {
	model.animationPlayer.change(global.resources.Animations[animIdx], true);
	model.animationPlayer.update(delta_time);
}
