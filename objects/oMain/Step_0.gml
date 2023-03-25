

if(model.is_animated) {
	model.animationPlayer.change(global.resources.Animations[animIdx], true);
	model.animationPlayer.update(delta_time);
}

if(global.display_model) {
	model.draw(tx, ty, tz);
}

//	bbox.draw(tx, ty, tz);
