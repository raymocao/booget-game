class_name SaverLoader
extends Node

@onready var player = $"../Player";

func save_config():
	var config = ConfigFile.new();
	
	config.set_value("player", "living_budget", player.budget_config.living_budget);
	config.set_value("player", "fun_budget", player.budget_config.fun_budget);
	config.set_value("player", "roll_value", player.budget_config.roll_value);
	config.set_value("player", "monthly_income", player.budget_config.monthly_income);
	
	config.save("user://config.ini");

func save_player():
	ResourceSaver.save(player.data, "user://savedata.tres")

func load_game():
	var config = ConfigFile.new();
	
	print(OS.get_data_dir())
	
	var err = config.load("user://config.ini");
	if err != OK:
		return
	
	player.budget_config.living_budget = config.get_value("player", "living_budget");
	player.budget_config.fun_budget = config.get_value("player", "fun_budget");
	player.budget_config.roll_value = config.get_value("player", "roll_value");
	player.budget_config.monthly_income = config.get_value("player", "monthly_income");
	
	var data = load("user://savedata.tres") as PlayerData;
	
	if (data == null):
		player.setup_default();
	else:
		player.data = data;
