if(global.display_axis) {
	ActiveModel.drawAxes();
}
if(global.display_bb) {
	var _bb = ActiveModel.DrawBoundingBox();
}
if(global.display_br) {
	var _br = ActiveModel.DrawBoundingRect();
}

if(global.display_obb) {
	ActiveModel.DrawBoundingBox($001F00, $00FF00, true);
}

global.cursor_y = 64;
global.cursor_x = 8;

draw_set_color(c_white);

if(OSINFO.ostype <> os_gxgames) {
	draw_text(8,  0, "Desktop Version = " + GM_version + " " + global.autofile);
} else {
	draw_text(8,  0, "GXC Version = " + GM_version);
}
draw_text(8, 16, "RotBase = (" + string(rn) + ") AxisRotation : " + string(ActiveModel.BBox.AxisRotation));	
	
draw_text(8, 32, "Frame = " + string(global.frame) + 
					", FPS = " + string(fps) + 
					", Real = " + string(global.rfps) +
					", Rot = " + string(global.rot) +
					", Cam = " + string(oCam.camera.Position) +
					". CamHRot = " + string(global.camHAngle) +
					". CamVRot = " + string(global.camVAngle) 
					);	
					 
ShowText("BBox = " + string(ActiveModel.Meshes[0].BboxMin) + " - " + string(ActiveModel.Meshes[0].BboxMax));

if(global.autofile != "") {
	if(file_exists(global.autofile)) {
		ShowText("Found " + global.autofile);
	} else {
		ShowText("Can''t Find " + global.autofile);
	}
}
var _tv = ActiveModel.RootNode.Transform.GetTranslation();
var _rr = ActiveModel.BBox.rRotation;

ShowText("Translation = " + string(_tv));
ShowStructText("rRotation = ", _rr);

ShowText("Model = " +
			string(modelIndex + 1) + " / " +
			string(modelCount) + 
			" Path = " + ActiveModel.mpath + 
			" Name = " + ActiveModel.mname);
ShowText("Tabs = " + string(global.tabs));
if(array_length(global.resources.Missing) > 0) {
	ShowText("Missing image textures (" + string(array_length(global.resources.Missing)) + ")");
	for(var i = 0; i < array_length(global.resources.Missing); i++) {
		ShowText(global.resources.Missing[i]);
	}
} else {
	if(global.display_info) {
/*
		ShowText("Model");
		ShowStructText("BBox : ", ActiveModel.BBox);
		ShowText("");
		if(global.display_br) {
			ShowStructText("Bounding Rectangle", _br);
		}
		if(global.display_bb) {
			ShowStructText("Bounding Box", _bb);
		}
*/		
		ShowFloatText("camVAngle", global.camVAngle, 5, 3);
		ShowFloatText("camHAngle", global.camHAngle, 5, 3);
		ShowStructText("mRot : ", ActiveModel.mRotation);
		ShowStructText("mTrans : ", ActiveModel.mTranslation);
	}
}