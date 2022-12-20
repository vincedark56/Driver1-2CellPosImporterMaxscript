(
	rollout odriver_cellpos_rollout "OpenDriver CELLPOS importer to box"
	(
	checkbox invertX_chkBx "Invert X" pos:[16,256] width:67 height:20
	checkbox invertZ_chkBx "Invert Z" pos:[184,256] width:67 height:20
	checkbox invertY_chkBx "Invert Y" pos:[96,256] width:67 height:20
	groupBox grp2 "Transform" pos:[8,216] width:248 height:96
	groupBox grp3 "Info" pos:[8,56] width:248 height:152
	spinner rotate_spn "Rotate map:" pos:[48,248] width:80 height:16 range:[0,360.0,0.0] type:#float
	spinner scale_spn "Scale Map:" pos:[168,248] width:80 height:16 range:[0,100.0,1.0] type:#float
	button imp_obj "Import OBJ" pos:[8,320] width:248 height:32
	button createboxes "Create the boxes" pos:[8,360] width:248 height:56
	label ny_label "New York: Invert X" pos:[17,120] width:232 height:16
	label miami_label "Miami:" pos:[16,72] width:232 height:16
	label sf_label "San Francisco:" pos:[17,88] width:232 height:16
	label la_label "Los Angeçes:" pos:[17,104] width:232 height:16
	label chicago_label "Chicago: Invert X, Invert Rotation" pos:[17,136] width:232 height:16
	label hav_label "Havana:" pos:[17,152] width:232 height:16
	label lv_label "Las Vegas:" pos:[16,168] width:232 height:16
	label rio_label "Rio:" pos:[16,184] width:232 height:16
	editText preffix_btn "Preffix: " pos:[8,40] width:248 height:16
	label lbl19 "Import the Wavefront file *.LEV_CELLPOS_MAP.obj" pos:[8,8] width:248 height:16
	label lbl20 "that contains the position of the cells" pos:[40,24] width:184 height:16
	checkbox invertRot_chkBx "Invert Rotation" pos:[16,232] width:96 height:24
	dropDownList region_drp "Map Regions:" pos:[8,424] width:248 height:40


    on imp_obj pressed do
    (
		global objname = getOpenFileName caption:"Open Wavefront file" types:"OBJ File (*.obj)|*.obj|"
		(
			if objname != undefined then
			(
				global in_obj = openFile objname
				if in_obj != undefined then
				global offsets_arr = #()
				global reg_drp_list = #()
				(
					while not eof in_obj do
					(
						global offset = filePos in_obj
						skipToString in_obj "# total region cells"
						append offsets_arr (offset as string)
						append reg_drp_list ("Region Count: " + offsets_arr.count as string)
						
					)
					offset_arr_size = offsets_arr.count
					deleteitem reg_drp_list offset_arr_size
					region_drp.items =  reg_drp_list
				)
			)
		)
	)
	on createboxes pressed do
	(
		try
		(
			reg_selected = region_drp.selection
			start_offset = offsets_arr[reg_selected] as integer
			next_reg = reg_selected + 1
			end_offset = offsets_arr[next_reg] as integer - 20
			seek in_obj start_offset
			while filePos in_obj < end_offset do				
			(
				skipToString in_obj "# m"
				box_id = readvalue in_obj as string
				skipToString in_obj "r"
				cell_rot = readvalue in_obj as float
				if invertRot_chkBx.checked == false do
				(
					if cell_rot > 1 and cell_rot < 32 do
					(
						cell_rot = -cell_rot
					)
					if cell_rot > 33 and cell_rot < 64 do
					(
						cell_rot = cell_rot - 32
					)
				)
				
				if invertRot_chkBx.checked == true do
				(
					if cell_rot == 1 then
					(
						return cell_rot
					)
					else
					(
						cell_rot = cell_rot - 32
						cell_rot = -cell_rot
					)
				)
				preffix = preffix_btn.text
				scale = scale_spn.value
				cellbox = box length:5 width:5 height:5
				cellbox.name = preffix + box_id
				obj_pos_line = readLine in_obj -- store the next line to the string variable obj_pos_line
				obj_pos_line_str = filterString obj_pos_line "v " -- filter string will ignore the the characters returning an array of strings
				cellposx = execute obj_pos_line_str[1] * scale
				if invertX_chkBx.checked == true then cellposx = -cellposx
				cellposy = execute obj_pos_line_str[3] * scale
				if invertY_chkBx.checked == true then cellposy = -cellposy
				cellposz = execute obj_pos_line_str[2] * scale
				if invertZ_chkBx.checked == true then cellposz = -cellposz
				cellbox.pos = point3  cellposx cellposy cellposz
				cell_rot_z_euler = cell_rot as float * 5.625 
				cellbox.rotation.z_rotation = cell_rot_z_euler
			)
			actionMan.executeAction 0 "310"
		)
		catch messagebox "Import the .OBJ first"
	)
	)--end rollout
	createDialog odriver_cellpos_rollout 264 472
)
