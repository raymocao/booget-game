class_name Main

extends Node

enum BudgetCategory {LIVING, FUN}


func _ready():
	start_game();

func _on_hud_add_transaction(transaction) -> void:
	$Player.add_transaction(transaction.transaction_amount, transaction.transaction_category);
	$HUD.update_lb($Player.living_budget_remaining);
	$HUD.update_fb($Player.fun_budget_remaining);

func start_game():
	$HUD.update_lb($Player.living_budget_remaining);
	$HUD.update_fb($Player.fun_budget_remaining);

func _on_hud_end_game() -> void:
	#save game
	get_tree().quit();
