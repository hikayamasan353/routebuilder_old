unit StateD;


interface
uses windows;
   const

		OK  =  0;
		VR_ERROR = -1;

		YES = 1;
		NO  = 0;

		WORLD_SPACE	 = 0;
		OBJECT_SPACE = WORLD_SPACE + 1;
		CAMERA_SPACE = WORLD_SPACE + 2;

		PLAYER_CONTROL   = 1;
		COMPUTER_CONTROL = 2;
		
		// used for STATE_camera_save()
		CAMERA_DESCRIPTOR_SIZE = 53;  //Number of DWORDs (212 bytes)


		EDGE_NOT_SEEN		= 1;
		EDGE_FULLY_SEEN		= 2;
		EDGE_PARTIALLY_SEEN	= 3;
		
		// Automatic movement constants == "Chasing"
		// --------------------------
		// In the wld file we have the following lines that are relevant
		// to the Automatic movement.
		// TRACK: track_name track_offset //chase name could be NO_TRACK if ...
		// SPEED: track_speed    // track speed is also used in CHASE_PRECISE and CHASE_FLEXIBLE
							 // in those cases it is the distance behind the chased object
		// CHASE: dynamic_object_to_chase  chase_offset
		// CHASE_TYPE: chase_type tracking_softness  //tracking_softness is a number between 0 and 1.

		// Below are the values that could appear in chase_type.
		// relevant fields: none
		// The NO_CHASE Const Must be 0.
		NO_CHASE =	0; // doesn't move at all. Control is through software

		// relevant fields: dynamic_object_to_chase, chase_offset
		CHASE_LOCATION = 2; // trace only location. Only the line "CHASE: object_to_chase x y z " is relevant
							// The three numbers are the offset from the object being chased
		// relevant fields: dynamic_object_to_chase, chase_offset, chase_distance
		CHASE_PRECISE = 3; //  trace location and cord system. The track is ignored

		// relevant fields: dynamic_object_to_chase, chase_offset, chase_distance, tracking_softness
		CHASE_FLEXIBLE = 4; // trace location and direction with a delay

		//Not a chase type but a chase family
		//Makes it possible to do things like if(chase_type & CHASE_TRACK_FAMILY) ...
		CHASE_TRACK_FAMILY	= 128;

		// not available yet
		CHASE_ON_TRACK  = 5 + CHASE_TRACK_FAMILY; // chase the object to be chased but doesn't go out of the track line

		// not available yet
		CHASE_INSIDE_TRACK_BOUNDING_BOX	= 6; // chase the object to be chased but doesn't go out from the track bounding box

		// relevant fields: track_name, track_offset, speed, tracking_softness
		CHASE_TRACK = 7 + CHASE_TRACK_FAMILY; // just advance on the track according to the speed with out chasing anyone

		// relevant fields: track_name, track_offset, speed, tracking_softness
		CHASE_TRACK_AIRPLANE = 8 + CHASE_TRACK_FAMILY; // like CHASE_TRACK just with an airplane movements

		CHASE_PHYSICS =	9;	//Moves the object according to the physics params (that is
							// speed,friction, elasticity, max_speed)
		
		// Orientation values
		ORIENTATION_UNKNOWN = 0;
		ORIENTATION_TOP		= 1;
		ORIENTATION_BOTTOM	= 2;
		ORIENTATION_FRONT	= 4;
		ORIENTATION_BACK	= 8;

		NO_TRACK = 0;

		// world_mode options (for function STATE_engine_load_world() )
		USER_DEFINED_BEHAVIOR = 0;
		AUTO_BEHAVIOR01		  = 1; //JAPPLIC_ID
		AUTO_BEHAVIOR02	      = 2; //CORE_APPLIC // NOTE AUTO_BEHAVIOR02 is obsolete
		EDITOR_MODE	          = 4;
		DONT_USE_ZBUFFER      = 8; //This option doesn't  works together with  EDITOR_MODE. When zbuffer is off
								   // rendering will be faster but less accurate (things that are supposed to be hidden will sometime appear
								   // depending on the structure of the used world). If zbuffer is on the rendering will
								   // be accurate though slower. We suggest that you try both possibilities and choose what's best
								   // The default is zbuffer ON.

		////The resample flags cause every bitmap that is loaded to be automatically resampled to a power of two dimensions
		RESAMPLE_UP		  = 16; //The new width and height will always be bigger than or equal than the original dimension of the bitmap
		RESAMPLE_CLOSEST  = 32; //The new dimensions will be the closest power of two numbers to the original dimensions
		RESAMPLE_DOWN	  = 64; //The new width and height will always be smaller than or equal than the original dimension of the bitmap

		MIPMAP_DISABLE	  = 0;	//The default
		MIPMAP_STABLE	  = 128;//Bitmaps will look more stable (The pixels wont "swim")
							//though the resolution will be a little bit lower
		MIPMAP_RESOLUTION = 512;//This option prefers better resolution upon stable bitmaps
                MIPMAP_NORMAL	  = 1024;//An average between MIPMAP_STABLE and MIPMAP_RESOLUTION

		ENABLE_BRIGHT_LIGHT				= 2048; //Relevant only when 3D card is used.
		ENABLE_VERY_BRIGHT_LIGHT		= 4096;
		CREATE_BSP_FOR_DYNAMIC_OBJECTS	= 8192;
		NO_BSP_FOR_STATIC_WORLD			= 16384;
		DONT_CREATE_ADDITIONAL_BITMAPS	= 32768;
		DONT_LOAD_BITMAPS				= 65536;

		SAVE_DEFAULT			= 0;
		SAVE_ONLY_WHATS_NEEDED	= 1;//does NOT save extra resources that are not needed to the saved group. it will save only animations that are needed for the polygons in the models. Cameras backgrounds and tracks will NOT be saved
									// see also SAVE_MODELS_ONLY
		SAVE_FLAT_BITMAP_PATH	= 2;//for every polygon the name of its bitmap wont include the path just the name. the same for animations. this is very convenient if we want to keep all the bitmap in one directory.
									// If we also save bitmaps then the save will be done with flat bitmap path no matter the value of this flag.
		// The following options will save the world as a complete projects including the bitmaps file
		// The function will make a directory called bitmap bellow the given path, and there it will put all the bitmaps
		// The idea here that the world becomes a "stand alone" it can be send through e-mail, put on a diskette etc ...
		// Note that when you try to load the world
		// after it was saved the engine would first look for jbm files
		// then for bmp and then for jpg, so if a bitmap was changed and saved as bmp
		// but the jbm file wasnt deleted then the engine will load the old bitmap in the jbm format.
		// using one of the bitmaps flag will cause the save to be done with flat bitmap path no matter the value of this flag.
		// using different kind of bitmaps type is allowed. it will create all of them on the disk.
		SAVE_BITMAP_AS_JPG	= 4; //The bitmaps are saved in a JPG format. This should be done when optimizing for space. The down side is that it would take more time to load the world. and
								 // the quality of some bitmaps might suffer. If transparent bitmap have spots or that some parts are missing one can modify by hand
								 // The *.flt file for that bitmap.
								 //for more information about the flt files see at the bottom of this file
								 // in the help appendixes

		SAVE_BITMAP_AS_BMP	= 8; //The bitmaps are saved in a BMP format. This should be done when we want the ability to modify the bitmaps
								 // using bitmaps editors like PhtoPaint, Photoshop, Paintbrush etc ... Remember to delete the jbm file each time you modify the bitmap.
		SAVE_BITMAP_AS_JBM	= 16;//The bitmaps are saved in a JBM format. This is the engine internal format. This should be done when we want the loading time of the world to be as short as possible.

		//see also the flag SAVE_BITMAP_OPTIMIZE below

		SAVE_IN_MULTIPLE_FILES	= 32; // Instead of putting all the models in one file, it saves each model
									  // in a separate file. This way is easier to change the world
									  // by hand. In this method it is also very easy to replace components (now each one is
									  // separate file

		SAVE_ONLY_MODELS = 64; //Save the model and its bitmaps and only the animations that are currently used by
							   // the model. This is the same as to call with SAVE_ONLY_WHATS_NEEDED when all the save flags are set to NO
							   // ( see STATE_camera_set_save_flag() , STATE_animation_set_save_flag(0 etc ...)

		SAVE_RELEASE = 128; //1 -   All the polygons will be put inside module main
							//		this makes a faster save and a faster load afterwards
							//		When we load a world that was save using SAVE_RELEASE we
							//		will lose all group affiliations.
							//2-	polygons that have their release_save flag set to NO wont be saved
							//		for example some models have polygons that are used only as a bottom
							//		(applications like Morfit World Builder need a bottom polygon so when
							//		we drop an objects on a floor it will know how to put it, in some models
							//		a bottom polygon is part of the model and in others (like trees) it is just an extra polygon)
							//		the release_save_flag can be set by STATE_polygon_set_release_save_flag() or
							//		by specifying NO\YES in the RELEASE_SAVE field in the world text file

		SAVE_BITMAP_OPTIMIZED = 512; //This option overrides the following flags SAVE_BITMAP_AS_JPG, SAVE_BITMAP_AS_BMP, and SAVE_BITMAP_AS_JBM
									 //with this option all the bitmaps will be saved in jpg format
									 //except those that are being used with a transparency, those will be saved
									 //in BMP format. This flag is used when we want to save in jpg format
									 //but we dont want the jpg format to ruin the transparency bitmaps.
									 //The problem is that jpg images are not identical to the original and
									 //this makes a big problem with the transparent color because instead of one background color
									 //for example 255,255,255 we get several like 254,255,255 and 255,254,254 etc ...
									 //the engine will only eliminate one transparent color leaving all the other nuances
									 //If you didnt understand, just try to save a world using the flag SAVE_BITMAP_AS_JPG
									 //and then load the saved world and look at polygons that use a transparent bitmap.
									 //another way to deal with this problem is using the flt file that is saved together with each jpg bitmap
									 //for more information about the flt files see at the bottom of this file
									 // in the help appendixes

	
		SAVE_WITHOUT_GROUPS	= 1024; //This flag is only valid when saving in the binary format (to save in binary format give a file name that has a "morfit" name extension instead of "wld")
								   //In many application in viewer mode, the STATE_group_ API is not used at all
								   //In this case you might want to use this flag in order to decrease the size of the saved file.


		STATE_DELETE  = 1;
		STATE_DISABLE = 2;

		UNITS_PER_SECOND = 1;
		UNITS_PER_RENDER = 2;

		CENTER_OF_TOP_OBJECT = 1;
		CENTER_OF_TREE	   = 2;
		CENTER_AS_GIVEN	   = 3;

		//The default. The polygon will be 100% opaque.
		DISABLE_BLENDING = 0;

		// Filter glass can be used to block rgb channels
		// like when looking through a cellophane paper
		// For example if the color of the polygon is (red==255,0,0)
		// Then when looking through this polygon the whole world will
		// be painted with red. The blending formula for DARK_FILTER_GLASS
		// is NEW_PIXEL=SRC*DEST  (SRC is the pixel of our polygon. DEST
		// is the pixel in the background and NEW_PIXEL is final result.
		// Example: We have a room with a window. We look outside through 
		//		the window. Lets examine the rendering process
		//		when rendering a specific pixel of the window.
		//		The computer takes a pixel from the window 
		//		(for example 0,0,64 == dark blue == 0.25, 0.25, 0.25 in [0-1] rgb scale)
		//		and another pixel from outside the room that is exactly on the
		//		line connecting between the eye (camera) and the pixel of the window
		//		for example lets say that this line hits a cloud so our second pixel
		//		is gray (rgb== 128,128,128 == 0.5, 0.5, 0.5 in [0-1] rgb scale) now
		//		lets calculate the final pixel that we will have on the window
		//		according to the function NEW_PIXEL=SRC*DEST == (0,0, 0.25)*(0.5, 0.5, 0.5)
		//		== 0*0.5, 0*0.5, 0.25*0.5= (0,0,0.125) == (0,0,32 in [0-255] scale) 
		//		== very dark blue.
		//		This blending formula is called DARK_... because the result pixel is
		//		darker or equal to the src pixel
		DARK_FILTER_GLASS =	49;//0x31

		//The blending formula for FILTER_GLASS is NEW_PIXEL=2*SRC*DEST
		//This formula is usually better than DARK_FILTER_GLASS since
		// the result pixel is less dark.
		FILTER_GLASS =	51;//0x33

		//The blending formula for OPAQUE_FILTER_GLASS is 
		// NEW_PIXEL=SRC*SRC + SRC*DEST. It is similar to FILTER_GLASS
		// It is called OPAQUE_... since it is a little bit more opaque than
		// FILTER_GLASS
		OPAQUE_FILTER_GLASS	= 67;//0x43

		// Create the effect of normal glass. Here is what happens when looking through
		// this glass: The light from bright objects easily penetrates the window
		// while the light from darker objects is reflected from the glass (in this case 
		// you get to see the bitmap of the window and not what is outside ...)
		// Using this type of glass you can control the level of translucency
		// Bright pixel in the bitmap will be totally opaque while dark pixel will
		// blend with the background. Make a bright bitmap if you want your window
		// to be more opaque. Make a dark bitmap if you want it to be more transparent.
		// Note this side effect, the view outside the window will always look brighter
		// than what it really is. This effect simulate our eye behavior. When we sit
		// in a dark room and we open a window we are overwhelmed by the light. Once we get outside,
		// we get used to it and it doesnt seem to be as bright as we felt before
		// Here is the blending formula for this window:
		// NEW_PIXEL= SRC(1-DEST)+DEST. Note that if DEST=(R,B,G) than 1-DEST is (1-R, 1-G,1-B)
		// when working in [0-1] scale.
		NORMAL_GLASS = 82;//0x52

		// It is the only glass
		// that make a real blending without decreasing or increasing the light.
		// It is also the only one who gives a total control on the level of
		// transparency, from being total opaque to being total transparent.
		// Bright pixel in the bitmap will be totally opaque while dark pixel will 
		// be transparent. Make a bright bitmap if you want your window
		// to be more opaque. Make a dark window if you want it to be more transparent.
		// The blending formula for this glass is
		// NEW_PIXEL=SRC*SRC+DEST*(1-SRC)
		CONTROL_GLASS = 68;//0x44

		// Has the side effect of making the outside look brighter
		// It is called transparent because the glass is a little bit
		// more transparent than the other types.
		// A dark bitmap (for the window) will make a very transparent glass
		// a bright bitmap will make a bright blend between the window and the outside.
		// Here is the blending formula:
		// NEW_PIXEL=DEST+SRC*DEST
		BRIGHT_TRANSPARENT_GLASS = 50;//0x32

		//Similar to BRIGHT_TRANSPARENT_GLASS only a little bit less transparent
		//Here is the blending formula:
		// NEW_PIXEL=DEST+SRC*SRC
		BRIGHT_TRANSLUCENT_GLASS = 66;//0x42

		//similar to BRIGHT_TRANSLUCENT_GLASS only that
		//the glass is more opaque. This glass can also be used to block color channels
		//like with the filter modes (FILTER_GLASS).
		//Here is the blending formula:
		// NEW_PIXEL=SRC+SRC*DEST
		BRIGHT_OPAQUE_GLASS	= 35;//0x23

		//This glass is special. It has the
		//simple blending formula NEW_PIXEL=SRC+DEST
		//Usually this type of blending is used for
		//simulating light because of its additive characteristic
		//If used as a window glass then we should use a dark bitmap
		//otherwise we will have a very bright saturated window.
		LIGHT_SOURCE_GLASS = 34;//0x22

		//This glass creates a special effect. When looking
		//through it, it inverts the world that we see.
		//The blending formula is:
		//NEW_PIXEL=SRC*(1-DEST).Note that if DEST=(R,B,G) than 1-DEST is (1-R, 1-G,1-B)
		// when working in [0-1] scale.
		INVERSE_GLASS = 81;//0x51


		ALL_PATCHES     = 1; //delete all the patches of a given polygon
		REGULAR_PATCHES = 2; //delete all the regular patches of a given polygon (patches that were mad using the function STATE_polygon_add_patch() and STATE_polygon_add_patch_easy() )
		SHADOW_PATCHES  = 4; //delete all the shadow patches of a given polygon (patches that were created in the process of creating shade


		LIGHT_SET		= 0;
		LIGHT_ADD		= 1;
		LIGHT_SUBTRACT	= 2;

		// Constant values for type_of_light (The values could be ored together e.g LIGHT_DIRECTIONAL | LIGHT_AMBIENT
		LIGHT_DIRECTIONAL				= 1;
		LIGHT_EFFECTED_BY_DISTANCE_LINEAR	= 2;
		LIGHT_EFFECTED_BY_DISTANCE_SQUARE	= 4;
		LIGHT_AMBIENT				= 8;
		LIGHT_DIFFUSE				= 16;
		LIGHT_SPECULAR				= 32;

		//In most cases you will probably use one of the two combinations below
		LIGHT_DEFAULT = (LIGHT_EFFECTED_BY_DISTANCE_LINEAR or LIGHT_AMBIENT or LIGHT_DIFFUSE or LIGHT_SPECULAR);
		LIGHT_DEFAULT_POINTED_LIGHT = (LIGHT_DIRECTIONAL or LIGHT_EFFECTED_BY_DISTANCE_LINEAR or LIGHT_AMBIENT or LIGHT_DIFFUSE or LIGHT_SPECULAR);

		BITMAP_LIST_FRONT       = 1;  //a list of bitmaps representing the view from the front
		BITMAP_LIST_FRONT_SIDED = 2;  //a list of bitmaps representing the view from the front-side (45 degrees) angle
		BITMAP_LIST_SIDE        = 3;  //a list of bitmaps representing the view from the side
		BITMAP_LIST_BACK_SIDED  = 4;  //a list of bitmaps representing the view from the back-side (135 degrees) angle
		BITMAP_LIST_BACK        = 5;  //a list of bitmaps representing the view from the back

		// Constants for the math API
		ON_PLANE 	      = 1;//on the same plane
		IN_BACK_OF_PLANE  = 2;
		IN_FRONT_OF_PLANE = 3;
		CUTS_PLANE     	= 4;
                STEREOSCOPIC_OFF = 0;

                SOUND_NO_LOOP = 0;
                SOUND_LOOP_NORMAL = 1;

                SOUND_PAUSED = 1;
                SOUND_RESUME_PLAYING = 0;

                SOUND_DISTANCE_DEFAULT = 1;

                NULL = 0;
type
	LpChar = PAnsiChar;

	function STATE_engine_render(hwnd: HWND; camera: DWORD) : Integer; stdcall;
	function STATE_engine_load_world(world_file_name: LpChar; world_directory_path: LpChar; bitmaps_directory_path: LpChar; world_mode: Integer) : Integer; stdcall;
	function STATE_engine_add_world(world_file_name: LpChar; world_directory_path: LpChar; bitmaps_directory_path: LpChar; var position_Array3_OfDouble) : DWORD; stdcall;
	function STATE_engine_is_engine_empty: Integer; stdcall;
	function STATE_engine_is_editor_mode: Integer; stdcall;
	function STATE_engine_set_resolution(width: Integer; height: Integer; bits_per_pixel: Integer) : Integer; stdcall;
	function STATE_engine_get_resolution(var width: Integer; var height: Integer; var bits_per_pixel: Integer) : Integer; stdcall;
	function STATE_engine_set_color_depth(bits_per_pixel: Integer) : Integer; stdcall;
	procedure STATE_engine_set_log_window_visible; stdcall;
	procedure STATE_engine_hide_log_window; stdcall;
	function STATE_engine_is_log_window_visible: Integer; stdcall;
	function STATE_engine_get_log_window_progress: Integer; stdcall;
	function STATE_engine_get_log_window_target: Integer; stdcall;
	procedure STATE_engine_set_log_window_progress(value: Integer) ; stdcall;
	procedure STATE_engine_set_log_window_target(value: Integer) ; stdcall;
	procedure STATE_engine_log_window_minimize; stdcall;
	procedure STATE_engine_log_window_output(text: LpChar) ; stdcall;
	procedure STATE_engine_log_window_set_text(new_text: LpChar) ; stdcall;
	procedure STATE_engine_log_window_set_title(new_caption: LpChar) ; stdcall;
	function STATE_engine_log_window_get_hwnd: HWND; stdcall;
	procedure STATE_engine_clear_STATE_log_files; stdcall;
	function STATE_engine_mark_polygon_at_point(x: Integer; y: Integer) : Integer; stdcall;
	function STATE_engine_2D_point_to_3D(x: Integer; y: Integer; var result_Array3_OfDouble; var selected_object_handle: DWORD; var selected_polygon_handle: DWORD) : Integer; stdcall;
	function STATE_engine_2D_point_to_3D_point_on_plane(x: Integer; y: Integer; var polygons_plane_Array4_OfDouble; var p3d_Array3_OfDouble) : Integer; stdcall;
	function STATE_engine_3D_point_to_2D(var p3D_Array3_OfDouble; var p2D_Array2_OfInt) : Integer; stdcall;
	procedure STATE_engine_set_picture_quality(quality: Integer) ; stdcall;
	function STATE_engine_get_picture_quality: Integer; stdcall;
	procedure STATE_engine_increase_picture_quality; stdcall;
	procedure STATE_engine_decrease_picture_quality; stdcall;
	function STATE_engine_set_automatic_quality_control(hwnd: HWND; camera_handle: DWORD) : Integer; stdcall;
	procedure STATE_engine_set_normal_rendering_mode; stdcall;
	procedure STATE_engine_set_color_fill_rendering_mode; stdcall;
	procedure STATE_engine_set_wire_frame_rendering_mode; stdcall;
	procedure STATE_engine_toggle_rendering_mode; stdcall;
	procedure STATE_engine_toggle_wire_frame_flag; stdcall;
	procedure STATE_engine_set_default_brightness; stdcall;
	procedure STATE_engine_increase_brightness; stdcall;
	procedure STATE_engine_decrease_brightness; stdcall;
	procedure STATE_engine_set_brightness(value: Integer) ; stdcall;
	function STATE_engine_get_brightness: Integer; stdcall;
	procedure STATE_engine_increase_atmospheric_effect_intensity; stdcall;
	procedure STATE_engine_decrease_atmospheric_effect_intensity; stdcall;
	procedure STATE_engine_set_default_atmospheric_effect_intensity; stdcall;
	function STATE_engine_get_atmospheric_effect_intensity: Double; stdcall;
	procedure STATE_engine_set_atmospheric_effect_intensity(value: Double) ; stdcall;
	procedure STATE_engine_toggle_atmospheric_effect; stdcall;
	procedure STATE_engine_set_atmospheric_effect(red: Integer; green: Integer; blue: Integer) ; stdcall;
	procedure STATE_engine_get_atmospheric_effect(var red: Integer; var green: Integer; var blue: Integer) ; stdcall;
	procedure STATE_engine_set_background_color(red: Integer; green: Integer; blue: Integer) ; stdcall;
	procedure STATE_engine_get_background_color(var red: Integer; var green: Integer; var blue: Integer) ; stdcall;
	procedure STATE_engine_toggle_automatic_perspective_correction; stdcall;
	procedure STATE_engine_toggle_perspective_correction_accuracy; stdcall;
	procedure STATE_engine_increase_far_objects_color_accuracy; stdcall;
	procedure STATE_engine_decrease_far_objects_color_accuracy; stdcall;
	procedure STATE_engine_set_default_far_objects_color_accuracy; stdcall;
	function STATE_engine_get_far_objects_color_accuracy: Integer; stdcall;
	procedure STATE_engine_set_far_objects_color_accuracy(value: Integer) ; stdcall;
	procedure STATE_engine_increase_culling_depth; stdcall;
	procedure STATE_engine_decrease_culling_depth; stdcall;
	procedure STATE_engine_set_default_culling_depth; stdcall;
	function STATE_engine_get_culling_depth: Integer; stdcall;
	procedure STATE_engine_set_culling_depth(value: Integer) ; stdcall;
	function STATE_engine_is_movement_possible(var start_location_Array3_OfDouble; var end_location_Array3_OfDouble; var intersected_polygon: DWORD; var intersection_Array3_OfDouble; var blocking_object: DWORD) : Integer; stdcall;
	function STATE_engine_is_movement_possible_camera_space(var start_location_Array3_OfDouble; var end_location_Array3_OfDouble; var intersected_polygon: DWORD; var intersection_Array3_OfDouble; var blocking_object: DWORD) : Integer; stdcall;
	function STATE_engine_get_number_of_collisions(var point1_Array3_OfDouble; var point2_Array3_OfDouble; var combined_normal_Array3_OfDouble) : Integer; stdcall;
	function STATE_engine_get_object_at_point_2D(x: Integer; y: Integer) : DWORD; stdcall;
	function STATE_engine_get_polygon_at_point_2D(x: Integer; y: Integer) : DWORD; stdcall;
	function STATE_engine_get_default_rendering_window_hwnd: HWND; stdcall;
	procedure STATE_engine_maximize_default_rendering_window; stdcall;
	procedure STATE_engine_minimize_default_rendering_window; stdcall;
	procedure STATE_engine_set_default_rendering_window_title(text: LpChar) ; stdcall;
	procedure STATE_engine_set_default_rendering_window_size(left_x: Integer; top_y: Integer; width: Integer; height: Integer) ; stdcall;
	function STATE_engine_reduce_polygons_count(accuracy: Double) : Integer; stdcall;
	function STATE_engine_add_polygon(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_engine_save(file_name: LpChar; group_to_save: DWORD; save_flags: Integer) : Integer; stdcall;
	procedure STATE_engine_copy_image_from_dc_to_screen; stdcall;
	procedure STATE_engine_bitblt; stdcall;
	function STATE_engine_render_on_bitmap(hwnd: HWND; camera_handle: DWORD) : HBITMAP; stdcall;
	function STATE_engine_render_on_dc(hwnd: HWND; camera_handle: DWORD) : HDC; stdcall;
	function STATE_engine_render_on_memCDC(hwnd: HWND; camera_handle: DWORD) : HDC; stdcall;
	function STATE_engine_3D_edge_to_2D(var p1_Array3_OfDouble; var p2_Array3_OfDouble; var p1_2D_Array2_OfInt; var p2_2D_Array2_OfInt) : Integer; stdcall;
	function STATE_engine_clip_edge(var p1_Array3_OfDouble; var p2_Array3_OfDouble; var clipped_p1_Array3_OfDouble; var clipped_p2_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_engine_set_group_to_render(grp_to_render_handle: DWORD) ; stdcall;
	function STATE_engine_get_number_of_loaded_bitmaps: Integer; stdcall;
	function STATE_engine_unload_unused_bitmaps: Integer; stdcall;
	procedure STATE_engine_unload_all_bitmaps; stdcall;
	function STATE_engine_translate_movement_on_screen_to_movement_in_world(var p3D_Array3_OfDouble; var result_p3D_Array3_OfDouble; delta_x: Integer; delta_y: Integer) : Integer; stdcall;
	function STATE_engine_translate_movement_on_screen_to_world(var p3D_Array3_OfDouble; var result_p3D_Array3_OfDouble; delta_x: Integer; delta_y: Integer) : Integer; stdcall;
	function STATE_engine_get_original_color_depth: Integer; stdcall;
	procedure STATE_engine_advance_objects_automatically(yes_no_flag: Integer) ; stdcall;
	procedure STATE_engine_advance_cameras_automatically(yes_no_flag: Integer) ; stdcall;
	function STATE_engine_use_zbuffer(yes_no_flag: Integer) : Integer; stdcall;
	function STATE_engine_is_zbuffer: Integer; stdcall;
	procedure STATE_engine_set_perspective_correction_accuracy(value: Double) ; stdcall;
	function STATE_engine_get_perspective_correction_accuracy: Double; stdcall;
	function STATE_engine_get_average_program_cycle_time: DWORD; stdcall;
	function STATE_engine_get_last_program_cycle_time: DWORD; stdcall;
	function STATE_engine_get_last_render_execution_time: DWORD; stdcall;
	function STATE_engine_get_average_render_execution_time: DWORD; stdcall;
	function STATE_engine_check_3d_hardware_support: Integer; stdcall;
	function STATE_engine_use_3D_accelerator_card(YES_or_NO: Integer) : Integer; stdcall;
	procedure STATE_engine_get_3D_accelerator_resolution(var width: Integer; var height: Integer) ; stdcall;
	function STATE_engine_is_3D_accelerator_card_used: Integer; stdcall;
	function STATE_engine_create_terrain_from_bitmap(bitmap_file_name: LpChar; level_of_optimization: Double; max_number_of_polygons: Integer; bitmap_to_wrap_over_handle: DWORD; tile_x: Integer; tile_y: Integer; var legend_ArrayNx3_OfByte; number_of_colors_in_legend: Integer; var dimensions_Array3_OfDouble; var number_of_polygons_in_group: Integer) : DWORD; stdcall;
	function STATE_engine_get_last_error: LpChar; stdcall;
	function STATE_engine_get_computer_speed_factor: Double; stdcall;
	procedure STATE_engine_set_speaker_mode(yes_no_flag: Integer) ; stdcall;
	procedure STATE_engine_create_shadow(entity_receiving_shadow: DWORD; entity_creating_shadow: DWORD; var light_src_Array3_OfDouble; serial_number: BYTE) ; stdcall;
	procedure STATE_engine_create_dynamic_shadow(entity_receiving_shadow: DWORD; entity_creating_shadow: DWORD; var light_src_Array3_OfDouble; serial_number: BYTE) ; stdcall;
	procedure STATE_engine_delete_dynamic_shadows; stdcall;
	procedure STATE_engine_set_maximum_rendering_time(max_duration_in_mili_seconds: Integer) ; stdcall;
	function STATE_engine_get_maximum_rendering_time: Integer; stdcall;
	procedure STATE_engine_set_minimum_rendering_time(min_duration_in_mili_seconds: Integer) ; stdcall;
	function STATE_engine_get_minimum_rendering_time: Integer; stdcall;
	procedure STATE_engine_set_thread_priority(thread_priority: Integer; class_priority: DWORD) ; stdcall;
	procedure STATE_engine_close; stdcall;
	function STATE_engine_get_logo: HBITMAP; stdcall;
	procedure STATE_engine_show_frames_per_second_rate(YES_or_NO: Integer) ; stdcall;
	procedure STATE_engine_render_on_top_of_previous_rendering(YES_or_NO: Integer) ; stdcall;
	function STATE_camera_is_camera(camera_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	function STATE_camera_get_first_camera: DWORD; stdcall;
	function STATE_camera_get_next_camera(camera_handle: DWORD) : DWORD; stdcall;
	function STATE_camera_get_using_name(camera_name: LpChar) : DWORD; stdcall;
	function STATE_camera_get_name(camera_handle: DWORD) : LpChar; stdcall;
	procedure STATE_camera_set_name(camera_handle: DWORD; name: LpChar) ; stdcall;
	procedure STATE_camera_set_distance_from_eye(camera_handle: DWORD; distance: Double) ; stdcall;
	function STATE_camera_get_distance_from_eye(camera_handle: DWORD) : Double; stdcall;
	function STATE_camera_create(camera_name: LpChar) : DWORD; stdcall;
	function STATE_camera_get_current: DWORD; stdcall;
	function STATE_camera_set_current(camera_handle: DWORD; hwnd: HWND) : Integer; stdcall;
	function STATE_camera_get_default_camera: DWORD; stdcall;
	procedure STATE_camera_save(camera_handle: DWORD; var save_buffer_ArrayC_OfDword) ; stdcall;
	function STATE_camera_recreate(camera_name: LpChar; var restore_buffer_ArrayC_OfDword) : DWORD; stdcall;
	procedure STATE_camera_set_values(camera_handle: DWORD; var values_data_ArrayC_OfDword) ; stdcall;
	function STATE_camera_get_width(camera_handle: DWORD) : Integer; stdcall;
	function STATE_camera_get_height(camera_handle: DWORD) : Integer; stdcall;
	procedure STATE_camera_get_direction(camera_handle: DWORD; var x: Double; var y: Double; var z: Double) ; stdcall;
	procedure STATE_camera_set_direction(camera_handle: DWORD; x: Double; y: Double; z: Double) ; stdcall;
	procedure STATE_camera_point_at(camera_handle: DWORD; x: Double; y: Double; z: Double) ; stdcall;
	function STATE_camera_point_at_2D(camera_handle: DWORD; x: Integer; y: Integer) : Integer; stdcall;
	procedure STATE_camera_set_location(camera_handle: DWORD; x: Double; y: Double; z: Double) ; stdcall;
	procedure STATE_camera_get_location(camera_handle: DWORD; var x: Double; var y: Double; var z: Double) ; stdcall;
	function STATE_camera_set_axis_system(camera_handle: DWORD; var X_Array3_OfDouble; var Y_Array3_OfDouble; var Z_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_camera_get_axis_system(camera_handle: DWORD; var X_Array3_OfDouble; var Y_Array3_OfDouble; var Z_Array3_OfDouble) ; stdcall;
	function STATE_camera_set_tilt(camera_handle: DWORD; angle: Double) : Double; stdcall;
	function STATE_camera_get_tilt(camera_handle: DWORD) : Double; stdcall;
	function STATE_camera_modify_tilt(camera_handle: DWORD; change: Double) : Double; stdcall;
	procedure STATE_camera_move(camera_handle: DWORD; space_flag: Integer; x: Double; y: Double; z: Double) ; stdcall;
	function STATE_camera_set_focus(camera_handle: DWORD; focus_distance: Double) : Double; stdcall;
	function STATE_camera_modify_focus(camera_handle: DWORD; change_in_focus_distance: Double) : Double; stdcall;
	function STATE_camera_set_zoom(camera_handle: DWORD; field_of_view_angle: Double) : Double; stdcall;
	function STATE_camera_get_zoom(camera_handle: DWORD) : Double; stdcall;
	function STATE_camera_modify_zoom(camera_handle: DWORD; field_of_view_change: Double) : Double; stdcall;
	function STATE_camera_set_head_angle(camera_handle: DWORD; head_angle: Double) : Double; stdcall;
	function STATE_camera_get_head_angle(camera_handle: DWORD) : Double; stdcall;
	function STATE_camera_modify_head_angle(camera_handle: DWORD; head_angle: Double) : Double; stdcall;
	function STATE_camera_set_bank(camera_handle: DWORD; angle: Double) : Double; stdcall;
	function STATE_camera_get_bank(camera_handle: DWORD) : Double; stdcall;
	function STATE_camera_modify_bank(camera_handle: DWORD; change: Double) : Double; stdcall;
	procedure STATE_camera_rotate_x(camera_handle: DWORD; degrees: Double; space_flag: Integer) ; stdcall;
	procedure STATE_camera_rotate_y(camera_handle: DWORD; degrees: Double; space_flag: Integer) ; stdcall;
	procedure STATE_camera_rotate_z(camera_handle: DWORD; degrees: Double; space_flag: Integer) ; stdcall;
	procedure STATE_camera_rotate_x_radians(camera_handle: DWORD; radians: Double; space_flag: Integer) ; stdcall;
	procedure STATE_camera_rotate_y_radians(camera_handle: DWORD; radians: Double; space_flag: Integer) ; stdcall;
	procedure STATE_camera_rotate_z_radians(camera_handle: DWORD; radians: Double; space_flag: Integer) ; stdcall;
	function STATE_camera_convert_point_to_world_space(camera_handle: DWORD; var camera_space_point_Array3_OfDouble; var result_Array3_OfDouble) : Integer; stdcall;
	function STATE_camera_convert_point_to_camera_space(camera_handle: DWORD; var world_space_point_Array3_OfDouble; var result_Array3_OfDouble) : Integer; stdcall;
	function STATE_camera_delete(camera_handle: DWORD) : Integer; stdcall;
	procedure STATE_camera_delete_all; stdcall;
	function STATE_camera_get_track_name(camera_handle: DWORD) : LpChar; stdcall;
	function STATE_camera_get_track_handle(camera_handle: DWORD) : DWORD; stdcall;
	function STATE_camera_set_track(camera_handle: DWORD; track_handle: DWORD) : Integer; stdcall;
	function STATE_camera_get_track_offset(camera_handle: DWORD; var offset_Array3_OfDouble) : Integer; stdcall;
	function STATE_camera_set_track_offset(camera_handle: DWORD; var offset_Array3_OfDouble) : Integer; stdcall;
	function STATE_camera_get_next_point_on_track(camera_handle: DWORD) : Integer; stdcall;
	function STATE_camera_set_next_point_on_track(camera_handle: DWORD; point_index: Integer) : Integer; stdcall;
	procedure STATE_camera_set_object_to_chase(camera_handle: DWORD; object_to_chase_handle: DWORD) ; stdcall;
	function STATE_camera_get_chased_object(camera_handle: DWORD) : DWORD; stdcall;
	procedure STATE_camera_set_camera_to_chase(camera_handle: DWORD; camera_to_chase_handle: DWORD) ; stdcall;
	function STATE_camera_get_chased_camera(camera_handle: DWORD) : DWORD; stdcall;
	procedure STATE_camera_set_group_to_chase(camera_handle: DWORD; group_to_chase_handle: DWORD) ; stdcall;
	function STATE_camera_get_chased_group(camera_handle: DWORD) : DWORD; stdcall;
	function STATE_camera_get_chase_offset(camera_handle: DWORD; var offset_Array3_OfDouble) : Integer; stdcall;
	function STATE_camera_set_chase_offset(camera_handle: DWORD; var offset_Array3_OfDouble) : Integer; stdcall;
	function STATE_camera_get_chase_softness(camera_handle: DWORD) : Double; stdcall;
	procedure STATE_camera_set_chase_softness(camera_handle: DWORD; softness: Double) ; stdcall;
	function STATE_camera_get_chase_type(camera_handle: DWORD) : Integer; stdcall;
	procedure STATE_camera_set_chase_type(camera_handle: DWORD; chase_type: Integer) ; stdcall;
	procedure STATE_camera_set_chase_distance(camera_handle: DWORD; chase_distance: Double) ; stdcall;
	function STATE_camera_get_chase_distance(camera_handle: DWORD) : Double; stdcall;
	procedure STATE_camera_advance(camera_handle: DWORD) ; stdcall;
	procedure STATE_camera_get_speed(camera_handle: DWORD; var speed_Array3_OfDouble) ; stdcall;
	procedure STATE_camera_set_speed(camera_handle: DWORD; var speed_Array3_OfDouble) ; stdcall;
	function STATE_camera_get_absolute_speed(camera_handle: DWORD) : Double; stdcall;
	procedure STATE_camera_set_absolute_speed(camera_handle: DWORD; speed: Double) ; stdcall;
	procedure STATE_camera_get_force(camera_handle: DWORD; var force_Array3_OfDouble) ; stdcall;
	procedure STATE_camera_set_force(camera_handle: DWORD; var force_Array3_OfDouble) ; stdcall;
	procedure STATE_camera_set_max_speed(camera_handle: DWORD; value: Double) ; stdcall;
	function STATE_camera_get_max_speed(camera_handle: DWORD) : Double; stdcall;
	procedure STATE_camera_set_friction(camera_handle: DWORD; value: Double) ; stdcall;
	function STATE_camera_get_friction(camera_handle: DWORD) : Double; stdcall;
	procedure STATE_camera_set_elasticity(camera_handle: DWORD; value: Double) ; stdcall;
	function STATE_camera_get_elasticity(camera_handle: DWORD) : Double; stdcall;
	function STATE_camera_get_location_to_fit_rectangle(camera_handle: DWORD; left_x: Integer; top_y: Integer; right_x: Integer; bottom_y: Integer; var new_location_Array3_OfDouble) : Integer; stdcall;
	function STATE_camera_move_toward_point_2D(camera_handle: DWORD; x: Integer; y: Integer; factor: Double) : Integer; stdcall;
	procedure STATE_camera_advance_all; stdcall;
	procedure STATE_camera_set_name_to_chase(camera_handle: DWORD; name_to_chase: LpChar) ; stdcall;
	function STATE_camera_get_name_to_chase(camera_handle: DWORD) : LpChar; stdcall;
	procedure STATE_camera_set_save_flag(camera_handle: DWORD; yes_no_flag: Integer) ; stdcall;
	function STATE_camera_get_save_flag(camera_handle: DWORD) : Integer; stdcall;
	procedure STATE_camera_set_perspective_projection(camera_handle: DWORD) ; stdcall;
	procedure STATE_camera_set_parallel_projection(camera_handle: DWORD; width: Integer; heigh: Integer) ; stdcall;
	function STATE_camera_is_perspective_projection(camera_handle: DWORD) : Integer; stdcall;
	function STATE_camera_get_parallel_projection_width(camera_handle: DWORD) : Integer; stdcall;
	function STATE_camera_get_parallel_projection_height(camera_handle: DWORD) : Integer; stdcall;
	function STATE_object_is_object(object_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	function STATE_object_is_movement_possible(object_handle : DWORD; var start_location_Array3_OfDouble; var end_location_Array3_OfDouble; var intersected_polygon: DWORD; var intersection_Array3_OfDouble; var blocking_object: DWORD) : Integer; stdcall;
	function STATE_object_get_object_using_name(object_name: LpChar) : DWORD; stdcall;
	function STATE_object_get_name(object_handle: DWORD) : LpChar; stdcall;
	function STATE_object_get_type_name(object_handle: DWORD) : LpChar; stdcall;
	function STATE_object_set_name(object_handle: DWORD; new_name: LpChar) : Integer; stdcall;
	function STATE_object_set_type_name(object_handle: DWORD; new_name: LpChar) : Integer; stdcall;
	function STATE_object_get_object_type_number(object_handle: DWORD) : Integer; stdcall;
	procedure STATE_object_set_object_type_number(object_handle: DWORD; object_type_number: Integer) ; stdcall;
	function STATE_object_get_control_type_number(object_handle: DWORD) : Integer; stdcall;
	procedure STATE_object_set_control_type_number(object_handle: DWORD; control_type_number: Integer) ; stdcall;
	function STATE_object_get_track_name(object_handle: DWORD) : LpChar; stdcall;
	function STATE_object_get_track_handle(object_handle: DWORD) : DWORD; stdcall;
	function STATE_object_get_first_object: DWORD; stdcall;
	function STATE_object_get_next_object(object_handle: DWORD) : DWORD; stdcall;
	procedure STATE_object_set_location(object_handle: DWORD; x: Double; y: Double; z: Double) ; stdcall;
	procedure STATE_object_get_location(object_handle: DWORD; var x: Double; var y: Double; var z: Double) ; stdcall;
	procedure STATE_object_move(object_handle: DWORD; space_flag: Integer; x: Double; y: Double; z: Double) ; stdcall;
	procedure STATE_object_set_direction(object_handle: DWORD; x: Double; y: Double; z: Double) ; stdcall;
	procedure STATE_object_get_direction(object_handle: DWORD; var x: Double; var y: Double; var z: Double) ; stdcall;
	function STATE_object_set_axis_system(object_handle: DWORD; var x_Array3_OfDouble; var y_Array3_OfDouble; var z_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_object_get_axis_system(object_handle: DWORD; var x_Array3_OfDouble; var y_Array3_OfDouble; var z_Array3_OfDouble) ; stdcall;
	procedure STATE_object_get_x_axis(object_handle: DWORD; var x_axis_Array3_OfDouble) ; stdcall;
	procedure STATE_object_get_y_axis(object_handle: DWORD; var y_axis_Array3_OfDouble) ; stdcall;
	procedure STATE_object_get_z_axis(object_handle: DWORD; var z_axis_Array3_OfDouble) ; stdcall;
	procedure STATE_object_rotate_x(object_handle: DWORD; degrees: Double; space_flag: Integer) ; stdcall;
	procedure STATE_object_rotate_y(object_handle: DWORD; degrees: Double; space_flag: Integer) ; stdcall;
	procedure STATE_object_rotate_z(object_handle: DWORD; degrees: Double; space_flag: Integer) ; stdcall;
	procedure STATE_object_rotate_x_radians(object_handle: DWORD; radians: Double; space_flag: Integer) ; stdcall;
	procedure STATE_object_rotate_y_radians(object_handle: DWORD; radians: Double; space_flag: Integer) ; stdcall;
	procedure STATE_object_rotate_z_radians(object_handle: DWORD; radians: Double; space_flag: Integer) ; stdcall;
	function STATE_object_get_cos_pitch(object_handle: DWORD) : Double; stdcall;
	function STATE_object_get_cos_bank(object_handle: DWORD) : Double; stdcall;
	function STATE_object_get_cos_head(object_handle: DWORD) : Double; stdcall;
	procedure STATE_object_get_total_move_mat(object_handle: DWORD; var object_matrix_Array4x4_OfDouble) ; stdcall;
	function STATE_object_get_animation(object_handle: DWORD) : DWORD; stdcall;
	function STATE_object_replace_animation_using_names(object_handle: DWORD; old_animation_name : LpChar; new_animation_name: LpChar) : Integer; stdcall;
	function STATE_object_replace_animation(object_handle: DWORD; old_animation_handle : DWORD; new_animation_handle: DWORD) : Integer; stdcall;
	function STATE_object_convert_point_to_world_space(object_handle: DWORD; var object_space_point_Array3_OfDouble; var result_Array3_OfDouble) : Integer; stdcall;
	function STATE_object_convert_point_to_object_space(object_handle: DWORD; var world_space_point_Array3_OfDouble; var result_Array3_OfDouble) : Integer; stdcall;
	function STATE_object_set_track(object_handle: DWORD; track_handle: DWORD) : Integer; stdcall;
	function STATE_object_get_track_offset(object_handle: DWORD; var offset_Array3_OfDouble) : Integer; stdcall;
	function STATE_object_set_track_offset(object_handle: DWORD; var offset_Array3_OfDouble) : Integer; stdcall;
	function STATE_object_get_next_point_on_track(object_handle: DWORD) : Integer; stdcall;
	function STATE_object_set_next_point_on_track(object_handle: DWORD; point_index: Integer) : Integer; stdcall;
	procedure STATE_object_set_object_to_chase(object_handle: DWORD; object_to_chase_handle: DWORD) ; stdcall;
	function STATE_object_get_chased_object(object_handle: DWORD) : DWORD; stdcall;
	procedure STATE_object_set_camera_to_chase(object_handle: DWORD; camera_to_chase_handle: DWORD) ; stdcall;
	function STATE_object_get_chased_camera(object_handle: DWORD) : DWORD; stdcall;
	procedure STATE_object_set_group_to_chase(object_handle: DWORD; group_to_chase_handle: DWORD) ; stdcall;
	function STATE_object_get_chased_group(object_handle: DWORD) : DWORD; stdcall;
	function STATE_object_get_chase_offset(object_handle: DWORD; var offset_Array3_OfDouble) : Integer; stdcall;
	function STATE_object_set_chase_offset(object_handle: DWORD; var offset_Array3_OfDouble) : Integer; stdcall;
	function STATE_object_get_chase_softness(object_handle: DWORD) : Double; stdcall;
	procedure STATE_object_set_chase_softness(object_handle: DWORD; softness: Double) ; stdcall;
	function STATE_object_get_chase_type(object_handle: DWORD) : Integer; stdcall;
	procedure STATE_object_set_chase_type(object_handle: DWORD; chase_type: Integer) ; stdcall;
//	procedure STATE_object_set_falling_from_track(object_handle: DWORD; double	//height_above_ground: ; fall_through_dynamic_objects: Integer) ; stdcall;
	procedure STATE_object_unset_falling_from_track(object_handle: DWORD) ; stdcall;
//	procedure STATE_object_get_falling_from_track_params(object_handle: DWORD; var set_flag: Integer; double	*height_above_ground: ; var fall_through_dynamic_objects: Integer) ; stdcall;
	procedure STATE_object_get_location_on_track_before_falling(object_handle: DWORD; var location_Array3_OfDouble) ; stdcall;
	procedure STATE_object_get_speed(object_handle: DWORD; var speed_Array3_OfDouble) ; stdcall;
	procedure STATE_object_set_speed(object_handle: DWORD; var speed_Array3_OfDouble) ; stdcall;
	function STATE_object_get_absolute_speed(object_handle: DWORD) : Double; stdcall;
	procedure STATE_object_set_absolute_speed(object_handle: DWORD; speed: Double) ; stdcall;
	procedure STATE_object_set_force(object_handle: DWORD; var force_Array3_OfDouble) ; stdcall;
	procedure STATE_object_get_force(object_handle: DWORD; var force_Array3_OfDouble) ; stdcall;
	procedure STATE_object_set_max_speed(object_handle: DWORD; value: Double) ; stdcall;
	function STATE_object_get_max_speed(object_handle: DWORD) : Double; stdcall;
	procedure STATE_object_set_friction(object_handle: DWORD; value: Double) ; stdcall;
	function STATE_object_get_friction(object_handle: DWORD) : Double; stdcall;
	procedure STATE_object_set_elasticity(object_handle: DWORD; value: Double) ; stdcall;
	function STATE_object_get_elasticity(object_handle: DWORD) : Double; stdcall;
	procedure STATE_object_advance_all; stdcall;
	procedure STATE_object_advance(object_handle: DWORD) ; stdcall;
	procedure STATE_object_reset_distance_counter(object_handle: DWORD) ; stdcall;
	function STATE_object_get_distance_counter(object_handle: DWORD) : Double; stdcall;
	procedure STATE_object_get_bounding_box(object_handle: DWORD; var box_Array2x3_OfDouble) ; stdcall;
	function STATE_object_duplicate(object_handle: DWORD; duplicate_polygons_flag: Integer) : DWORD; stdcall;
	procedure STATE_object_delete(object_handle: DWORD) ; stdcall;
	procedure STATE_object_set_event(object_handle: DWORD; time_in_milliseconds: Integer; event: Integer) ; stdcall;
	procedure STATE_object_set_event_on_animation_frame(object_handle: DWORD; polygon_handle: DWORD; animation_frame: Integer; event: Integer) ; stdcall;
	procedure STATE_object_disable(object_handle: DWORD) ; stdcall;
	procedure STATE_object_enable(object_handle: DWORD) ; stdcall;
	function STATE_object_is_enabled(object_handle: DWORD) : Integer; stdcall;
	procedure STATE_object_set_speed_units(speed_units_system: Integer) ; stdcall;
	function STATE_object_get_speed_units: Integer; stdcall;
	function STATE_object_get_polygon(object_handle: DWORD; polygons_name: LpChar) : DWORD; stdcall;
	function STATE_object_is_polygon_part_of(object_handle: DWORD; polygon_handle: DWORD) : Integer; stdcall;
	function STATE_object_get_number_of_polygons(object_handle: DWORD) : Integer; stdcall;
	procedure STATE_object_get_all_polygons(object_handle: DWORD; var polygons_array_ArrayN_OfDword) ; stdcall;
	procedure STATE_object_set_chase_distance(object_handle: DWORD; chase_distance: Double) ; stdcall;
	function STATE_object_get_chase_distance(object_handle: DWORD) : Double; stdcall;
	procedure STATE_object_make_non_collisional(object_handle: DWORD) ; stdcall;
	procedure STATE_object_make_collisional(object_handle: DWORD) ; stdcall;
	function STATE_object_is_collisional(object_handle: DWORD) : Integer; stdcall;
	procedure STATE_object_cancel_collision_test_for_chase_physics(object_handle: DWORD) ; stdcall;
	procedure STATE_object_enable_collision_test_for_chase_physics(object_handle: DWORD) ; stdcall;
	function STATE_object_is_collision_test_for_chase_physics(object_handle: DWORD) : Integer; stdcall;
	procedure STATE_object_set_physics_rotation(object_handle: DWORD; rotation_space : Integer; rotate_around_x_axis: Double; rotate_around_y_axis: Double; rotate_around_z_axis: Double) ; stdcall;
	function STATE_object_get_physics_rotation(object_handle: DWORD; var rotation_xyz_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_object_set_rotation_center(object_handle: DWORD; var center_Array3_OfDouble) ; stdcall;
	procedure STATE_object_get_rotation_center(object_handle: DWORD; var center_Array3_OfDouble) ; stdcall;
	procedure STATE_object_advance_automatically(object_handle: DWORD; yes_no_flag: Integer) ; stdcall;
	function STATE_object_set_father_object(object_handle: DWORD; father_object: DWORD) : Integer; stdcall;
	function STATE_object_get_father_object(object_handle: DWORD) : DWORD; stdcall;
	function STATE_object_is_objectA_included_in_objectB(objectA_handle: DWORD; objectB_handle: DWORD) : Integer; stdcall;
	function STATE_object_get_first_son(object_handle: DWORD) : DWORD; stdcall;
	function STATE_object_get_next_son(object_handle: DWORD; son_handle: DWORD) : DWORD; stdcall;
	function STATE_object_get_first_direct_son(object_handle: DWORD) : DWORD; stdcall;
	function STATE_object_get_next_direct_son(object_handle: DWORD; son_handle: DWORD) : DWORD; stdcall;
	procedure STATE_object_move_including_sons(top_object_handle: DWORD; space_flag: Integer; x: Double; y: Double; z: Double) ; stdcall;
	function STATE_object_get_center_of_tree(top_object_handle: DWORD; var center_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_object_set_location_of_tree(top_object_handle: DWORD; var new_location_Array3_OfDouble; center_flag: Integer) ; stdcall;
	procedure STATE_object_rotate_including_sons(top_object_handle: DWORD; degrees: Double; axis: Integer; space_flag: Integer; center_flag: Integer; var center_Array3_OfDouble) ; stdcall;
	procedure STATE_object_remove_light(object_handle: DWORD) ; stdcall;
	procedure STATE_object_set_bitmap(object_handle: DWORD; bitmap_handle: DWORD) ; stdcall;
	function STATE_object_create(name: LpChar) : DWORD; stdcall;
	function STATE_object_create_from_file(file_name: LpChar) : DWORD; stdcall;
	function STATE_object_get_3D_animation(object_handle: DWORD) : DWORD; stdcall;
	function STATE_object_set_3D_animation(object_handle: DWORD; animation3d_handle: DWORD) : Integer; stdcall;
	function STATE_object_set_3D_sequence(object_handle: DWORD; sequence3d_handle: DWORD; transition_period: Integer) : Integer; stdcall;
	function STATE_object_get_3D_sequence(object_handle: DWORD) : DWORD; stdcall;
	procedure STATE_object_replace_3D_sequence_when_finished(object_handle: DWORD; new_sequence3d_handle: DWORD; transition_period: Integer) ; stdcall;
	procedure STATE_object_set_scale(object_handle: DWORD; var scale_Array3_OfDouble) ; stdcall;
	procedure STATE_object_get_scale(object_handle: DWORD; var scale_Array3_OfDouble) ; stdcall;
	function STATE_object_get_group_handle(object_handle: DWORD) : DWORD; stdcall;
	procedure STATE_object_set_light(object_handle: DWORD; var rgb_Array3_OfByte) ; stdcall;
	function STATE_object_add_polygon(object_handle: DWORD; polygon_handle: DWORD) : Integer; stdcall;
	function STATE_object_create_lightmap(object_handle: DWORD; max_bm_side: Integer; min_lightmap_size: Integer; sample_rate: Double; force_ray_tracing: Integer; bitmap_number: Integer) : Integer; stdcall;
	function STATE_polygon_is_polygon(polygon_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	function STATE_polygon_get_handle_using_name(polygon_name: LpChar) : DWORD; stdcall;
	function STATE_polygon_set_name(poly_handle: DWORD; polygon_name: LpChar) : Integer; stdcall;
	function STATE_polygon_get_name(poly_handle: DWORD) : LpChar; stdcall;
	function STATE_polygon_get_handle_using_id_num(poly_id_num: Integer) : DWORD; stdcall;
	function STATE_polygon_get_first_polygon: DWORD; stdcall;
	function STATE_polygon_get_next(polygon_handle: DWORD) : DWORD; stdcall;
	procedure STATE_polygon_get_plane(polygon_handle: DWORD; var plane_Array4_OfDouble) ; stdcall;
	procedure STATE_polygon_set_color_fill(polygon_handle: DWORD; red: Integer; green: Integer; blue: Integer) ; stdcall;
	function STATE_polygon_set_bitmap_fill(polygon_handle: DWORD; bitmap_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_get_bitmap_name(polygon_handle: DWORD) : LpChar; stdcall;
	function STATE_polygon_get_bitmap_handle(polygon_handle: DWORD) : DWORD; stdcall;
	procedure STATE_polygon_get_color(polygon_handle: DWORD; var red: Integer; var green: Integer; var blue: Integer) ; stdcall;
	function STATE_polygon_get_transparent_rgb(polygon_handle: DWORD; var red: Integer; var green: Integer; var blue: Integer) : Integer; stdcall;
	function STATE_polygon_get_transparent_index(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_is_rotated(polygon_handle: DWORD) : Integer; stdcall;
	procedure STATE_polygon_set_rotated(polygon_handle: DWORD; yes_no_flag: Integer) ; stdcall;
	function STATE_polygon_set_light_diminution(polygon_handle: DWORD; value: Double) : Integer; stdcall;
	function STATE_polygon_get_light_diminution(polygon_handle: DWORD) : Double; stdcall;
	function STATE_polygon_is_uniform_brightness(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_get_brightness(polygon_handle: DWORD) : Double; stdcall;
	function STATE_polygon_set_brightness(polygon_handle: DWORD; value: Integer) : Integer; stdcall;
	function STATE_polygon_get_num_of_points(polygon_handle: DWORD) : Integer; stdcall;
	procedure STATE_polygon_delete(polygon_handle: DWORD) ; stdcall;
	procedure STATE_polygon_delete_point(polygon_handle: DWORD; point_handle: DWORD) ; stdcall;
	function STATE_polygon_is_valid(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_is_convex(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_are_all_points_on_one_plane(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_are_bitmap_x_cords_ok(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_are_bitmap_y_cords_ok(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_count_redundant_points(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_remove_redundant_points(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_get_first_point(polygon_handle: DWORD) : DWORD; stdcall;
	function STATE_polygon_create: DWORD; stdcall;
	function STATE_polygon_add_point(polygon_handle: DWORD; var xyz_bmX_bmY_brightness_Array6_OfDouble) : DWORD; stdcall;
	function STATE_polygon_add_point_to_head(polygon_handle: DWORD; var xyz_bmX_bmY_brightness_Array6_OfDouble) : DWORD; stdcall;
	procedure STATE_polygon_rotate_bitmap(polygon_handle: DWORD) ; stdcall;
	procedure STATE_polygon_set_bitmap_rotation(polygon_handle: DWORD; rotation_count: Integer) ; stdcall;
	procedure STATE_polygon_mirror_horizontal_bitmap(polygon_handle: DWORD) ; stdcall;
	procedure STATE_polygon_mirror_vertical_bitmap(polygon_handle: DWORD) ; stdcall;
	procedure STATE_polygon_rotate_x(polygon_handle: DWORD; degrees: Double) ; stdcall;
	procedure STATE_polygon_rotate_y(polygon_handle: DWORD; degrees: Double) ; stdcall;
	procedure STATE_polygon_rotate_z(polygon_handle: DWORD; degrees: Double) ; stdcall;
	procedure STATE_polygon_rotate(polygon_handle: DWORD; var trans_mat_Array3x3_OfDouble) ; stdcall;
	procedure STATE_polygon_move(polygon_handle: DWORD; var step_Array3_OfDouble) ; stdcall;
	procedure STATE_polygon_set_location(polygon_handle: DWORD; var location_Array3_OfDouble) ; stdcall;
	procedure STATE_polygon_get_location(polygon_handle: DWORD; var location_Array3_OfDouble) ; stdcall;
	procedure STATE_polygon_scale(polygon_handle: DWORD; scale_x: Double; scale_y: Double; scale_z: Double) ; stdcall;
	procedure STATE_polygon_flip_visible_side(polygon_handle: DWORD) ; stdcall;
	function STATE_polygon_join(polygon1_handle: DWORD; polygon2_handle: DWORD) : DWORD; stdcall;
	function STATE_polygon_match_bitmap_cords(source_polygon_handle: DWORD; target_polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_duplicate(polygon_handle: DWORD) : DWORD; stdcall;
	function STATE_polygon_rotate_to_match_polygon(polygon_handle: DWORD; reference_polygon_handle: DWORD) : Integer; stdcall;
	procedure STATE_polygon_move_to_match_point(polygon_handle: DWORD; point_belongs_to_polygon: DWORD; point_to_match: DWORD) ; stdcall;
	function STATE_polygon_get_closest_point(polygon_handle: DWORD; var p3d_Array3_OfDouble) : DWORD; stdcall;
	procedure STATE_polygon_set_group(polygon_handle: DWORD; group_handle: DWORD) ; stdcall;
	function STATE_polygon_get_group(polygon_handle: DWORD) : DWORD; stdcall;
	function STATE_polygon_is_in_group(polygon_handle: DWORD; group_handle: DWORD) : Integer; stdcall;
	procedure STATE_polygon_set_orientation(polygon_handle: DWORD; orientation_value: Integer) ; stdcall;
	function STATE_polygon_get_orientation(polygon_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_is_point_inside_polygon(polygon_handle: DWORD; var pnt_Array3_OfDouble) : Integer; stdcall;
	function STATE_polygon_is_point_inside_polygon_concave(polygon_handle: DWORD; var pnt_Array3_OfDouble) : Integer; stdcall;
	function STATE_polygon_set_animation(polygon_handle: DWORD; animation_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_get_animation(polygon_handle: DWORD) : DWORD; stdcall;
	procedure STATE_polygon_set_animation_frame(polygon_handle: DWORD; animation_frame: Integer) ; stdcall;
	function STATE_polygon_get_animation_frame(polygon_handle: DWORD) : Integer; stdcall;
	procedure STATE_polygon_get_center(polygon_handle: DWORD; var center_Array3_OfDouble) ; stdcall;
	procedure STATE_polygon_set_release_save_flag(polygon_handle: DWORD; YES_or_NO: Integer) ; stdcall;
	procedure STATE_polygon_disable(polygon_handle: DWORD) ; stdcall;
	procedure STATE_polygon_enable(polygon_handle: DWORD) ; stdcall;
	function STATE_polygon_is_disabled(polygon_handle: DWORD) : Integer; stdcall;
	procedure STATE_polygon_make_non_collisional(polygon_handle: DWORD) ; stdcall;
	procedure STATE_polygon_make_collisional(polygon_handle: DWORD) ; stdcall;
	function STATE_polygon_is_collisional(polygon_handle: DWORD) : Integer; stdcall;
	procedure STATE_polygon_set_translucent(polygon_handle: DWORD; glass_type: BYTE) ; stdcall;
	function STATE_polygon_get_translucent(polygon_handle: DWORD) : BYTE; stdcall;
	procedure STATE_polygon_add_patch(polygon_handle: DWORD; patch_polygon_handle: DWORD) ; stdcall;
	function STATE_polygon_add_patch_easy(father_polygon: DWORD; var center_Array3_OfDouble; radius: Double; var direction_Array3_OfDouble; bitmap_handle: DWORD; var rgb_Array3_OfInt) : DWORD; stdcall;
	procedure STATE_polygon_delete_patches(polygon_handle: DWORD; type_of_patches_to_delete_or_serial_number: Integer) ; stdcall;
	function STATE_polygon_check_intersection_with_line_segment(polygon_handle: DWORD; var P1_Array3_OfDouble; var P2_Array3_OfDouble; var intersection_Array3_OfDouble) : Integer; stdcall;
	function STATE_polygon_check_intersection_with_another_polygon(polygon1: DWORD; polygon2: DWORD; var intersection_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_polygon_set_ambient(polygon_handle: DWORD; value: Integer) ; stdcall;
	function STATE_polygon_get_ambient(polygon_handle: DWORD) : Integer; stdcall;
	procedure STATE_polygon_set_diffuse(polygon_handle: DWORD; value: Integer) ; stdcall;
	function STATE_polygon_get_diffuse(polygon_handle: DWORD) : Integer; stdcall;
	procedure STATE_polygon_set_specular(polygon_handle: DWORD; value: Integer) ; stdcall;
	function STATE_polygon_get_specular(polygon_handle: DWORD) : Integer; stdcall;
	procedure STATE_polygon_set_specular_shining(polygon_handle: DWORD; value: BYTE) ; stdcall;
	function STATE_polygon_get_specular_shining(polygon_handle: DWORD) : BYTE; stdcall;
	procedure STATE_polygon_remove_light(polygon_handle: DWORD) ; stdcall;
	function STATE_polygon_wrap_a_bitmap_fixed(polygon_handle: DWORD; bitmap_handle: DWORD; repeat_x: Integer; repeat_y: Integer; var locationXY_to_get_bitmap_top_left_corner_Array2_OfDouble; var locationXY_to_get_bitmap_bottom_right_corner_Array2_OfDouble) : Integer; stdcall;
	procedure STATE_polygon_set_light(polygon_handle: DWORD; var rgb_Array3_OfByte) ; stdcall;
	function STATE_polygon_split(polygon_to_split: DWORD; var split_plane_Array4_OfDouble; var front_piece: DWORD; var back_piece: DWORD) : Integer; stdcall;
	function STATE_polygon_set_second_bitmap(polygon_handle: DWORD; texture_handle: DWORD) : Integer; stdcall;
	function STATE_polygon_create_lightmap(polygon_handle: DWORD; max_bm_side: Integer; min_lightmap_size: Integer; sample_rate: Double; force_ray_tracing: Integer; bitmap_number: Integer) : DWORD; stdcall;
	function STATE_point_is_point(point_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	function STATE_point_get_next_point(point_handle: DWORD) : DWORD; stdcall;
	procedure STATE_point_get_xyz(point_handle: DWORD; var xyz_Array3_OfDouble) ; stdcall;
	procedure STATE_point_set_xyz(point_handle: DWORD; var xyz_Array3_OfDouble) ; stdcall;
	procedure STATE_point_get_bitmap_xy(point_handle: DWORD; var xy_Array2_OfDouble) ; stdcall;
	procedure STATE_point_set_bitmap_xy(point_handle: DWORD; owner_polygon_handle : DWORD; var xy_Array2_OfDouble) ; stdcall;
	procedure STATE_point_get_rgb(point_handle: DWORD; var rgb_Array3_OfByte) ; stdcall;
	procedure STATE_point_set_rgb(point_handle: DWORD; father_polygon: DWORD; var rgb_Array3_OfByte) ; stdcall;
	function STATE_point_get_brightness(point_handle: DWORD) : Double; stdcall;
	procedure STATE_point_set_brightness(point_handle: DWORD; value: Double) ; stdcall;
	function STATE_group_is_group(group_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	function STATE_group_create(name: LpChar) : DWORD; stdcall;
	function STATE_group_get_first_group: DWORD; stdcall;
	function STATE_group_get_next(group_handle: DWORD) : DWORD; stdcall;
	function STATE_group_get_using_name(name: LpChar) : DWORD; stdcall;
	function STATE_group_get_first_polygon(group_handle: DWORD) : DWORD; stdcall;
	function STATE_group_get_next_polygon(group_handle: DWORD; polygon_handle: DWORD) : DWORD; stdcall;
	function STATE_group_get_father_group(group_handle: DWORD) : DWORD; stdcall;
	function STATE_group_set_father_group(group_handle: DWORD; father_group: DWORD) : Integer; stdcall;
	function STATE_group_is_groupA_included_in_groupB(groupA_handle: DWORD; groupB_handle: DWORD) : Integer; stdcall;
	function STATE_group_get_name(group_handle: DWORD) : LpChar; stdcall;
	procedure STATE_group_get_rotate_reference_point(group_handle: DWORD; var center_Array3_OfDouble) ; stdcall;
	procedure STATE_group_set_rotate_reference_point(group_handle: DWORD; var center_Array3_OfDouble) ; stdcall;
	procedure STATE_group_get_center_of_mass(group_handle: DWORD; var center_Array3_OfDouble) ; stdcall;
	procedure STATE_group_get_bounding_box(group_handle: DWORD; var box_Array2x3_OfDouble) ; stdcall;
	procedure STATE_group_set_name(group_handle: DWORD; name: LpChar) ; stdcall;
	function STATE_group_get_number_of_polygons(group_handle: DWORD) : Integer; stdcall;
	procedure STATE_group_rotate(group_handle: DWORD; degrees: Double; space_flag: Integer; axis_flag: Integer) ; stdcall;
	procedure STATE_group_rotate_using_matrix(group_handle: DWORD; var rotate_matrix_Array3x3_OfDouble) ; stdcall;
	procedure STATE_group_transform_using_matrix4x4(group_handle: DWORD; var trans_matrix_Array4x4_OfDouble) ; stdcall;
	procedure STATE_group_set_location(group_handle: DWORD; var location_Array3_OfDouble) ; stdcall;
	procedure STATE_group_get_location(group_handle: DWORD; var X: Double; var Y: Double; var Z: Double) ; stdcall;
	procedure STATE_group_move(group_handle: DWORD; var step_Array3_OfDouble; space_flag: Integer) ; stdcall;
	procedure STATE_group_scale(group_handle: DWORD; space_flag: Integer; scale_x: Double; scale_y: Double; scale_z: Double) ; stdcall;
	function STATE_group_get_dimensions(group_handle: DWORD; var dimensions_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_group_ungroup(group_handle: DWORD) ; stdcall;
	function STATE_group_delete_members(group_handle: DWORD) : Integer; stdcall;
	function STATE_group_is_static(group_handle: DWORD) : Integer; stdcall;
	procedure STATE_group_set_static(group_handle: DWORD) ; stdcall;
	procedure STATE_group_set_dynamic(group_handle: DWORD) ; stdcall;
	procedure STATE_group_load_as_disabled(group_handle: DWORD; YES_or_NO: Integer) ; stdcall;
	function STATE_group_get_load_as_disabled_status(group_handle: DWORD) : Integer; stdcall;
	function STATE_group_duplicate_tree(group_handle: DWORD) : DWORD; stdcall;
	function STATE_group_rotate_to_match_polygon(group_handle: DWORD; polygon_in_the_group: DWORD; reference_polygon: DWORD; inverse_flag: Integer) : Integer; stdcall;
	function STATE_group_rotate_around_line_to_match_polygon(group_handle: DWORD; polygon_in_the_group: DWORD; reference_polygon: DWORD; inverse_flag: Integer; var p1_Array3_OfDouble; var p2_Array3_OfDouble) : Integer; stdcall;
	function STATE_group_rotate_to_match_direction(group_handle: DWORD; polygon_in_the_group: DWORD; var direction_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_group_move_to_match_point(group_handle: DWORD; point_belongs_to_group: DWORD; point_to_match: DWORD) ; stdcall;
	function STATE_group_is_bitmap_used(group_handle: DWORD; bitmap_handle: DWORD) : Integer; stdcall;
	function STATE_group_count_intersections(groupA: DWORD; groupB: DWORD) : Integer; stdcall;
	function STATE_group_get_bottom_polygon(group_handle: DWORD) : DWORD; stdcall;
	function STATE_group_get_top_polygon(group_handle: DWORD) : DWORD; stdcall;
	function STATE_group_get_front_polygon(group_handle: DWORD) : DWORD; stdcall;
	function STATE_group_get_back_polygon(group_handle: DWORD) : DWORD; stdcall;
	procedure STATE_group_set_orientation(group_handle: DWORD; polygon_handle: DWORD; orientation_value: Integer) ; stdcall;
	function STATE_group_calculate_axis_system(group_handle: DWORD; var x_axis_Array3_OfDouble; var y_axis_Array3_OfDouble; var z_axis_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_group_set_name_to_chase(group_handle: DWORD; name: LpChar) ; stdcall;
	function STATE_group_get_chased_name(group_handle: DWORD) : LpChar; stdcall;
	function STATE_group_get_chase_offset(group_handle: DWORD; var offset_Array3_OfDouble) : Integer; stdcall;
	function STATE_group_set_chase_offset(group_handle: DWORD; var offset_Array3_OfDouble) : Integer; stdcall;
	function STATE_group_get_chase_softness(group_handle: DWORD) : Double; stdcall;
	procedure STATE_group_set_chase_softness(group_handle: DWORD; softness: Double) ; stdcall;
	function STATE_group_get_chase_type_name(group_handle: DWORD) : LpChar; stdcall;
	function STATE_group_get_chase_type(group_handle: DWORD) : Integer; stdcall;
	procedure STATE_group_set_chase_type(group_handle: DWORD; chase_type: Integer) ; stdcall;
	procedure STATE_group_set_track_name(group_handle: DWORD; track_name: LpChar) ; stdcall;
	function STATE_group_get_track_name(group_handle: DWORD) : LpChar; stdcall;
	procedure STATE_group_get_track_offset(group_handle: DWORD; var offset_Array3_OfDouble) ; stdcall;
	procedure STATE_group_set_track_offset(group_handle: DWORD; var offset_Array3_OfDouble) ; stdcall;
//	procedure STATE_group_set_falling_from_track(group_handle: DWORD; double	height_above_ground: ; fall_through_dynamic_objects: Integer) ; stdcall;
	procedure STATE_group_unset_falling_from_track(group_handle: DWORD) ; stdcall;
//	procedure STATE_group_get_falling_from_track_params(group_handle: DWORD; var set_flag: Integer; double	*height_above_ground: ; var fall_through_dynamic_objects: Integer) ; stdcall;
	procedure STATE_group_get_speed(group_handle: DWORD; var speed_Array3_OfDouble) ; stdcall;
	procedure STATE_group_set_speed(group_handle: DWORD; var speed_Array3_OfDouble) ; stdcall;
	function STATE_group_get_absolute_speed(group_handle: DWORD) : Double; stdcall;
	procedure STATE_group_set_absolute_speed(group_handle: DWORD; speed: Double) ; stdcall;
	function STATE_group_rotate_to_match_axis_system(group_handle: DWORD; var x_axis_Array3_OfDouble; var y_axis_Array3_OfDouble; var z_axis_Array3_OfDouble) : Integer; stdcall;
	function STATE_group_rotate_around_line(group_handle: DWORD; var p1_Array3_OfDouble; var p2_Array3_OfDouble; degrees: Double) : Integer; stdcall;
	function STATE_group_wrap_a_bitmap(group_handle: DWORD; bitmap_handle: DWORD; repeat_x: Integer; repeat_y: Integer) : Integer; stdcall;
	function STATE_group_reduce_polygons_count(group_handle : DWORD; accuracy: Double) : Integer; stdcall;
	function STATE_group_create_reduced_copy(group_to_copy: DWORD; optimization_level: Double) : DWORD; stdcall;
	function STATE_group_create_copy_made_of_triangles(group_to_copy: DWORD) : DWORD; stdcall;
	function STATE_group_is_rotation_enabled(group_handle: DWORD) : Integer; stdcall;
	function STATE_group_convert_point_to_world_space(group_handle: DWORD; var group_space_point_Array3_OfDouble; var result_Array3_OfDouble) : Integer; stdcall;
	function STATE_group_convert_point_to_group_space(group_handle: DWORD; var world_space_point_Array3_OfDouble; var result_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_group_set_chase_distance(group_handle: DWORD; chase_distance: Double) ; stdcall;
	function STATE_group_get_chase_distance(group_handle: DWORD) : Double; stdcall;
	procedure STATE_group_delete_patches(group_handle: DWORD; type_of_patches_to_delete_or_serial_number: Integer) ; stdcall;
	procedure STATE_group_set_patches_color(group_handle: DWORD; red: Integer; green: Integer; blue: Integer; patches_type: Integer) ; stdcall;
	procedure STATE_group_set_patches_bitmap(group_handle: DWORD; bitmap_handle: DWORD; patches_type: Integer) ; stdcall;
	procedure STATE_group_set_patches_translucent(group_handle: DWORD; translucent_type: BYTE; patches_type: Integer) ; stdcall;
	function STATE_group_get_physics_rotation(group_handle: DWORD; var rotation_xyz_Array3_OfDouble) : Integer; stdcall;
	procedure STATE_group_set_physics_rotation(group_handle: DWORD; rotation_space : Integer; rotate_around_x_axis: Double; rotate_around_y_axis: Double; rotate_around_z_axis: Double) ; stdcall;
	procedure STATE_group_set_physics_force(group_handle: DWORD; var force_Array3_OfDouble) ; stdcall;
	procedure STATE_group_get_physics_force(group_handle: DWORD; var force_Array3_OfDouble) ; stdcall;
	function STATE_group_get_physics_friction(group_handle: DWORD) : Double; stdcall;
	procedure STATE_group_set_physics_friction(group_handle: DWORD; friction: Double) ; stdcall;
	function STATE_group_get_physics_elasticity(group_handle: DWORD) : Double; stdcall;
	procedure STATE_group_set_physics_elasticity(group_handle: DWORD; elasticity: Double) ; stdcall;
	function STATE_group_get_physics_maxspeed(group_handle: DWORD) : Double; stdcall;
	procedure STATE_group_set_physics_maxspeed(group_handle: DWORD; max_speed: Double) ; stdcall;
	procedure STATE_group_set_control_number(group_handle: DWORD; num: Integer) ; stdcall;
	function STATE_group_get_control_number(group_handle: DWORD) : Integer; stdcall;
	function STATE_group_wrap_a_bitmap_fixed(group_handle: DWORD; bitmap_handle: DWORD; repeat_x: Integer; repeat_y: Integer; var locationXY_to_get_bitmap_top_left_corner_Array2_OfDouble; var locationXY_to_get_bitmap_bottom_right_corner_Array2_OfDouble) : Integer; stdcall;
	procedure STATE_group_light_group(group_handle: DWORD; var direction_Array3_OfDouble; ambient: Double; light_intensity: Double) ; stdcall;
	procedure STATE_group_remove_light(group_handle: DWORD) ; stdcall;
	procedure STATE_group_set_color(group_handle: DWORD; var rgb_Array3_OfByte) ; stdcall;
	procedure STATE_group_set_light(group_handle: DWORD; var rgb_Array3_OfByte) ; stdcall;
	procedure STATE_group_set_ambient(group_handle: DWORD; value: Integer) ; stdcall;
	procedure STATE_group_set_diffuse(group_handle: DWORD; value: Integer) ; stdcall;
	procedure STATE_group_set_specular(group_handle: DWORD; value: Integer) ; stdcall;
	function STATE_group_create_lightmap(group_handle: DWORD; max_bm_side: Integer; min_lightmap_size: Integer; sample_rate: Double; force_ray_tracing: Integer; bitmap_number: Integer) : Integer; stdcall;
	function STATE_3D_animation_get_first: DWORD; stdcall;
	function STATE_3D_animation_get_next(anim3d_handle: DWORD) : DWORD; stdcall;
	procedure STATE_3D_animation_delete_all; stdcall;
	procedure STATE_3D_animation_delete(anim3d_handle: DWORD) ; stdcall;
	function STATE_3D_animation_get_using_name(anim3d_name: LpChar) : DWORD; stdcall;
	function STATE_3D_animation_get_name(anim3d_handle: DWORD) : LpChar; stdcall;
	function STATE_3D_animation_is_3D_animation(anim3d_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	function STATE_3D_sequence_get_first(animation3D_handle: DWORD) : DWORD; stdcall;
	function STATE_3D_sequence_get_next(sequence3d_handle: DWORD) : DWORD; stdcall;
	function STATE_3D_sequence_get_using_name(animation3D_handle: DWORD; sequence3d_name: LpChar) : DWORD; stdcall;
	function STATE_3D_sequence_get_name(sequence3d_handle: DWORD) : LpChar; stdcall;
	procedure STATE_3D_sequence_delete_all(animation3D_handle: DWORD) ; stdcall;
	procedure STATE_3D_sequence_delete(animation3D_handle: DWORD; sequence3d_handle: DWORD) ; stdcall;
	function STATE_3D_sequence_is_3D_sequence(sequence3d_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	procedure STATE_3D_sequence_set_speed(sequence3d_handle: DWORD; speed: Double) ; stdcall;
	function STATE_3D_sequence_get_speed(sequence3d_handle: DWORD) : Double; stdcall;
	function STATE_3D_sequence_get_number_of_frames(sequence3d_handle: DWORD) : Integer; stdcall;
	function STATE_3D_sequence_get_frame_duration(sequence3d_handle: DWORD; frame_number: Integer) : Integer; stdcall;
	function STATE_3D_sequence_set_frame_duration(sequence3d_handle: DWORD; frame_number: Integer; duration: Integer) : Integer; stdcall;
	function STATE_3D_sequence_is_cyclic(sequence3d_handle: DWORD) : Integer; stdcall;
	procedure STATE_3D_sequence_set_cyclic(sequence3d_handle: DWORD; YES_or_NO: Integer) ; stdcall;
	procedure STATE_3D_sequence_set_current_frame(sequence3d_handle: DWORD; current_frame: Double) ; stdcall;
	function STATE_3D_sequence_get_current_frame(sequence3d_handle: DWORD) : Double; stdcall;
	procedure STATE_3D_sequence_pause(sequence3d_handle: DWORD) ; stdcall;
	procedure STATE_3D_sequence_play(sequence3d_handle: DWORD) ; stdcall;
	function STATE_3D_sequence_is_paused(sequence3d_handle: DWORD) : Integer; stdcall;
	procedure STATE_3D_sequence_backwards_play(sequence3d_handle: DWORD; YES_or_NO: Integer) ; stdcall;
	function STATE_3D_sequence_is_backwards(sequence3d_handle: DWORD) : Integer; stdcall;
	function STATE_3D_sequence_get_number_of_laps(sequence3d_handle: DWORD) : Integer; stdcall;
	function STATE_3D_sequence_duplicate(animation3D_handle: DWORD; sequence_to_duplicate: DWORD; name: LpChar) : DWORD; stdcall;
	function STATE_light_create(light_name: LpChar; var location_Array3_OfDouble) : DWORD; stdcall;
	procedure STATE_light_activate(light_handle: DWORD; light_operation: Integer) ; stdcall;
	function STATE_light_get_using_name(light_name: LpChar) : DWORD; stdcall;
	function STATE_light_get_first_light: DWORD; stdcall;
	function STATE_light_get_next_light(light_handle: DWORD) : DWORD; stdcall;
	procedure STATE_light_set_location(light_handle: DWORD; var location_Array3_OfDouble) ; stdcall;
	procedure STATE_light_get_location(light_handle: DWORD; var location_Array3_OfDouble) ; stdcall;
	procedure STATE_light_point_at(light_handle: DWORD; var point_Array3_OfDouble) ; stdcall;
	procedure STATE_light_set_direction(light_handle: DWORD; var direction_Array3_OfDouble) ; stdcall;
	procedure STATE_light_get_direction(light_handle: DWORD; var direction_Array3_OfDouble) ; stdcall;
	procedure STATE_light_set_color(light_handle: DWORD; var color_Array3_OfByte) ; stdcall;
	procedure STATE_light_get_color(light_handle: DWORD; var color_Array3_OfByte) ; stdcall;
	procedure STATE_light_remove_light(light_handle: DWORD) ; stdcall;
	procedure STATE_light_set_type_of_light(light_handle: DWORD; type_of_light: Integer) ; stdcall;
	function STATE_light_get_type_of_light(light_handle: DWORD) : Integer; stdcall;
	procedure STATE_light_set_ray_tracing(light_handle: DWORD; YES_or_NO: Integer) ; stdcall;
	function STATE_light_is_ray_tracing(light_handle: DWORD) : Integer; stdcall;
	procedure STATE_light_set_distance_reach(light_handle: DWORD; distance_reach: Double) ; stdcall;
	function STATE_light_get_distance_reach(light_handle: DWORD) : Double; stdcall;
	function STATE_light_set_entity_to_light(light_handle: DWORD; entity_to_light: DWORD) : Integer; stdcall;
	function STATE_light_get_entity_to_light(light_handle: DWORD) : DWORD; stdcall;
	procedure STATE_light_activate_before_each_render(light_handle: DWORD; YES_or_NO: Integer; light_operation: Integer) ; stdcall;
	function STATE_light_is_activated_before_render(light_handle: DWORD; var light_operation: Integer) : Integer; stdcall;
	procedure STATE_light_set_ambient(light_handle: DWORD; value: Double) ; stdcall;
	procedure STATE_light_set_diffuse(light_handle: DWORD; value: Double) ; stdcall;
	procedure STATE_light_set_specular(light_handle: DWORD; value: Double) ; stdcall;
	function STATE_light_get_ambient(light_handle: DWORD) : Double; stdcall;
	function STATE_light_get_diffuse(light_handle: DWORD) : Double; stdcall;
	function STATE_light_get_specular(light_handle: DWORD) : Double; stdcall;
	procedure STATE_light_set_specular_shining(light_handle: DWORD; value: Double) ; stdcall;
	function STATE_light_get_specular_shining(light_handle: DWORD) : Double; stdcall;
	function STATE_light_is_light(light_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	procedure STATE_light_delete_all; stdcall;
	procedure STATE_light_delete(light_handle: DWORD) ; stdcall;
	function STATE_light_get_name(light_handle: DWORD) : LpChar; stdcall;
	procedure STATE_light_set_name(light_handle: DWORD; name: LpChar) ; stdcall;
	function STATE_animation_is_animation(animation_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	function STATE_animation_get_handle(animation_name: LpChar) : DWORD; stdcall;
	function STATE_animation_get_first_animation: DWORD; stdcall;
	function STATE_animation_get_next(animation_handle: DWORD) : DWORD; stdcall;
	function STATE_animation_create(name: LpChar) : DWORD; stdcall;
	function STATE_animation_add_bitmap(animation_handle: DWORD; bitmap_list : Integer; bitmap_handle: DWORD; bitmap_position_index: Integer) : Integer; stdcall;
	function STATE_animation_remove_bitmap(animation_handle: DWORD; bitmap_list : Integer; bitmap_position_index: Integer) : Integer; stdcall;
	function STATE_animation_get_bitmap(animation_handle: DWORD; bitmap_list : Integer; bitmap_position_index: Integer) : DWORD; stdcall;
	function STATE_animation_set_times(animation_handle: DWORD; var time_for_each_frame_ArrayN_OfDword; size_of_array: Integer) : Integer; stdcall;
	function STATE_animation_get_times(animation_handle: DWORD; var time_for_each_frame_ArrayN_OfDword; size_of_array: Integer) : Integer; stdcall;
	function STATE_animation_get_frame_time(animation_handle: DWORD; frame_index: Integer) : DWORD; stdcall;
	function STATE_animation_set_frame_time(animation_handle: DWORD; frame_index: Integer; time: DWORD) : Integer; stdcall;
	function STATE_animation_get_name(animation_handle: DWORD) : LpChar; stdcall;
	procedure STATE_animation_set_name(animation_handle: DWORD; name: LpChar) ; stdcall;
	procedure STATE_animation_factor_speed(animation_handle: DWORD; factor: Double) ; stdcall;
	procedure STATE_animation_set_speed(animation_handle: DWORD; speed: Double) ; stdcall;
	procedure STATE_animation_delete_all; stdcall;
	procedure STATE_animation_delete(animation_handle: DWORD) ; stdcall;
	procedure STATE_animation_set_save_flag(animation_handle: DWORD; yes_no_flag: Integer) ; stdcall;
	function STATE_animation_get_save_flag(animation_handle: DWORD) : Integer; stdcall;
	function STATE_animation_get_number_of_frames(animation_handle: DWORD) : Integer; stdcall;
	function STATE_animation_get_number_of_bitmaps(animation_handle: DWORD) : Integer; stdcall;
	procedure STATE_animation_get_all_bitmaps(animation_handle: DWORD; var bitmaps_array_ArrayN_OfDword) ; stdcall;
	function STATE_animation_is_part_of_the_last_world(animation_handle: DWORD) : Integer; stdcall;
	function STATE_animation_get_number_of_polygons_with_animation(animation_handle: DWORD) : Integer; stdcall;
	function STATE_animation_duplicate(animation_handle: DWORD; new_name: LpChar) : DWORD; stdcall;
	function STATE_animation_set_bitmap(animation_handle: DWORD; bitmap_list : Integer; frame_index: Integer; bitmap_handle: DWORD) : Integer; stdcall;
	function STATE_animation_get_frame_bitmap_name(animation_handle: DWORD; bitmap_list : Integer; frame_index: Integer) : LpChar; stdcall;
	function STATE_animation_get_frame_transparent_index(animation_handle: DWORD; bitmap_list : Integer; frame_index: Integer) : Integer; stdcall;
	function STATE_bitmap_is_bitmap(bitmap_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	function STATE_bitmap_get_handle(file_name: LpChar; transparent_index: Integer) : DWORD; stdcall;
	function STATE_bitmap_get_first_bitmap: DWORD; stdcall;
	function STATE_bitmap_get_next(bitmap_handle: DWORD) : DWORD; stdcall;
	function STATE_bitmap_load(file_name: LpChar; transparent_index: Integer) : DWORD; stdcall;
	function STATE_bitmap_rgb_color_to_index(bitmap_handle: DWORD; red: BYTE; green: BYTE; blue: BYTE) : Integer; stdcall;
	function STATE_bitmap_index_to_rgb(bitmap_handle: DWORD; index : BYTE; var red: BYTE; var green: BYTE; var blue: BYTE) : Integer; stdcall;
	function STATE_bitmap_get_transparent_rgb(bitmap_handle: DWORD; var red: Integer; var green: Integer; var blue: Integer) : Integer; stdcall;
	function STATE_bitmap_get_transparent_index(bitmap_handle: DWORD) : Integer; stdcall;
	function STATE_bitmap_resample(source_bitmap_handle: DWORD; new_width: Integer; new_height: Integer) : DWORD; stdcall;
	procedure STATE_bitmap_unload(bitmap_handle: DWORD) ; stdcall;
	function STATE_bitmap_get_name(bitmap_handle: DWORD) : LpChar; stdcall;
	function STATE_bitmap_get_number_of_polygons_using_bitmap(bitmap_handle: DWORD) : Integer; stdcall;
	function STATE_bitmap_get_width(bitmap_handle: DWORD) : Integer; stdcall;
	function STATE_bitmap_get_height(bitmap_handle: DWORD) : Integer; stdcall;
	function STATE_bitmap_get_memory(bitmap_handle: DWORD) : BYTE; stdcall;
	function STATE_bitmap_get_palette(bitmap_handle: DWORD) : WORD; stdcall;
	function STATE_bitmap_set_palette_color(bitmap_handle: DWORD; index_of_color_to_be_changed: BYTE; red: BYTE; green: BYTE; blue: BYTE) : Integer; stdcall;
	function STATE_bitmap_get_palette_size(bitmap_handle: DWORD) : Integer; stdcall;
	procedure STATE_bitmap_save(bitmap_handle: DWORD; full_path_name: LpChar) ; stdcall;
	function STATE_sound_load(file_name: LpChar; entity_handle: DWORD; distance_reach: Double) : DWORD; stdcall;
	function STATE_sound_attach(sound_handle: DWORD; entity_handle: DWORD) : Integer; stdcall;
	procedure STATE_sound_play_all_sounds; stdcall;
	function STATE_sound_stop(sound_handle: DWORD) : Integer; stdcall;
	procedure STATE_sound_stop_all_sounds; stdcall;
	function STATE_sound_get_first: DWORD; stdcall;
	function STATE_sound_set_distance_reach(sound_handle: DWORD; distance_reach: Double) : Integer; stdcall;
	function STATE_sound_get_next(sound_handle: DWORD) : DWORD; stdcall;
	procedure STATE_sound_set_volume(sound_handle: DWORD; volume: Integer) ; stdcall;
	function STATE_sound_get_volume(sound_handle : DWORD) : Integer; stdcall;
	procedure STATE_sound_set_frequency(sound_handle: DWORD; frequency: Integer) ; stdcall;
	function STATE_sound_get_frequency(sound_handle: DWORD) : Integer; stdcall;
	function STATE_sound_is_sound_playing(sound_handle: DWORD) : Integer; stdcall;
	function STATE_sound_set_sound_name(sound_handle: DWORD; name: LpChar) : Integer; stdcall;
	function STATE_sound_get_sound_name(sound_handle: DWORD) : LpChar; stdcall;
	function STATE_sound_get_handle_using_name(name: LpChar) : DWORD; stdcall;
	function STATE_sound_get_handle_using_entity(entity_handle: DWORD) : DWORD; stdcall;
	procedure STATE_sound_set_pause_mode(sound_handle: DWORD; pause: BOOL) ; stdcall;
	procedure STATE_sound_CD_play(track: Integer) ; stdcall;
	procedure STATE_sound_CD_stop; stdcall;
	function STATE_sound_CD_get_track: Integer; stdcall;
	function STATE_sound_CD_get_num_of_tracks: Integer; stdcall;
	procedure STATE_sound_CD_set_pause_mode(pause: BOOL) ; stdcall;
	procedure STATE_sound_CD_eject; stdcall;
	function STATE_track_is_track(track_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	function STATE_track_get_using_name(name: LpChar) : DWORD; stdcall;
	function STATE_track_is_cyclic(track_handle: DWORD) : Integer; stdcall;
	function STATE_track_get_name(track_handle: DWORD) : LpChar; stdcall;
	procedure STATE_track_set_name(track_handle: DWORD; name: LpChar) ; stdcall;
	function STATE_track_get_number_of_points(track_handle: DWORD) : Integer; stdcall;
	function STATE_track_get_first_track: DWORD; stdcall;
	function STATE_track_get_next(track_handle: DWORD) : DWORD; stdcall;
	function STATE_track_get_point(track_handle: DWORD; point_index: Integer; var pt_Array3_OfDouble) : Integer; stdcall;
	function STATE_track_get_point_element(track_handle: DWORD; point_index: Integer; point_element: Integer) : Double; stdcall;
	function STATE_track_get_points(track_handle: DWORD) : Double; stdcall;
	function STATE_track_find_closest_point_on_track(track_handle: DWORD; var P_Array3_OfDouble) : Integer; stdcall;
	function STATE_track_create(track_name: LpChar; is_cyclic: Integer; var points_buffer: Double; number_of_points: Integer) : DWORD; stdcall;
	procedure STATE_track_set_points_buffer(track_handle: DWORD; var points: Double; number_of_points: Integer) ; stdcall;
	procedure STATE_track_set_number_of_points(track_handle: DWORD; number_of_points: Integer) ; stdcall;
	procedure STATE_track_delete(track_handle: DWORD) ; stdcall;
	procedure STATE_track_delete_all; stdcall;
	procedure STATE_track_set_save_flag(track_handle: DWORD; yes_no_flag: Integer) ; stdcall;
	function STATE_track_get_save_flag(track_handle: DWORD) : Integer; stdcall;
	function STATE_background_is_background(background_handle: DWORD; function_asking: LpChar) : Integer; stdcall;
	function STATE_background_get_handle(background_name: LpChar) : DWORD; stdcall;
	function STATE_background_get_first_background: DWORD; stdcall;
	function STATE_background_get_next(background_handle: DWORD) : DWORD; stdcall;
	function STATE_background_create(name: LpChar; bitmap_handle: DWORD) : DWORD; stdcall;
	procedure STATE_background_set_name(background_handle: DWORD; name: LpChar) ; stdcall;
	function STATE_background_get_name(background_handle: DWORD) : LpChar; stdcall;
	procedure STATE_background_set_distance(background_handle: DWORD; value: Double) ; stdcall;
	function STATE_background_get_distance(background_handle: DWORD) : Double; stdcall;
	procedure STATE_background_set_bottom(background_handle: DWORD; value: Double) ; stdcall;
	function STATE_background_get_bottom(background_handle: DWORD) : Double; stdcall;
	function STATE_background_set_bottom_intensity(background_handle: DWORD; value: Double) : Integer; stdcall;
	function STATE_background_get_bottom_intensity(background_handle: DWORD) : Double; stdcall;
	function STATE_background_set_intensity_step(background_handle: DWORD; value: Double) : Integer; stdcall;
	function STATE_background_get_intensity_step(background_handle: DWORD) : Double; stdcall;
	procedure STATE_background_delete(background_handle: DWORD) ; stdcall;
	procedure STATE_background_delete_all; stdcall;
	procedure STATE_background_use(background_handle: DWORD) ; stdcall;
	function STATE_background_get_current_background: DWORD; stdcall;
	procedure STATE_background_set_save_flag(background_handle: DWORD; yes_no_flag: Integer) ; stdcall;
	function STATE_background_get_save_flag(background_handle: DWORD) : Integer; stdcall;
	procedure STATE_background_set_bitmap(background_handle: DWORD; bitmap_handle: DWORD) ; stdcall;
	function STATE_background_get_bitmap(background_handle: DWORD) : DWORD; stdcall;
	function STATE_background_get_bitmap_name(background_handle: DWORD) : LpChar; stdcall;
	function STATE_entity_get_name(entity: DWORD; buffer: LpChar; buffer_size: Integer) : Integer; stdcall;
	function STATE_entity_create_lightmap(entity: DWORD; max_bm_side: Integer; min_lightmap_size: Integer; sample_rate: Double; force_ray_tracing: Integer; bitmap_number: Integer) : Integer; stdcall;
	function STATE_3D_card_check_hardware_support: Integer; stdcall;
	function STATE_3D_card_use(YES_or_NO: Integer) : Integer; stdcall;
	function STATE_3D_card_use_detailed(render_mode: Integer; set_fullscreen: Integer; resolution_x: Integer; resolution_y: Integer; color_depth: Integer; use_secondary_card: Integer) : Integer; stdcall;
	function STATE_3D_card_is_used: Integer; stdcall;
	function STATE_3D_card_set_full_screen_mode(resolution_x: Integer; resolution_y: Integer) : Integer; stdcall;
	function STATE_3D_card_is_full_screen_mode: Integer; stdcall;
	function STATE_3D_card_set_window_mode: Integer; stdcall;
	procedure STATE_3D_card_hide_driver_selection_window(YES_or_NO: Integer) ; stdcall;
	function STATE_3D_card_is_driver_selection_window_visible: Integer; stdcall;
	function STATE_utilities_file_to_memory(file_name: LpChar; var file_size: Integer) : BYTE; stdcall;
	procedure STATE_utilities_paste_resource_bitmap(hwnd: HWND; bitmap_resource_id: UINT; border: Integer) ; stdcall;
	procedure STATE_utilities_paste_bitmap(hwnd: HWND; bitmap_handle: HBITMAP; border: Integer) ; stdcall;
	procedure STATE_utilities_copy_bitmap_on_dc(hdc: HDC; hbm: HBITMAP; x: Integer; y: Integer; bm_stretch_width: Integer; bm_stretch_height: Integer) ; stdcall;
	function STATE_utilities_load_bitmap_from_file(bitmap_file_name: LpChar) : HBITMAP; stdcall;
	function STATE_utilities_save_bitmap(hbm: HBITMAP; bitmap_ile_name: LpChar) : Integer; stdcall;
	function STATE_utilities_resample_bitmap(source_bitmap_file: LpChar; new_bitmap_file_name: LpChar; new_width: Integer; new_height: Integer) : Integer; stdcall;
	function STATE_utilities_jpg2bmp(jpg_file_name: LpChar) : Integer; stdcall;
	function STATE_utilities_bmp2jpg(bmp_file_name: LpChar) : Integer; stdcall;
	function STATE_utilities_convert_3d_formats(input_file_name: LpChar; world_directory_path: LpChar; bitmaps_directory_path: LpChar; output_file_name: LpChar; save_flags: Integer) : Integer; stdcall;
	procedure STATE_utilities_rgb16_to_rgb24(rgb16: WORD; var red: BYTE; var green: BYTE; var blue: BYTE) ; stdcall;
	function STATE_utilities_is_windows98: Integer; stdcall;
	function STATE_utilities_save_screenshot(rend_win: HWND; file_name: LpChar) : Integer; stdcall;
	procedure STATE_utilities_test_address(var mem_address: BYTE; size: Integer) ; stdcall;
	function STATE_utilities_test_string: LpChar; stdcall;
	procedure STATE_utilities_test_LPSTR(str: LPSTR) ; stdcall;
	procedure STATE_utilities_test_LPCSTR(str: LPCSTR) ; stdcall;
	procedure STATE_utilities_test_PDWORD(var ptr: DWORD) ; stdcall;
	procedure STATE_utilities_test_2PDWORD(var ptr1: DWORD; var ptr2: DWORD) ; stdcall;
	function STATE_math_get_square_distance(var p1_Array3_OfDouble; var p2_Array3_OfDouble) : Double; stdcall;
	function STATE_math_get_distance(var p1_Array3_OfDouble; var p2_Array3_OfDouble) : Double; stdcall;
	function STATE_math_does_segment_intersect_plane(var pln_Array4_OfDouble; var pt1_Array3_OfDouble; var pt2_Array3_OfDouble; var intersection_point_Array3_OfDouble) : Integer; stdcall;
	function STATE_math_get_distance_between_point_and_line(var P_Array3_OfDouble; var A_Array3_OfDouble; var B_Array3_OfDouble) : Double; stdcall;
	function STATE_math_get_closest_point_on_line(var P_Array3_OfDouble; var A_Array3_OfDouble; var B_Array3_OfDouble; var closest_point_on_line_Array3_OfDouble) : Integer; stdcall;
	function STATE_math_is_point_on_segment(var pt_Array3_OfDouble; var segment_start_Array3_OfDouble; var segment_end_Array3_OfDouble) : Integer; stdcall;
	function STATE_math_points_to_plane(var pln_Array4_OfDouble; var p1_Array3_OfDouble; var p2_Array3_OfDouble; var p3_Array3_OfDouble) : Integer; stdcall;
	function STATE_math_get_plane_point_relations(var pln_Array4_OfDouble; var pt_Array3_OfDouble; thickness: Double) : Integer; stdcall;
	function STATE_math_get_reflected_direction(var normal_Array3_OfDouble; var hitting_ray_Array3_OfDouble; var reflecting_ray_Array3_OfDouble) : Integer; stdcall;
	function STATE_math_product(var vec1_Array3_OfDouble; var vec2_Array3_OfDouble) : Double; stdcall;
	procedure STATE_math_cross(var vec1_Array3_OfDouble; var vec2_Array3_OfDouble; var result_Array3_OfDouble) ; stdcall;
	function STATE_math_normalize_vector(var vec_Array3_OfDouble) : Integer; stdcall;
	function STATE_math_get_vector_length(var vec_Array3_OfDouble) : Double; stdcall;
	function STATE_profiler_start_measuring(time_id: Integer; name: LpChar) : Integer; stdcall;
	procedure STATE_profiler_end_measuring(time_id: Integer) ; stdcall;
        function STATE_object_delete_polygon(object_handle:DWORD; polygon_handle:DWORD) : Integer; stdcall;
        function STATE_engine_create_speed_database(visited_points_file_name : pchar; reset_database, make_compact_database : integer) : Integer; stdcall;
        function STATE_3D_card_is_multiple_texture_blending_supported : integer; stdcall;
        function STATE_sound_play(sound_handle : DWORD;const loop : integer) : integer; stdcall;
        procedure STATE_engine_set_stereoscopic_mode(stereoscopic_mode : integer; distance_between_eyes : double); stdcall;
//???        procedure STATE_3D_card_get_directx_internals(void **IDirectDraw4_object, void **IDirect3D3_object, void **IDirect3DDevice3_device, void **IDirectDrawSurface4_primary_surface, void **IDirectDrawSurface4_back_surface, void **IDirectDrawSurface4_zbuffer, void **IDirect3DViewport3_viewport);  stdcall;
        function STATE_camera_move_with_collision_detection(camera: DWORD; var wanted_location_Array3_OfDouble; camera_physical_width: Double) : Integer; stdcall;
        function STATE_polygon_get_patch_type(polygon_handle : DWORD) : Integer; stdcall;
        function STATE_engine_switch_stereoscopic_mode : integer; stdcall;
        function STATE_engine_get_stereoscopic_mode : integer; stdcall;
        function STATE_engine_get_stereoscopic_mode_name : string; stdcall;


implementation
	function STATE_engine_render; external '3DState3.dll';
	function STATE_engine_load_world; external '3DState3.dll';
	function STATE_engine_add_world; external '3DState3.dll';
	function STATE_engine_is_engine_empty; external '3DState3.dll';
	function STATE_engine_is_editor_mode; external '3DState3.dll';
	function STATE_engine_set_resolution; external '3DState3.dll';
	function STATE_engine_get_resolution; external '3DState3.dll';
	function STATE_engine_set_color_depth; external '3DState3.dll';
	procedure STATE_engine_set_log_window_visible; external '3DState3.dll';
	procedure STATE_engine_hide_log_window; external '3DState3.dll';
	function STATE_engine_is_log_window_visible; external '3DState3.dll';
	function STATE_engine_get_log_window_progress; external '3DState3.dll';
	function STATE_engine_get_log_window_target; external '3DState3.dll';
	procedure STATE_engine_set_log_window_progress; external '3DState3.dll';
	procedure STATE_engine_set_log_window_target; external '3DState3.dll';
	procedure STATE_engine_log_window_minimize; external '3DState3.dll';
	procedure STATE_engine_log_window_output; external '3DState3.dll';
	procedure STATE_engine_log_window_set_text; external '3DState3.dll';
	procedure STATE_engine_log_window_set_title; external '3DState3.dll';
	function STATE_engine_log_window_get_hwnd; external '3DState3.dll';
	procedure STATE_engine_clear_STATE_log_files; external '3DState3.dll';
	function STATE_engine_mark_polygon_at_point; external '3DState3.dll';
	function STATE_engine_2D_point_to_3D; external '3DState3.dll';
	function STATE_engine_2D_point_to_3D_point_on_plane; external '3DState3.dll';
	function STATE_engine_3D_point_to_2D; external '3DState3.dll';
	procedure STATE_engine_set_picture_quality; external '3DState3.dll';
	function STATE_engine_get_picture_quality; external '3DState3.dll';
	procedure STATE_engine_increase_picture_quality; external '3DState3.dll';
	procedure STATE_engine_decrease_picture_quality; external '3DState3.dll';
	function STATE_engine_set_automatic_quality_control; external '3DState3.dll';
	procedure STATE_engine_set_normal_rendering_mode; external '3DState3.dll';
	procedure STATE_engine_set_color_fill_rendering_mode; external '3DState3.dll';
	procedure STATE_engine_set_wire_frame_rendering_mode; external '3DState3.dll';
	procedure STATE_engine_toggle_rendering_mode; external '3DState3.dll';
	procedure STATE_engine_toggle_wire_frame_flag; external '3DState3.dll';
	procedure STATE_engine_set_default_brightness; external '3DState3.dll';
	procedure STATE_engine_increase_brightness; external '3DState3.dll';
	procedure STATE_engine_decrease_brightness; external '3DState3.dll';
	procedure STATE_engine_set_brightness; external '3DState3.dll';
	function STATE_engine_get_brightness; external '3DState3.dll';
	procedure STATE_engine_increase_atmospheric_effect_intensity; external '3DState3.dll';
	procedure STATE_engine_decrease_atmospheric_effect_intensity; external '3DState3.dll';
	procedure STATE_engine_set_default_atmospheric_effect_intensity; external '3DState3.dll';
	function STATE_engine_get_atmospheric_effect_intensity; external '3DState3.dll';
	procedure STATE_engine_set_atmospheric_effect_intensity; external '3DState3.dll';
	procedure STATE_engine_toggle_atmospheric_effect; external '3DState3.dll';
	procedure STATE_engine_set_atmospheric_effect; external '3DState3.dll';
	procedure STATE_engine_get_atmospheric_effect; external '3DState3.dll';
	procedure STATE_engine_set_background_color; external '3DState3.dll';
	procedure STATE_engine_get_background_color; external '3DState3.dll';
	procedure STATE_engine_toggle_automatic_perspective_correction; external '3DState3.dll';
	procedure STATE_engine_toggle_perspective_correction_accuracy; external '3DState3.dll';
	procedure STATE_engine_increase_far_objects_color_accuracy; external '3DState3.dll';
	procedure STATE_engine_decrease_far_objects_color_accuracy; external '3DState3.dll';
	procedure STATE_engine_set_default_far_objects_color_accuracy; external '3DState3.dll';
	function STATE_engine_get_far_objects_color_accuracy; external '3DState3.dll';
	procedure STATE_engine_set_far_objects_color_accuracy; external '3DState3.dll';
	procedure STATE_engine_increase_culling_depth; external '3DState3.dll';
	procedure STATE_engine_decrease_culling_depth; external '3DState3.dll';
	procedure STATE_engine_set_default_culling_depth; external '3DState3.dll';
	function STATE_engine_get_culling_depth; external '3DState3.dll';
	procedure STATE_engine_set_culling_depth; external '3DState3.dll';
	function STATE_engine_is_movement_possible; external '3DState3.dll';
	function STATE_engine_is_movement_possible_camera_space; external '3DState3.dll';
	function STATE_engine_get_number_of_collisions; external '3DState3.dll';
	function STATE_engine_get_object_at_point_2D; external '3DState3.dll';
	function STATE_engine_get_polygon_at_point_2D; external '3DState3.dll';
	function STATE_engine_get_default_rendering_window_hwnd; external '3DState3.dll';
	procedure STATE_engine_maximize_default_rendering_window; external '3DState3.dll';
	procedure STATE_engine_minimize_default_rendering_window; external '3DState3.dll';
	procedure STATE_engine_set_default_rendering_window_title; external '3DState3.dll';
	procedure STATE_engine_set_default_rendering_window_size; external '3DState3.dll';
	function STATE_engine_reduce_polygons_count; external '3DState3.dll';
	function STATE_engine_add_polygon; external '3DState3.dll';
	function STATE_engine_save; external '3DState3.dll';
	procedure STATE_engine_copy_image_from_dc_to_screen; external '3DState3.dll';
	procedure STATE_engine_bitblt; external '3DState3.dll';
	function STATE_engine_render_on_bitmap; external '3DState3.dll';
	function STATE_engine_render_on_dc; external '3DState3.dll';
	function STATE_engine_render_on_memCDC; external '3DState3.dll';
	function STATE_engine_3D_edge_to_2D; external '3DState3.dll';
	function STATE_engine_clip_edge; external '3DState3.dll';
	procedure STATE_engine_set_group_to_render; external '3DState3.dll';
	function STATE_engine_get_number_of_loaded_bitmaps; external '3DState3.dll';
	function STATE_engine_unload_unused_bitmaps; external '3DState3.dll';
	procedure STATE_engine_unload_all_bitmaps; external '3DState3.dll';
	function STATE_engine_translate_movement_on_screen_to_movement_in_world; external '3DState3.dll';
	function STATE_engine_translate_movement_on_screen_to_world; external '3DState3.dll';
	function STATE_engine_get_original_color_depth; external '3DState3.dll';
	procedure STATE_engine_advance_objects_automatically; external '3DState3.dll';
	procedure STATE_engine_advance_cameras_automatically; external '3DState3.dll';
	function STATE_engine_use_zbuffer; external '3DState3.dll';
	function STATE_engine_is_zbuffer; external '3DState3.dll';
	procedure STATE_engine_set_perspective_correction_accuracy; external '3DState3.dll';
	function STATE_engine_get_perspective_correction_accuracy; external '3DState3.dll';
	function STATE_engine_get_average_program_cycle_time; external '3DState3.dll';
	function STATE_engine_get_last_program_cycle_time; external '3DState3.dll';
	function STATE_engine_get_last_render_execution_time; external '3DState3.dll';
	function STATE_engine_get_average_render_execution_time; external '3DState3.dll';
	function STATE_engine_check_3d_hardware_support; external '3DState3.dll';
	function STATE_engine_use_3D_accelerator_card; external '3DState3.dll';
	procedure STATE_engine_get_3D_accelerator_resolution; external '3DState3.dll';
	function STATE_engine_is_3D_accelerator_card_used; external '3DState3.dll';
	function STATE_engine_create_terrain_from_bitmap; external '3DState3.dll';
	function STATE_engine_get_last_error; external '3DState3.dll';
	function STATE_engine_get_computer_speed_factor; external '3DState3.dll';
	procedure STATE_engine_set_speaker_mode; external '3DState3.dll';
	procedure STATE_engine_create_shadow; external '3DState3.dll';
	procedure STATE_engine_create_dynamic_shadow; external '3DState3.dll';
	procedure STATE_engine_delete_dynamic_shadows; external '3DState3.dll';
	procedure STATE_engine_set_maximum_rendering_time; external '3DState3.dll';
	function STATE_engine_get_maximum_rendering_time; external '3DState3.dll';
	procedure STATE_engine_set_minimum_rendering_time; external '3DState3.dll';
	function STATE_engine_get_minimum_rendering_time; external '3DState3.dll';
	procedure STATE_engine_set_thread_priority; external '3DState3.dll';
	procedure STATE_engine_close; external '3DState3.dll';
	function STATE_engine_get_logo; external '3DState3.dll';
	procedure STATE_engine_show_frames_per_second_rate; external '3DState3.dll';
	procedure STATE_engine_render_on_top_of_previous_rendering; external '3DState3.dll';
	function STATE_camera_is_camera; external '3DState3.dll';
	function STATE_camera_get_first_camera; external '3DState3.dll';
	function STATE_camera_get_next_camera; external '3DState3.dll';
	function STATE_camera_get_using_name; external '3DState3.dll';
	function STATE_camera_get_name; external '3DState3.dll';
	procedure STATE_camera_set_name; external '3DState3.dll';
	procedure STATE_camera_set_distance_from_eye; external '3DState3.dll';
	function STATE_camera_get_distance_from_eye; external '3DState3.dll';
	function STATE_camera_create; external '3DState3.dll';
	function STATE_camera_get_current; external '3DState3.dll';
	function STATE_camera_set_current; external '3DState3.dll';
	function STATE_camera_get_default_camera; external '3DState3.dll';
	procedure STATE_camera_save; external '3DState3.dll';
	function STATE_camera_recreate; external '3DState3.dll';
	procedure STATE_camera_set_values; external '3DState3.dll';
	function STATE_camera_get_width; external '3DState3.dll';
	function STATE_camera_get_height; external '3DState3.dll';
	procedure STATE_camera_get_direction; external '3DState3.dll';
	procedure STATE_camera_set_direction; external '3DState3.dll';
	procedure STATE_camera_point_at; external '3DState3.dll';
	function STATE_camera_point_at_2D; external '3DState3.dll';
	procedure STATE_camera_set_location; external '3DState3.dll';
	procedure STATE_camera_get_location; external '3DState3.dll';
	function STATE_camera_set_axis_system; external '3DState3.dll';
	procedure STATE_camera_get_axis_system; external '3DState3.dll';
	function STATE_camera_set_tilt; external '3DState3.dll';
	function STATE_camera_get_tilt; external '3DState3.dll';
	function STATE_camera_modify_tilt; external '3DState3.dll';
	procedure STATE_camera_move; external '3DState3.dll';
	function STATE_camera_set_focus; external '3DState3.dll';
	function STATE_camera_modify_focus; external '3DState3.dll';
	function STATE_camera_set_zoom; external '3DState3.dll';
	function STATE_camera_get_zoom; external '3DState3.dll';
	function STATE_camera_modify_zoom; external '3DState3.dll';
	function STATE_camera_set_head_angle; external '3DState3.dll';
	function STATE_camera_get_head_angle; external '3DState3.dll';
	function STATE_camera_modify_head_angle; external '3DState3.dll';
	function STATE_camera_set_bank; external '3DState3.dll';
	function STATE_camera_get_bank; external '3DState3.dll';
	function STATE_camera_modify_bank; external '3DState3.dll';
	procedure STATE_camera_rotate_x; external '3DState3.dll';
	procedure STATE_camera_rotate_y; external '3DState3.dll';
	procedure STATE_camera_rotate_z; external '3DState3.dll';
	procedure STATE_camera_rotate_x_radians; external '3DState3.dll';
	procedure STATE_camera_rotate_y_radians; external '3DState3.dll';
	procedure STATE_camera_rotate_z_radians; external '3DState3.dll';
	function STATE_camera_convert_point_to_world_space; external '3DState3.dll';
	function STATE_camera_convert_point_to_camera_space; external '3DState3.dll';
	function STATE_camera_delete; external '3DState3.dll';
	procedure STATE_camera_delete_all; external '3DState3.dll';
	function STATE_camera_get_track_name; external '3DState3.dll';
	function STATE_camera_get_track_handle; external '3DState3.dll';
	function STATE_camera_set_track; external '3DState3.dll';
	function STATE_camera_get_track_offset; external '3DState3.dll';
	function STATE_camera_set_track_offset; external '3DState3.dll';
	function STATE_camera_get_next_point_on_track; external '3DState3.dll';
	function STATE_camera_set_next_point_on_track; external '3DState3.dll';
	procedure STATE_camera_set_object_to_chase; external '3DState3.dll';
	function STATE_camera_get_chased_object; external '3DState3.dll';
	procedure STATE_camera_set_camera_to_chase; external '3DState3.dll';
	function STATE_camera_get_chased_camera; external '3DState3.dll';
	procedure STATE_camera_set_group_to_chase; external '3DState3.dll';
	function STATE_camera_get_chased_group; external '3DState3.dll';
	function STATE_camera_get_chase_offset; external '3DState3.dll';
	function STATE_camera_set_chase_offset; external '3DState3.dll';
	function STATE_camera_get_chase_softness; external '3DState3.dll';
	procedure STATE_camera_set_chase_softness; external '3DState3.dll';
	function STATE_camera_get_chase_type; external '3DState3.dll';
	procedure STATE_camera_set_chase_type; external '3DState3.dll';
	procedure STATE_camera_set_chase_distance; external '3DState3.dll';
	function STATE_camera_get_chase_distance; external '3DState3.dll';
	procedure STATE_camera_advance; external '3DState3.dll';
	procedure STATE_camera_get_speed; external '3DState3.dll';
	procedure STATE_camera_set_speed; external '3DState3.dll';
	function STATE_camera_get_absolute_speed; external '3DState3.dll';
	procedure STATE_camera_set_absolute_speed; external '3DState3.dll';
	procedure STATE_camera_get_force; external '3DState3.dll';
	procedure STATE_camera_set_force; external '3DState3.dll';
	procedure STATE_camera_set_max_speed; external '3DState3.dll';
	function STATE_camera_get_max_speed; external '3DState3.dll';
	procedure STATE_camera_set_friction; external '3DState3.dll';
	function STATE_camera_get_friction; external '3DState3.dll';
	procedure STATE_camera_set_elasticity; external '3DState3.dll';
	function STATE_camera_get_elasticity; external '3DState3.dll';
	function STATE_camera_get_location_to_fit_rectangle; external '3DState3.dll';
	function STATE_camera_move_toward_point_2D; external '3DState3.dll';
	procedure STATE_camera_advance_all; external '3DState3.dll';
	procedure STATE_camera_set_name_to_chase; external '3DState3.dll';
	function STATE_camera_get_name_to_chase; external '3DState3.dll';
	procedure STATE_camera_set_save_flag; external '3DState3.dll';
	function STATE_camera_get_save_flag; external '3DState3.dll';
	procedure STATE_camera_set_perspective_projection; external '3DState3.dll';
	procedure STATE_camera_set_parallel_projection; external '3DState3.dll';
	function STATE_camera_is_perspective_projection; external '3DState3.dll';
	function STATE_camera_get_parallel_projection_width; external '3DState3.dll';
	function STATE_camera_get_parallel_projection_height; external '3DState3.dll';
	function STATE_object_is_object; external '3DState3.dll';
	function STATE_object_is_movement_possible; external '3DState3.dll';
	function STATE_object_get_object_using_name; external '3DState3.dll';
	function STATE_object_get_name; external '3DState3.dll';
	function STATE_object_get_type_name; external '3DState3.dll';
	function STATE_object_set_name; external '3DState3.dll';
	function STATE_object_set_type_name; external '3DState3.dll';
	function STATE_object_get_object_type_number; external '3DState3.dll';
	procedure STATE_object_set_object_type_number; external '3DState3.dll';
	function STATE_object_get_control_type_number; external '3DState3.dll';
	procedure STATE_object_set_control_type_number; external '3DState3.dll';
	function STATE_object_get_track_name; external '3DState3.dll';
	function STATE_object_get_track_handle; external '3DState3.dll';
	function STATE_object_get_first_object; external '3DState3.dll';
	function STATE_object_get_next_object; external '3DState3.dll';
	procedure STATE_object_set_location; external '3DState3.dll';
	procedure STATE_object_get_location; external '3DState3.dll';
	procedure STATE_object_move; external '3DState3.dll';
	procedure STATE_object_set_direction; external '3DState3.dll';
	procedure STATE_object_get_direction; external '3DState3.dll';
	function STATE_object_set_axis_system; external '3DState3.dll';
	procedure STATE_object_get_axis_system; external '3DState3.dll';
	procedure STATE_object_get_x_axis; external '3DState3.dll';
	procedure STATE_object_get_y_axis; external '3DState3.dll';
	procedure STATE_object_get_z_axis; external '3DState3.dll';
	procedure STATE_object_rotate_x; external '3DState3.dll';
	procedure STATE_object_rotate_y; external '3DState3.dll';
	procedure STATE_object_rotate_z; external '3DState3.dll';
	procedure STATE_object_rotate_x_radians; external '3DState3.dll';
	procedure STATE_object_rotate_y_radians; external '3DState3.dll';
	procedure STATE_object_rotate_z_radians; external '3DState3.dll';
	function STATE_object_get_cos_pitch; external '3DState3.dll';
	function STATE_object_get_cos_bank; external '3DState3.dll';
	function STATE_object_get_cos_head; external '3DState3.dll';
	procedure STATE_object_get_total_move_mat; external '3DState3.dll';
	function STATE_object_get_animation; external '3DState3.dll';
	function STATE_object_replace_animation_using_names; external '3DState3.dll';
	function STATE_object_replace_animation; external '3DState3.dll';
	function STATE_object_convert_point_to_world_space; external '3DState3.dll';
	function STATE_object_convert_point_to_object_space; external '3DState3.dll';
	function STATE_object_set_track; external '3DState3.dll';
	function STATE_object_get_track_offset; external '3DState3.dll';
	function STATE_object_set_track_offset; external '3DState3.dll';
	function STATE_object_get_next_point_on_track; external '3DState3.dll';
	function STATE_object_set_next_point_on_track; external '3DState3.dll';
	procedure STATE_object_set_object_to_chase; external '3DState3.dll';
	function STATE_object_get_chased_object; external '3DState3.dll';
	procedure STATE_object_set_camera_to_chase; external '3DState3.dll';
	function STATE_object_get_chased_camera; external '3DState3.dll';
	procedure STATE_object_set_group_to_chase; external '3DState3.dll';
	function STATE_object_get_chased_group; external '3DState3.dll';
	function STATE_object_get_chase_offset; external '3DState3.dll';
	function STATE_object_set_chase_offset; external '3DState3.dll';
	function STATE_object_get_chase_softness; external '3DState3.dll';
	procedure STATE_object_set_chase_softness; external '3DState3.dll';
	function STATE_object_get_chase_type; external '3DState3.dll';
	procedure STATE_object_set_chase_type; external '3DState3.dll';
	procedure STATE_object_set_falling_from_track; external '3DState3.dll';
	procedure STATE_object_unset_falling_from_track; external '3DState3.dll';
	procedure STATE_object_get_falling_from_track_params; external '3DState3.dll';
	procedure STATE_object_get_location_on_track_before_falling; external '3DState3.dll';
	procedure STATE_object_get_speed; external '3DState3.dll';
	procedure STATE_object_set_speed; external '3DState3.dll';
	function STATE_object_get_absolute_speed; external '3DState3.dll';
	procedure STATE_object_set_absolute_speed; external '3DState3.dll';
	procedure STATE_object_set_force; external '3DState3.dll';
	procedure STATE_object_get_force; external '3DState3.dll';
	procedure STATE_object_set_max_speed; external '3DState3.dll';
	function STATE_object_get_max_speed; external '3DState3.dll';
	procedure STATE_object_set_friction; external '3DState3.dll';
	function STATE_object_get_friction; external '3DState3.dll';
	procedure STATE_object_set_elasticity; external '3DState3.dll';
	function STATE_object_get_elasticity; external '3DState3.dll';
	procedure STATE_object_advance_all; external '3DState3.dll';
	procedure STATE_object_advance; external '3DState3.dll';
	procedure STATE_object_reset_distance_counter; external '3DState3.dll';
	function STATE_object_get_distance_counter; external '3DState3.dll';
	procedure STATE_object_get_bounding_box; external '3DState3.dll';
	function STATE_object_duplicate; external '3DState3.dll';
	procedure STATE_object_delete; external '3DState3.dll';
	procedure STATE_object_set_event; external '3DState3.dll';
	procedure STATE_object_set_event_on_animation_frame; external '3DState3.dll';
	procedure STATE_object_disable; external '3DState3.dll';
	procedure STATE_object_enable; external '3DState3.dll';
	function STATE_object_is_enabled; external '3DState3.dll';
	procedure STATE_object_set_speed_units; external '3DState3.dll';
	function STATE_object_get_speed_units; external '3DState3.dll';
	function STATE_object_get_polygon; external '3DState3.dll';
	function STATE_object_is_polygon_part_of; external '3DState3.dll';
	function STATE_object_get_number_of_polygons; external '3DState3.dll';
	procedure STATE_object_get_all_polygons; external '3DState3.dll';
	procedure STATE_object_set_chase_distance; external '3DState3.dll';
	function STATE_object_get_chase_distance; external '3DState3.dll';
	procedure STATE_object_make_non_collisional; external '3DState3.dll';
	procedure STATE_object_make_collisional; external '3DState3.dll';
	function STATE_object_is_collisional; external '3DState3.dll';
	procedure STATE_object_cancel_collision_test_for_chase_physics; external '3DState3.dll';
	procedure STATE_object_enable_collision_test_for_chase_physics; external '3DState3.dll';
	function STATE_object_is_collision_test_for_chase_physics; external '3DState3.dll';
	procedure STATE_object_set_physics_rotation; external '3DState3.dll';
	function STATE_object_get_physics_rotation; external '3DState3.dll';
	procedure STATE_object_set_rotation_center; external '3DState3.dll';
	procedure STATE_object_get_rotation_center; external '3DState3.dll';
	procedure STATE_object_advance_automatically; external '3DState3.dll';
	function STATE_object_set_father_object; external '3DState3.dll';
	function STATE_object_get_father_object; external '3DState3.dll';
	function STATE_object_is_objectA_included_in_objectB; external '3DState3.dll';
	function STATE_object_get_first_son; external '3DState3.dll';
	function STATE_object_get_next_son; external '3DState3.dll';
	function STATE_object_get_first_direct_son; external '3DState3.dll';
	function STATE_object_get_next_direct_son; external '3DState3.dll';
	procedure STATE_object_move_including_sons; external '3DState3.dll';
	function STATE_object_get_center_of_tree; external '3DState3.dll';
	procedure STATE_object_set_location_of_tree; external '3DState3.dll';
	procedure STATE_object_rotate_including_sons; external '3DState3.dll';
	procedure STATE_object_remove_light; external '3DState3.dll';
	procedure STATE_object_set_bitmap; external '3DState3.dll';
	function STATE_object_create; external '3DState3.dll';
	function STATE_object_create_from_file; external '3DState3.dll';
	function STATE_object_get_3D_animation; external '3DState3.dll';
	function STATE_object_set_3D_animation; external '3DState3.dll';
	function STATE_object_set_3D_sequence; external '3DState3.dll';
	function STATE_object_get_3D_sequence; external '3DState3.dll';
	procedure STATE_object_replace_3D_sequence_when_finished; external '3DState3.dll';
	procedure STATE_object_set_scale; external '3DState3.dll';
	procedure STATE_object_get_scale; external '3DState3.dll';
	function STATE_object_get_group_handle; external '3DState3.dll';
	procedure STATE_object_set_light; external '3DState3.dll';
	function STATE_object_add_polygon; external '3DState3.dll';
	function STATE_object_create_lightmap; external '3DState3.dll';
	function STATE_polygon_is_polygon; external '3DState3.dll';
	function STATE_polygon_get_handle_using_name; external '3DState3.dll';
	function STATE_polygon_set_name; external '3DState3.dll';
	function STATE_polygon_get_name; external '3DState3.dll';
	function STATE_polygon_get_handle_using_id_num; external '3DState3.dll';
	function STATE_polygon_get_first_polygon; external '3DState3.dll';
	function STATE_polygon_get_next; external '3DState3.dll';
	procedure STATE_polygon_get_plane; external '3DState3.dll';
	procedure STATE_polygon_set_color_fill; external '3DState3.dll';
	function STATE_polygon_set_bitmap_fill; external '3DState3.dll';
	function STATE_polygon_get_bitmap_name; external '3DState3.dll';
	function STATE_polygon_get_bitmap_handle; external '3DState3.dll';
	procedure STATE_polygon_get_color; external '3DState3.dll';
	function STATE_polygon_get_transparent_rgb; external '3DState3.dll';
	function STATE_polygon_get_transparent_index; external '3DState3.dll';
	function STATE_polygon_is_rotated; external '3DState3.dll';
	procedure STATE_polygon_set_rotated; external '3DState3.dll';
	function STATE_polygon_set_light_diminution; external '3DState3.dll';
	function STATE_polygon_get_light_diminution; external '3DState3.dll';
	function STATE_polygon_is_uniform_brightness; external '3DState3.dll';
	function STATE_polygon_get_brightness; external '3DState3.dll';
	function STATE_polygon_set_brightness; external '3DState3.dll';
	function STATE_polygon_get_num_of_points; external '3DState3.dll';
	procedure STATE_polygon_delete; external '3DState3.dll';
	procedure STATE_polygon_delete_point; external '3DState3.dll';
	function STATE_polygon_is_valid; external '3DState3.dll';
	function STATE_polygon_is_convex; external '3DState3.dll';
	function STATE_polygon_are_all_points_on_one_plane; external '3DState3.dll';
	function STATE_polygon_are_bitmap_x_cords_ok; external '3DState3.dll';
	function STATE_polygon_are_bitmap_y_cords_ok; external '3DState3.dll';
	function STATE_polygon_count_redundant_points; external '3DState3.dll';
	function STATE_polygon_remove_redundant_points; external '3DState3.dll';
	function STATE_polygon_get_first_point; external '3DState3.dll';
	function STATE_polygon_create; external '3DState3.dll';
	function STATE_polygon_add_point; external '3DState3.dll';
	function STATE_polygon_add_point_to_head; external '3DState3.dll';
	procedure STATE_polygon_rotate_bitmap; external '3DState3.dll';
	procedure STATE_polygon_set_bitmap_rotation; external '3DState3.dll';
	procedure STATE_polygon_mirror_horizontal_bitmap; external '3DState3.dll';
	procedure STATE_polygon_mirror_vertical_bitmap; external '3DState3.dll';
	procedure STATE_polygon_rotate_x; external '3DState3.dll';
	procedure STATE_polygon_rotate_y; external '3DState3.dll';
	procedure STATE_polygon_rotate_z; external '3DState3.dll';
	procedure STATE_polygon_rotate; external '3DState3.dll';
	procedure STATE_polygon_move; external '3DState3.dll';
	procedure STATE_polygon_set_location; external '3DState3.dll';
	procedure STATE_polygon_get_location; external '3DState3.dll';
	procedure STATE_polygon_scale; external '3DState3.dll';
	procedure STATE_polygon_flip_visible_side; external '3DState3.dll';
	function STATE_polygon_join; external '3DState3.dll';
	function STATE_polygon_match_bitmap_cords; external '3DState3.dll';
	function STATE_polygon_duplicate; external '3DState3.dll';
	function STATE_polygon_rotate_to_match_polygon; external '3DState3.dll';
	procedure STATE_polygon_move_to_match_point; external '3DState3.dll';
	function STATE_polygon_get_closest_point; external '3DState3.dll';
	procedure STATE_polygon_set_group; external '3DState3.dll';
	function STATE_polygon_get_group; external '3DState3.dll';
	function STATE_polygon_is_in_group; external '3DState3.dll';
	procedure STATE_polygon_set_orientation; external '3DState3.dll';
	function STATE_polygon_get_orientation; external '3DState3.dll';
	function STATE_polygon_is_point_inside_polygon; external '3DState3.dll';
	function STATE_polygon_is_point_inside_polygon_concave; external '3DState3.dll';
	function STATE_polygon_set_animation; external '3DState3.dll';
	function STATE_polygon_get_animation; external '3DState3.dll';
	procedure STATE_polygon_set_animation_frame; external '3DState3.dll';
	function STATE_polygon_get_animation_frame; external '3DState3.dll';
	procedure STATE_polygon_get_center; external '3DState3.dll';
	procedure STATE_polygon_set_release_save_flag; external '3DState3.dll';
	procedure STATE_polygon_disable; external '3DState3.dll';
	procedure STATE_polygon_enable; external '3DState3.dll';
	function STATE_polygon_is_disabled; external '3DState3.dll';
	procedure STATE_polygon_make_non_collisional; external '3DState3.dll';
	procedure STATE_polygon_make_collisional; external '3DState3.dll';
	function STATE_polygon_is_collisional; external '3DState3.dll';
	procedure STATE_polygon_set_translucent; external '3DState3.dll';
	function STATE_polygon_get_translucent; external '3DState3.dll';
	procedure STATE_polygon_add_patch; external '3DState3.dll';
	function STATE_polygon_add_patch_easy; external '3DState3.dll';
	procedure STATE_polygon_delete_patches; external '3DState3.dll';
	function STATE_polygon_check_intersection_with_line_segment; external '3DState3.dll';
	function STATE_polygon_check_intersection_with_another_polygon; external '3DState3.dll';
	procedure STATE_polygon_set_ambient; external '3DState3.dll';
	function STATE_polygon_get_ambient; external '3DState3.dll';
	procedure STATE_polygon_set_diffuse; external '3DState3.dll';
	function STATE_polygon_get_diffuse; external '3DState3.dll';
	procedure STATE_polygon_set_specular; external '3DState3.dll';
	function STATE_polygon_get_specular; external '3DState3.dll';
	procedure STATE_polygon_set_specular_shining; external '3DState3.dll';
	function STATE_polygon_get_specular_shining; external '3DState3.dll';
	procedure STATE_polygon_remove_light; external '3DState3.dll';
	function STATE_polygon_wrap_a_bitmap_fixed; external '3DState3.dll';
	procedure STATE_polygon_set_light; external '3DState3.dll';
	function STATE_polygon_split; external '3DState3.dll';
	function STATE_polygon_set_second_bitmap; external '3DState3.dll';
	function STATE_polygon_create_lightmap; external '3DState3.dll';
	function STATE_point_is_point; external '3DState3.dll';
	function STATE_point_get_next_point; external '3DState3.dll';
	procedure STATE_point_get_xyz; external '3DState3.dll';
	procedure STATE_point_set_xyz; external '3DState3.dll';
	procedure STATE_point_get_bitmap_xy; external '3DState3.dll';
	procedure STATE_point_set_bitmap_xy; external '3DState3.dll';
	procedure STATE_point_get_rgb; external '3DState3.dll';
	procedure STATE_point_set_rgb; external '3DState3.dll';
	function STATE_point_get_brightness; external '3DState3.dll';
	procedure STATE_point_set_brightness; external '3DState3.dll';
	function STATE_group_is_group; external '3DState3.dll';
	function STATE_group_create; external '3DState3.dll';
	function STATE_group_get_first_group; external '3DState3.dll';
	function STATE_group_get_next; external '3DState3.dll';
	function STATE_group_get_using_name; external '3DState3.dll';
	function STATE_group_get_first_polygon; external '3DState3.dll';
	function STATE_group_get_next_polygon; external '3DState3.dll';
	function STATE_group_get_father_group; external '3DState3.dll';
	function STATE_group_set_father_group; external '3DState3.dll';
	function STATE_group_is_groupA_included_in_groupB; external '3DState3.dll';
	function STATE_group_get_name; external '3DState3.dll';
	procedure STATE_group_get_rotate_reference_point; external '3DState3.dll';
	procedure STATE_group_set_rotate_reference_point; external '3DState3.dll';
	procedure STATE_group_get_center_of_mass; external '3DState3.dll';
	procedure STATE_group_get_bounding_box; external '3DState3.dll';
	procedure STATE_group_set_name; external '3DState3.dll';
	function STATE_group_get_number_of_polygons; external '3DState3.dll';
	procedure STATE_group_rotate; external '3DState3.dll';
	procedure STATE_group_rotate_using_matrix; external '3DState3.dll';
	procedure STATE_group_transform_using_matrix4x4; external '3DState3.dll';
	procedure STATE_group_set_location; external '3DState3.dll';
	procedure STATE_group_get_location; external '3DState3.dll';
	procedure STATE_group_move; external '3DState3.dll';
	procedure STATE_group_scale; external '3DState3.dll';
	function STATE_group_get_dimensions; external '3DState3.dll';
	procedure STATE_group_ungroup; external '3DState3.dll';
	function STATE_group_delete_members; external '3DState3.dll';
	function STATE_group_is_static; external '3DState3.dll';
	procedure STATE_group_set_static; external '3DState3.dll';
	procedure STATE_group_set_dynamic; external '3DState3.dll';
	procedure STATE_group_load_as_disabled; external '3DState3.dll';
	function STATE_group_get_load_as_disabled_status; external '3DState3.dll';
	function STATE_group_duplicate_tree; external '3DState3.dll';
	function STATE_group_rotate_to_match_polygon; external '3DState3.dll';
	function STATE_group_rotate_around_line_to_match_polygon; external '3DState3.dll';
	function STATE_group_rotate_to_match_direction; external '3DState3.dll';
	procedure STATE_group_move_to_match_point; external '3DState3.dll';
	function STATE_group_is_bitmap_used; external '3DState3.dll';
	function STATE_group_count_intersections; external '3DState3.dll';
	function STATE_group_get_bottom_polygon; external '3DState3.dll';
	function STATE_group_get_top_polygon; external '3DState3.dll';
	function STATE_group_get_front_polygon; external '3DState3.dll';
	function STATE_group_get_back_polygon; external '3DState3.dll';
	procedure STATE_group_set_orientation; external '3DState3.dll';
	function STATE_group_calculate_axis_system; external '3DState3.dll';
	procedure STATE_group_set_name_to_chase; external '3DState3.dll';
	function STATE_group_get_chased_name; external '3DState3.dll';
	function STATE_group_get_chase_offset; external '3DState3.dll';
	function STATE_group_set_chase_offset; external '3DState3.dll';
	function STATE_group_get_chase_softness; external '3DState3.dll';
	procedure STATE_group_set_chase_softness; external '3DState3.dll';
	function STATE_group_get_chase_type_name; external '3DState3.dll';
	function STATE_group_get_chase_type; external '3DState3.dll';
	procedure STATE_group_set_chase_type; external '3DState3.dll';
	procedure STATE_group_set_track_name; external '3DState3.dll';
	function STATE_group_get_track_name; external '3DState3.dll';
	procedure STATE_group_get_track_offset; external '3DState3.dll';
	procedure STATE_group_set_track_offset; external '3DState3.dll';
	procedure STATE_group_set_falling_from_track; external '3DState3.dll';
	procedure STATE_group_unset_falling_from_track; external '3DState3.dll';
	procedure STATE_group_get_falling_from_track_params; external '3DState3.dll';
	procedure STATE_group_get_speed; external '3DState3.dll';
	procedure STATE_group_set_speed; external '3DState3.dll';
	function STATE_group_get_absolute_speed; external '3DState3.dll';
	procedure STATE_group_set_absolute_speed; external '3DState3.dll';
	function STATE_group_rotate_to_match_axis_system; external '3DState3.dll';
	function STATE_group_rotate_around_line; external '3DState3.dll';
	function STATE_group_wrap_a_bitmap; external '3DState3.dll';
	function STATE_group_reduce_polygons_count; external '3DState3.dll';
	function STATE_group_create_reduced_copy; external '3DState3.dll';
	function STATE_group_create_copy_made_of_triangles; external '3DState3.dll';
	function STATE_group_is_rotation_enabled; external '3DState3.dll';
	function STATE_group_convert_point_to_world_space; external '3DState3.dll';
	function STATE_group_convert_point_to_group_space; external '3DState3.dll';
	procedure STATE_group_set_chase_distance; external '3DState3.dll';
	function STATE_group_get_chase_distance; external '3DState3.dll';
	procedure STATE_group_delete_patches; external '3DState3.dll';
	procedure STATE_group_set_patches_color; external '3DState3.dll';
	procedure STATE_group_set_patches_bitmap; external '3DState3.dll';
	procedure STATE_group_set_patches_translucent; external '3DState3.dll';
	function STATE_group_get_physics_rotation; external '3DState3.dll';
	procedure STATE_group_set_physics_rotation; external '3DState3.dll';
	procedure STATE_group_set_physics_force; external '3DState3.dll';
	procedure STATE_group_get_physics_force; external '3DState3.dll';
	function STATE_group_get_physics_friction; external '3DState3.dll';
	procedure STATE_group_set_physics_friction; external '3DState3.dll';
	function STATE_group_get_physics_elasticity; external '3DState3.dll';
	procedure STATE_group_set_physics_elasticity; external '3DState3.dll';
	function STATE_group_get_physics_maxspeed; external '3DState3.dll';
	procedure STATE_group_set_physics_maxspeed; external '3DState3.dll';
	procedure STATE_group_set_control_number; external '3DState3.dll';
	function STATE_group_get_control_number; external '3DState3.dll';
	function STATE_group_wrap_a_bitmap_fixed; external '3DState3.dll';
	procedure STATE_group_light_group; external '3DState3.dll';
	procedure STATE_group_remove_light; external '3DState3.dll';
	procedure STATE_group_set_color; external '3DState3.dll';
	procedure STATE_group_set_light; external '3DState3.dll';
	procedure STATE_group_set_ambient; external '3DState3.dll';
	procedure STATE_group_set_diffuse; external '3DState3.dll';
	procedure STATE_group_set_specular; external '3DState3.dll';
	function STATE_group_create_lightmap; external '3DState3.dll';
	function STATE_3D_animation_get_first; external '3DState3.dll';
	function STATE_3D_animation_get_next; external '3DState3.dll';
	procedure STATE_3D_animation_delete_all; external '3DState3.dll';
	procedure STATE_3D_animation_delete; external '3DState3.dll';
	function STATE_3D_animation_get_using_name; external '3DState3.dll';
	function STATE_3D_animation_get_name; external '3DState3.dll';
	function STATE_3D_animation_is_3D_animation; external '3DState3.dll';
	function STATE_3D_sequence_get_first; external '3DState3.dll';
	function STATE_3D_sequence_get_next; external '3DState3.dll';
	function STATE_3D_sequence_get_using_name; external '3DState3.dll';
	function STATE_3D_sequence_get_name; external '3DState3.dll';
	procedure STATE_3D_sequence_delete_all; external '3DState3.dll';
	procedure STATE_3D_sequence_delete; external '3DState3.dll';
	function STATE_3D_sequence_is_3D_sequence; external '3DState3.dll';
	procedure STATE_3D_sequence_set_speed; external '3DState3.dll';
	function STATE_3D_sequence_get_speed; external '3DState3.dll';
	function STATE_3D_sequence_get_number_of_frames; external '3DState3.dll';
	function STATE_3D_sequence_get_frame_duration; external '3DState3.dll';
	function STATE_3D_sequence_set_frame_duration; external '3DState3.dll';
	function STATE_3D_sequence_is_cyclic; external '3DState3.dll';
	procedure STATE_3D_sequence_set_cyclic; external '3DState3.dll';
	procedure STATE_3D_sequence_set_current_frame; external '3DState3.dll';
	function STATE_3D_sequence_get_current_frame; external '3DState3.dll';
	procedure STATE_3D_sequence_pause; external '3DState3.dll';
	procedure STATE_3D_sequence_play; external '3DState3.dll';
	function STATE_3D_sequence_is_paused; external '3DState3.dll';
	procedure STATE_3D_sequence_backwards_play; external '3DState3.dll';
	function STATE_3D_sequence_is_backwards; external '3DState3.dll';
	function STATE_3D_sequence_get_number_of_laps; external '3DState3.dll';
	function STATE_3D_sequence_duplicate; external '3DState3.dll';
	function STATE_light_create; external '3DState3.dll';
	procedure STATE_light_activate; external '3DState3.dll';
	function STATE_light_get_using_name; external '3DState3.dll';
	function STATE_light_get_first_light; external '3DState3.dll';
	function STATE_light_get_next_light; external '3DState3.dll';
	procedure STATE_light_set_location; external '3DState3.dll';
	procedure STATE_light_get_location; external '3DState3.dll';
	procedure STATE_light_point_at; external '3DState3.dll';
	procedure STATE_light_set_direction; external '3DState3.dll';
	procedure STATE_light_get_direction; external '3DState3.dll';
	procedure STATE_light_set_color; external '3DState3.dll';
	procedure STATE_light_get_color; external '3DState3.dll';
	procedure STATE_light_remove_light; external '3DState3.dll';
	procedure STATE_light_set_type_of_light; external '3DState3.dll';
	function STATE_light_get_type_of_light; external '3DState3.dll';
	procedure STATE_light_set_ray_tracing; external '3DState3.dll';
	function STATE_light_is_ray_tracing; external '3DState3.dll';
	procedure STATE_light_set_distance_reach; external '3DState3.dll';
	function STATE_light_get_distance_reach; external '3DState3.dll';
	function STATE_light_set_entity_to_light; external '3DState3.dll';
	function STATE_light_get_entity_to_light; external '3DState3.dll';
	procedure STATE_light_activate_before_each_render; external '3DState3.dll';
	function STATE_light_is_activated_before_render; external '3DState3.dll';
	procedure STATE_light_set_ambient; external '3DState3.dll';
	procedure STATE_light_set_diffuse; external '3DState3.dll';
	procedure STATE_light_set_specular; external '3DState3.dll';
	function STATE_light_get_ambient; external '3DState3.dll';
	function STATE_light_get_diffuse; external '3DState3.dll';
	function STATE_light_get_specular; external '3DState3.dll';
	procedure STATE_light_set_specular_shining; external '3DState3.dll';
	function STATE_light_get_specular_shining; external '3DState3.dll';
	function STATE_light_is_light; external '3DState3.dll';
	procedure STATE_light_delete_all; external '3DState3.dll';
	procedure STATE_light_delete; external '3DState3.dll';
	function STATE_light_get_name; external '3DState3.dll';
	procedure STATE_light_set_name; external '3DState3.dll';
	function STATE_animation_is_animation; external '3DState3.dll';
	function STATE_animation_get_handle; external '3DState3.dll';
	function STATE_animation_get_first_animation; external '3DState3.dll';
	function STATE_animation_get_next; external '3DState3.dll';
	function STATE_animation_create; external '3DState3.dll';
	function STATE_animation_add_bitmap; external '3DState3.dll';
	function STATE_animation_remove_bitmap; external '3DState3.dll';
	function STATE_animation_get_bitmap; external '3DState3.dll';
	function STATE_animation_set_times; external '3DState3.dll';
	function STATE_animation_get_times; external '3DState3.dll';
	function STATE_animation_get_frame_time; external '3DState3.dll';
	function STATE_animation_set_frame_time; external '3DState3.dll';
	function STATE_animation_get_name; external '3DState3.dll';
	procedure STATE_animation_set_name; external '3DState3.dll';
	procedure STATE_animation_factor_speed; external '3DState3.dll';
	procedure STATE_animation_set_speed; external '3DState3.dll';
	procedure STATE_animation_delete_all; external '3DState3.dll';
	procedure STATE_animation_delete; external '3DState3.dll';
	procedure STATE_animation_set_save_flag; external '3DState3.dll';
	function STATE_animation_get_save_flag; external '3DState3.dll';
	function STATE_animation_get_number_of_frames; external '3DState3.dll';
	function STATE_animation_get_number_of_bitmaps; external '3DState3.dll';
	procedure STATE_animation_get_all_bitmaps; external '3DState3.dll';
	function STATE_animation_is_part_of_the_last_world; external '3DState3.dll';
	function STATE_animation_get_number_of_polygons_with_animation; external '3DState3.dll';
	function STATE_animation_duplicate; external '3DState3.dll';
	function STATE_animation_set_bitmap; external '3DState3.dll';
	function STATE_animation_get_frame_bitmap_name; external '3DState3.dll';
	function STATE_animation_get_frame_transparent_index; external '3DState3.dll';
	function STATE_bitmap_is_bitmap; external '3DState3.dll';
	function STATE_bitmap_get_handle; external '3DState3.dll';
	function STATE_bitmap_get_first_bitmap; external '3DState3.dll';
	function STATE_bitmap_get_next; external '3DState3.dll';
	function STATE_bitmap_load; external '3DState3.dll';
	function STATE_bitmap_rgb_color_to_index; external '3DState3.dll';
	function STATE_bitmap_index_to_rgb; external '3DState3.dll';
	function STATE_bitmap_get_transparent_rgb; external '3DState3.dll';
	function STATE_bitmap_get_transparent_index; external '3DState3.dll';
	function STATE_bitmap_resample; external '3DState3.dll';
	procedure STATE_bitmap_unload; external '3DState3.dll';
	function STATE_bitmap_get_name; external '3DState3.dll';
	function STATE_bitmap_get_number_of_polygons_using_bitmap; external '3DState3.dll';
	function STATE_bitmap_get_width; external '3DState3.dll';
	function STATE_bitmap_get_height; external '3DState3.dll';
	function STATE_bitmap_get_memory; external '3DState3.dll';
	function STATE_bitmap_get_palette; external '3DState3.dll';
	function STATE_bitmap_set_palette_color; external '3DState3.dll';
	function STATE_bitmap_get_palette_size; external '3DState3.dll';
	procedure STATE_bitmap_save; external '3DState3.dll';
	function STATE_sound_load; external '3DState3.dll';
//	function STATE_sound_play; external '3DState3.dll';
	function STATE_sound_attach; external '3DState3.dll';
	procedure STATE_sound_play_all_sounds; external '3DState3.dll';
	function STATE_sound_stop; external '3DState3.dll';
	procedure STATE_sound_stop_all_sounds; external '3DState3.dll';
	function STATE_sound_get_first; external '3DState3.dll';
	function STATE_sound_set_distance_reach; external '3DState3.dll';
	function STATE_sound_get_next; external '3DState3.dll';
	procedure STATE_sound_set_volume; external '3DState3.dll';
	function STATE_sound_get_volume; external '3DState3.dll';
	procedure STATE_sound_set_frequency; external '3DState3.dll';
	function STATE_sound_get_frequency; external '3DState3.dll';
	function STATE_sound_is_sound_playing; external '3DState3.dll';
	function STATE_sound_set_sound_name; external '3DState3.dll';
	function STATE_sound_get_sound_name; external '3DState3.dll';
	function STATE_sound_get_handle_using_name; external '3DState3.dll';
	function STATE_sound_get_handle_using_entity; external '3DState3.dll';
	procedure STATE_sound_set_pause_mode; external '3DState3.dll';
	procedure STATE_sound_CD_play; external '3DState3.dll';
	procedure STATE_sound_CD_stop; external '3DState3.dll';
	function STATE_sound_CD_get_track; external '3DState3.dll';
	function STATE_sound_CD_get_num_of_tracks; external '3DState3.dll';
	procedure STATE_sound_CD_set_pause_mode; external '3DState3.dll';
	procedure STATE_sound_CD_eject; external '3DState3.dll';
	function STATE_track_is_track; external '3DState3.dll';
	function STATE_track_get_using_name; external '3DState3.dll';
	function STATE_track_is_cyclic; external '3DState3.dll';
	function STATE_track_get_name; external '3DState3.dll';
	procedure STATE_track_set_name; external '3DState3.dll';
	function STATE_track_get_number_of_points; external '3DState3.dll';
	function STATE_track_get_first_track; external '3DState3.dll';
	function STATE_track_get_next; external '3DState3.dll';
	function STATE_track_get_point; external '3DState3.dll';
	function STATE_track_get_point_element; external '3DState3.dll';
	function STATE_track_get_points; external '3DState3.dll';
	function STATE_track_find_closest_point_on_track; external '3DState3.dll';
	function STATE_track_create; external '3DState3.dll';
	procedure STATE_track_set_points_buffer; external '3DState3.dll';
	procedure STATE_track_set_number_of_points; external '3DState3.dll';
	procedure STATE_track_delete; external '3DState3.dll';
	procedure STATE_track_delete_all; external '3DState3.dll';
	procedure STATE_track_set_save_flag; external '3DState3.dll';
	function STATE_track_get_save_flag; external '3DState3.dll';
	function STATE_background_is_background; external '3DState3.dll';
	function STATE_background_get_handle; external '3DState3.dll';
	function STATE_background_get_first_background; external '3DState3.dll';
	function STATE_background_get_next; external '3DState3.dll';
	function STATE_background_create; external '3DState3.dll';
	procedure STATE_background_set_name; external '3DState3.dll';
	function STATE_background_get_name; external '3DState3.dll';
	procedure STATE_background_set_distance; external '3DState3.dll';
	function STATE_background_get_distance; external '3DState3.dll';
	procedure STATE_background_set_bottom; external '3DState3.dll';
	function STATE_background_get_bottom; external '3DState3.dll';
	function STATE_background_set_bottom_intensity; external '3DState3.dll';
	function STATE_background_get_bottom_intensity; external '3DState3.dll';
	function STATE_background_set_intensity_step; external '3DState3.dll';
	function STATE_background_get_intensity_step; external '3DState3.dll';
	procedure STATE_background_delete; external '3DState3.dll';
	procedure STATE_background_delete_all; external '3DState3.dll';
	procedure STATE_background_use; external '3DState3.dll';
	function STATE_background_get_current_background; external '3DState3.dll';
	procedure STATE_background_set_save_flag; external '3DState3.dll';
	function STATE_background_get_save_flag; external '3DState3.dll';
	procedure STATE_background_set_bitmap; external '3DState3.dll';
	function STATE_background_get_bitmap; external '3DState3.dll';
	function STATE_background_get_bitmap_name; external '3DState3.dll';
	function STATE_entity_get_name; external '3DState3.dll';
	function STATE_entity_create_lightmap; external '3DState3.dll';
	function STATE_3D_card_check_hardware_support; external '3DState3.dll';
	function STATE_3D_card_use; external '3DState3.dll';
	function STATE_3D_card_use_detailed; external '3DState3.dll';
	function STATE_3D_card_is_used; external '3DState3.dll';
	function STATE_3D_card_set_full_screen_mode; external '3DState3.dll';
	function STATE_3D_card_is_full_screen_mode; external '3DState3.dll';
	function STATE_3D_card_set_window_mode; external '3DState3.dll';
	procedure STATE_3D_card_hide_driver_selection_window; external '3DState3.dll';
	function STATE_3D_card_is_driver_selection_window_visible; external '3DState3.dll';
	function STATE_utilities_file_to_memory; external '3DState3.dll';
	procedure STATE_utilities_paste_resource_bitmap; external '3DState3.dll';
	procedure STATE_utilities_paste_bitmap; external '3DState3.dll';
	procedure STATE_utilities_copy_bitmap_on_dc; external '3DState3.dll';
	function STATE_utilities_load_bitmap_from_file; external '3DState3.dll';
	function STATE_utilities_save_bitmap; external '3DState3.dll';
	function STATE_utilities_resample_bitmap; external '3DState3.dll';
	function STATE_utilities_jpg2bmp; external '3DState3.dll';
	function STATE_utilities_bmp2jpg; external '3DState3.dll';
	function STATE_utilities_convert_3d_formats; external '3DState3.dll';
	procedure STATE_utilities_rgb16_to_rgb24; external '3DState3.dll';
	function STATE_utilities_is_windows98; external '3DState3.dll';
	function STATE_utilities_save_screenshot; external '3DState3.dll';
	procedure STATE_utilities_test_address; external '3DState3.dll';
	function STATE_utilities_test_string; external '3DState3.dll';
	procedure STATE_utilities_test_LPSTR; external '3DState3.dll';
	procedure STATE_utilities_test_LPCSTR; external '3DState3.dll';
	procedure STATE_utilities_test_PDWORD; external '3DState3.dll';
	procedure STATE_utilities_test_2PDWORD; external '3DState3.dll';
	function STATE_math_get_square_distance; external '3DState3.dll';
	function STATE_math_get_distance; external '3DState3.dll';
	function STATE_math_does_segment_intersect_plane; external '3DState3.dll';
	function STATE_math_get_distance_between_point_and_line; external '3DState3.dll';
	function STATE_math_get_closest_point_on_line; external '3DState3.dll';
	function STATE_math_is_point_on_segment; external '3DState3.dll';
	function STATE_math_points_to_plane; external '3DState3.dll';
	function STATE_math_get_plane_point_relations; external '3DState3.dll';
	function STATE_math_get_reflected_direction; external '3DState3.dll';
	function STATE_math_product; external '3DState3.dll';
	procedure STATE_math_cross; external '3DState3.dll';
	function STATE_math_normalize_vector; external '3DState3.dll';
	function STATE_math_get_vector_length; external '3DState3.dll';
	function STATE_profiler_start_measuring; external '3DState3.dll';
	procedure STATE_profiler_end_measuring; external '3DState3.dll';

        function STATE_object_delete_polygon; external '3DState3.dll';
        function STATE_engine_create_speed_database; external '3DState3.dll';

//???        procedure STATE_3D_card_get_directx_internals(void **IDirectDraw4_object, void **IDirect3D3_object, void **IDirect3DDevice3_device, void **IDirectDrawSurface4_primary_surface, void **IDirectDrawSurface4_back_surface, void **IDirectDrawSurface4_zbuffer, void **IDirect3DViewport3_viewport);
        //STATE_IMPORT void STATE_WINAPI STATE_3D_card_get_directx_internals(void **IDirectDraw4_object, void **IDirect3D3_object, void **IDirect3DDevice3_device, void **IDirectDrawSurface4_primary_surface, void **IDirectDrawSurface4_back_surface, void **IDirectDrawSurface4_zbuffer, void **IDirect3DViewport3_viewport);

        //Returns YES or NO. YES is returned if multiple texture blending is supported by the 3D card
        function STATE_3D_card_is_multiple_texture_blending_supported; external '3DState3.dll';
        function STATE_sound_play; external '3DState3.dll';
        procedure STATE_engine_set_stereoscopic_mode; external '3DState3.dll';
        function STATE_camera_move_with_collision_detection; external '3DState3.dll';
        function STATE_polygon_get_patch_type; external '3DState3.dll';
        function STATE_engine_switch_stereoscopic_mode; external '3DState3.dll';
        function STATE_engine_get_stereoscopic_mode; external '3DState3.dll';
        function STATE_engine_get_stereoscopic_mode_name; external '3DState3.dll';
end.
