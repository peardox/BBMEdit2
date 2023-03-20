/// @description Insert description here
// You can write your code in this editor
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