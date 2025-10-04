class_name Main

extends Node

enum BudgetCategory {LIVING, FUN}

@onready var player = $Player;
@onready var subcategories:Subcategories = $Subcategories;
@onready var hud = $HUD;
@onready var saver_loader = $SaverLoader;

func _ready():
	start_game();

func _on_hud_add_transaction(transaction) -> void:
	player.add_transaction(transaction);
	update_all_hud();

func start_game():
	saver_loader.load_game();
	do_rollovers();
	update_all_hud();

func _on_hud_end_game() -> void:
	saver_loader.save_config();
	saver_loader.save_player();
	get_tree().quit();

func update_all_hud():
	hud.set_subcategories(subcategories);
	hud.set_current_month_transactions(player.data.current_month_transactions);
	hud.update_lb(player.data.living_budget_remaining);
	hud.update_fb(player.data.fun_budget_remaining);
	hud.update_fp(player.data.fun_pool);
	hud.update_config_hud(player.budget_config);

func do_rollovers():
	var now_time = Time.get_date_dict_from_system();
	if (check_day_rollover(now_time)):
		do_day_rollover();
	
	if (check_week_rollover(now_time)):
		do_week_rollover();
	
	if (check_mon_rollover(now_time)):
		do_mon_rollover();
	
	player.data.current_day = now_time["day"];
	player.data.current_weekday = now_time["weekday"];
	player.data.current_month = now_time["month"];
	player.data.current_year = now_time["year"];

func check_day_rollover(now_time: Dictionary) -> bool:
	if (check_mon_rollover(now_time) or check_week_rollover(now_time)):
		return true;
	
	var now_day = now_time["day"];
	if (player.data.current_day < now_day):
		return true;
	
	return false;

func check_week_rollover(now_time: Dictionary) -> bool:
	var now_weekday = now_time["weekday"];
	if (player.data.current_weekday > now_weekday):
		return true;
	
	return false;

func check_mon_rollover(now_time: Dictionary) -> bool:
	var now_year = now_time["year"];
	var now_month = now_time["month"];
	if (player.data.current_year < now_year):
		return true;
	
	if (player.data.current_year < now_month):
		return true;
		
	return false;

func do_day_rollover():
	pass;

func do_week_rollover():
	pass;

func do_mon_rollover():
	player.data.fun_pool += player.data.living_budget_remaining;
	player.data.fun_pool += player.data.fun_budget_remaining;
	player.data.living_budget_remaining = player.budget_config.living_budget;
	player.data.fun_budget_remaining = player.budget_config.fun_budget;
	player.data.current_month_transactions.clear();

func _on_hud_update_config(config: BudgetConfig) -> void:
	if (config == null):
		hud.update_config_hud(player.budget_config);
		return;
	
	player.budget_config = config;
	hud.update_config_hud(player.budget_config);

func _on_hud_reset_game() -> void:
	player.setup_default();
	update_all_hud();
	saver_loader.save_player();
