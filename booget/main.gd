class_name Main

extends Node

enum BudgetCategory {LIVING, FUN}

@onready var player = $Player;
@onready var hud = $HUD;

func _ready():
	start_game();

func _on_hud_add_transaction(transaction) -> void:
	player.add_transaction(transaction.transaction_amount, transaction.transaction_category);
	hud.update_lb(player.living_budget_remaining);
	hud.update_fb(player.fun_budget_remaining);
	hud.update_fp(player.fun_pool);

func start_game():
	hud.update_lb(player.living_budget_remaining);
	hud.update_fb(player.fun_budget_remaining);
	hud.update_fp(player.fun_pool);

func _on_hud_end_game() -> void:
	#save game
	get_tree().quit();
