class_name Main

extends Node

enum BudgetCategory {LIVING, FUN}

@onready var player = $Player;
@onready var hud = $HUD;
@onready var saver_loader = $SaverLoader;

func _ready():
	start_game();

func _on_hud_add_transaction(transaction) -> void:
	player.add_transaction(transaction);
	update_all_hud();

func start_game():
	saver_loader.load_game();
	update_all_hud();

func _on_hud_end_game() -> void:
	saver_loader.save_config();
	saver_loader.save_player();
	get_tree().quit();

func update_all_hud():
	hud.update_lb(player.data.living_budget_remaining);
	hud.update_fb(player.data.fun_budget_remaining);
	hud.update_fp(player.data.fun_pool);
	hud.update_config_hud(player.budget_config);

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
