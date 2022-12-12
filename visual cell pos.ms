rollout unnamedRollout "Untitled" width:264 height:472
(
	checkbox invertX_chkBx "Invert X" pos:[16,256] width:67 height:20
	checkbox invertZ_chkBx "Invert Z" pos:[184,256] width:67 height:20
	checkbox invertY_chkBx "Invert Y" pos:[96,256] width:67 height:20
	groupBox grp2 "Transform" pos:[8,216] width:248 height:96
	groupBox grp3 "Info" pos:[8,56] width:248 height:152
	spinner rotate_spn "Rotate map:" pos:[24,280] width:112 height:16 range:???? type:#float
	spinner scale_spn "Scale Map:" pos:[152,280] width:96 height:16 range:???? type:#float
	button imp_obj "Import OBJ" pos:[8,320] width:248 height:32
	button createboxes "Create the boxes" pos:[8,360] width:248 height:56
	label ny_label "New York: Invert X" pos:[17,120] width:232 height:16
	label miami_label "Miami:" pos:[16,72] width:232 height:16
	label sf_label "San Francisco:" pos:[17,88] width:232 height:16
	label la_label "Los Angeçes:" pos:[17,104] width:232 height:16
	label chicago_label "Chicago:" pos:[17,136] width:232 height:16
	label hav_label "Havana:" pos:[17,152] width:232 height:16
	label lv_label "Las Vegas:" pos:[16,168] width:232 height:16
	label rio_label "Rio:" pos:[16,184] width:232 height:16
	editText preffix_btn "Preffix: " pos:[8,40] width:248 height:16
	label lbl19 "Import the Wavefront file *.LEV_CELLPOS_MAP.obj" pos:[8,8] width:248 height:16
	label lbl20 "that contains the position of the cells" pos:[40,24] width:184 height:16
	checkbox invertRot_chkBx "Invert Rotation" pos:[16,232] width:96 height:24
	dropDownList region_drp "Map Regions:" pos:[8,424] width:248 height:40
)