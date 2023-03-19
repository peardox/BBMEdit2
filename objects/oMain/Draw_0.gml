/// @description Insert description here
// You can write your code in this editor

// bbmod_material_reset();

 model.draw(0, 0, 100);
/*
var _tScale = model.mscale * model.BBox.Scale;
new BBMOD_Matrix()
			.RotateEuler(model.BBox.AxisRotation)
			.Translate(model.BBox.Translation)
			.Scale(_tScale, _tScale, _tScale)
			.ApplyWorld();
model.animationPlayer.render();
*/
// oCamera.renderer.render();
			
// new BBMOD_Matrix().ApplyWorld();
// bbmod_material_reset();
renderer.render();