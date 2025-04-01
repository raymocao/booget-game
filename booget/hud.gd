extends CanvasLayer

signal add_transaction(transaction);
signal end_game();

func _ready():
	load_main_screen();

func load_main_screen():
	$MainMarginContainer.show();
	$MainMarginContainer/BudgetLabels/LB.show();
	$MainMarginContainer/BudgetLabels/FB.show();
	$MainMarginContainer/BudgetLabels/FP.show();
	$MainMarginContainer/"Add Transaction".show();
	$ExitMarginContainer.hide();

func update_lb(num):
	$MainMarginContainer/BudgetLabels/LB.text = "Living Budget Remaining: " + str(num);

func update_fb(num):
	$MainMarginContainer/BudgetLabels/FB.text = "Fun Budget Remaining: " + str(num);

func update_fp(num):
	$MainMarginContainer/BudgetLabels/FP.text = "Fun Pool: " + str(num);

func _on_add_transaction_pressed():
	var transaction = Transaction.new();
	transaction.transaction_amount = 550;
	transaction.transaction_category = Main.BudgetCategory.LIVING;
	add_transaction.emit(transaction);

func _on_exit_pressed() -> void:
	$MainMarginContainer.hide();
	$ExitMarginContainer.show();

func _on_exit_confirm_pressed() -> void:
	end_game.emit();

func _on_exit_cancel_pressed() -> void:
	load_main_screen();
