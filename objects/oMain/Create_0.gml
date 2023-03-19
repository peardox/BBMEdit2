/// @description Insert description here
// You can write your code in this editor
rn = 0;
animIdx = 0;
model = undefined;	

//	model = new PDX_Model("Character/Character.bbmod", true, false, 0, 180, 0, 1, { Size: { X: 3.62, Y: 1.05, Z: 3.76} });
//	animIdx = 2;
//	model = new PDX_Model("licensed/cat/Cat_Chubby.bbmod", true, false, 180, 270, 90);
//	animIdx = 5;
//	model = new PDX_Model("Boy/Boy.bbmod", true, false, 0, 0, 90);
//	animIdx = 10;
//	model.Gimbal.Rotation.Y = 180;
//	model = new PDX_Model("cube/hexa123-in-air.bbmod", false, false, 0, 0, 0);
//	model = new PDX_Model("cube/hexa123-in-air.bbmod", false, false, 270, 270, 0);

//  model = new PDX_Model("cube/hexa123-ground.bbmod", false, false, 270, 270, 0);
//	model = new PDX_Model("cube/hexa123.bbmod", false, false, 270, 180, 0);
//	model = new PDX_Model("cube/cube-z-x-view.bbmod", false, false, 270, 180, 0);
//	model = new PDX_Model("cube/defcube.bbmod", false, false, 0, 0, 0);
//	model = new PDX_Model("cube/cube.bbmod", false, false, 270, 270, 0);
	// model.Gimbal.Rotation.Y = 90;


// animationPlayer = new BBMOD_AnimationPlayer(model);
if(is_undefined(model)) {
	model = new PDX_Model("cube/castle.bbmod", false, false, 180);
}
global.running = true;


renderer = new BBMOD_DefaultRenderer();
renderer.UseAppSurface = true;
renderer.RenderScale = 1;

/*

renderer.EnableShadows = true;
// renderer.EnableShadows = true;

// Enable SSAO
renderer.EnableGBuffer = true;
// renderer.EnableSSAO = true;
// renderer.SSAOPower = 3;
// renderer.SSAODepthRange = 0.5;
// renderer.SSAOBlurDepthRange = 0.1;

postprocessor = new BBMOD_PostProcessor();
// postprocessor.Antialiasing = BBMOD_EAntialiasing.FXAA;
// postprocessor.ChromaticAberration = 4;
// postprocessor.Vignette = 1;
// postprocessor.ColorGradingLUT = sprite_get_texture(SprColorGrading, 0);
 renderer.PostProcessor = postprocessor;
 renderer.EnablePostProcessing = true;

//bbmod_light_ambient_set_up(BBMOD_C_AQUA);
//bbmod_light_ambient_set_down(BBMOD_C_ORANGE);

bbmod_light_ambient_set(BBMOD_C_WHITE);

 sun = new BBMOD_DirectionalLight();
 sun.CastShadows = true;
 sun.ShadowmapArea = 200;
 bbmod_light_directional_set(sun);

iblSprite = sprite_add("Skies/IBL+0.png", 1, false, true, 0, 0);
ibl = new BBMOD_ImageBasedLight(sprite_get_texture(iblSprite, 0));
bbmod_ibl_set(ibl);
*/