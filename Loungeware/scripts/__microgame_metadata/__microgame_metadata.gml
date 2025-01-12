function ___init_metadata(){
	// do not edit this file.
	// see datafiles/config.example.json for instructions
	// change this file? banned for life
	SET_TEST_VARS { 
		test_mode_on: false,
		microgame_key: "",
		loop_game: false,
		difficulty_level: 1,
		mute_test: false,
		skip_transition_animation: false
	}
	
	var env = __try_read_json("config.dev.json");
	if(env != undefined){
		show_debug_message("INFO: Loading dev env");
		SET_TEST_VARS { 
			test_mode_on: variable_struct_exists(env, "test_mode_on") ? env[$"test_mode_on"]: false,
			microgame_key: variable_struct_exists(env, "microgame_key") ? env[$"microgame_key"]: "",
			loop_game: variable_struct_exists(env, "loop_game") ? env[$"loop_game"]: false,
			difficulty_level: variable_struct_exists(env, "difficulty_level") ? env[$"difficulty_level"]: false,
			mute_test: variable_struct_exists(env, "mute_test") ? env[$"mute_test"]: false,
			skip_transition_animation: variable_struct_exists(env, "skip_transition_animation") ? env[$"skip_transition_animation"]: false,
		}
	}
	
	var rules =  new LW_FGameLoaderRuleBuilder()
		.add_rule(
			new LW_FGameLoaderNumberTransformer("config_version", 0)
				.add_validator(function(version){ return version == 1; })
		)
		.add_rule(new LW_FGameLoaderStringTransformer("game_name", undefined))
		.add_rule(new LW_FGameLoaderStringTransformer("creator_name", undefined))
		.add_rule(new LW_FGameLoaderStringArrayTransformer("prompt", undefined))
		.add_rule(new LW_FGameLoaderRoomTransformer("init_room", undefined))
		.add_rule(
			new LW_FGameLoaderBoolTransformer("is_enabled", true)
				.set_nullable()
		)
		.add_rule(
			new LW_FGameLoaderNumberTransformer("view_width", -1)
				.set_nullable()
				.add_validator(function(view_width){
					return view_width == -1 || view_width > 32;	
				})
		)
		.add_rule(
			new LW_FGameLoaderNumberTransformer("view_height", -1)
				.set_nullable()
				.add_validator(function(view_height){
					return view_height == -1 || view_height > 32;	
				})
		)
		.add_rule(new LW_FGameLoaderNumberTransformer("time_seconds", -1).set_min(3).set_max(12))
		.add_rule(new LW_FGameLoaderSoundTransformer("music_track", noone).set_nullable())
		.add_rule(new LW_FGameLoaderBoolTransformer("music_loops", true).set_nullable())
		.add_rule(new LW_FGameLoaderBoolTransformer("interpolation_on", undefined))
		.add_rule(new LW_FGameLoaderColourTransformer("cartridge_col_primary", undefined))
		.add_rule(new LW_FGameLoaderColourTransformer("cartridge_col_secondary", undefined))
		.add_rule(new LW_FGameLoaderSpriteTransformer("cartridge_label", undefined))
		.add_rule(new LW_FGameLoaderBoolTransformer("default_is_fail", undefined))
		.add_rule(new LW_FGameLoaderBoolTransformer("supports_difficulty_scaling", false).set_nullable())
		.add_rule(
			new LW_FGameLoaderArrayTransformer("credits", undefined)
				.set_min(1)
				.set_inner_validator(function(val) { return is_string(val); })
			)
		.add_rule(new LW_FGameLoaderStringTransformer("date_added", undefined))
		.get_rules();

	var val = new LW_FGameLoader().get_configs(rules);
	return val;
}
