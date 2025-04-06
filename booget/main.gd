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
	hud.update_lb(player.data.living_budget_remaining);
	hud.update_fb(player.data.fun_budget_remaining);
	hud.update_fp(player.data.fun_pool);

func start_game():
	saver_loader.load_game();
	hud.update_lb(player.data.living_budget_remaining);
	hud.update_fb(player.data.fun_budget_remaining);
	hud.update_fp(player.data.fun_pool);

func _on_hud_end_game() -> void:
	saver_loader.save_config();
	saver_loader.save_player();
	get_tree().quit();
