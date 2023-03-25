if(global.display_axis) {
	model.drawAxes();
}
if(global.display_bb) {
	var _bb = model.DrawBoundingBox();
}
if(global.display_br) {
	var _br = model.DrawBoundingRect();
}

if(global.display_info) {
	draw_set_color(c_white);

	if(OSINFO.ostype <> os_gxgames) {
		draw_text(8,  0, "Desktop Version = " + GM_version);
	} else {
		draw_text(8,  0, "GXC Version = " + GM_version);
	}
	draw_text(8, 16, "RotBase = (" + string(rn) + ") AxisRotation : " + string(model.BBox.AxisRotation));	
	
	draw_text(8, 32, "Frame = " + string(global.frame) + 
					 ", FPS = " + string(fps) + 
					 ", Real = " + string(global.rfps) +
					 ", Rot = " + string(global.rot) +
					 ", Cam = " + string(oCam.camera.Position)
					 );	


	if(array_length(global.resources.Missing) > 0) {
		draw_text(8, 64, "Missing image textures (" + string(array_length(global.resources.Missing)) + ")");
		for(var i = 0; i < array_length(global.resources.Missing); i++) {
			draw_text(8, 80 + (i * 16), global.resources.Missing[i]);
		}
	} else {
		global.cursor_y = 64;
		global.cursor_x = 0;

		ShowText("Model");
		ShowStructText(model.BBox);
		ShowText("");
		ShowText("Offset");
		ShowStructText(new BBMOD_Vec3(tx, ty, tz));
		if(global.display_br) {
			ShowText("Bounding Rectangle");
			ShowStructText(_br);
		}
		if(global.display_bb) {
			ShowText("Bounding Box");
			ShowStructText(_bb);
		}
		ShowFloatText("camVAngle", global.camVAngle, 5, 3);
		ShowFloatText("camHAngle", global.camHAngle, 5, 3);
		ShowInt64Text("RAX : ", global.rax);
		ShowInt64Text("RAY : ", global.ray);
		ShowInt64Text("RAZ : ", global.raz);
	//	var _wm = new BBMOD_Matrix().FromWorld();
	//	ShowText("World : " + string(_wm));
	}
}
