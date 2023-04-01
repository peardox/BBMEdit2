

if(ActiveModel.is_animated) {
	ActiveModel.animationPlayer.change(global.resources.Animations[animIdx], true);
	ActiveModel.animationPlayer.update(delta_time);
}

if(global.display_model) {
	ActiveModel.draw();
}

//	bbox.draw(tx, ty, tz);
