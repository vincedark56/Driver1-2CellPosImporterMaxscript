(
	rollout odriver_cellpos_rollout "OpenDriver CELLPOS importer to box"
	(
    label lab1 "Import the Wavefront file *.LEV_CELLPOS_MAP.obj"
    label lab2 "that contains the position of the cells"
	edittext preffix_btn "Preffix: "
	spinner scale_spn "Scale: " type:#float range:[0,100.0,1.0]
	checkbox invertX_chkBx "Invert X axis"
	checkbox invertY_chkBx "Invert Y axis"
	checkbox invertZ_chkBx "Invert Z axis"
    button imp_obj "Import .OBJ"
	button createboxes "Create the boxes"
	dropdownlist region_drp "Map Offset" items:#()


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
				if cell_rot > 1 and cell_rot < 32 do
				(
					cell_rot = -cell_rot
				)
				if cell_rot > 33 and cell_rot < 64 do
				(
					cell_rot = cell_rot - 32
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
		)
		catch messagebox "Import the .OBJ first"
	)
	)--end rollout
	createDialog odriver_cellpos_rollout 260 250
)
