extends CanvasLayer

signal add_transaction(transaction);
signal end_game();

func _ready():
	load_main_screen();
	populate_categories();

func load_main_screen():
	$MainMarginContainer.show();
	$MainMarginContainer/BudgetLabels/LB.show();
	$MainMarginContainer/BudgetLabels/FB.show();
	$MainMarginContainer/BudgetLabels/FP.show();
	$MainMarginContainer/"Add Transaction".show();
	$ExitMarginContainer.hide();
	hide_menus();

func hide_menus():
	$MenuMarginContainer.hide();
	$MenuMarginContainer/AddTransactionContainer.hide();

func populate_categories():
	for c in Main.BudgetCategory:
		$MenuMarginContainer/AddTransactionContainer/VBoxContainer/CategoryOptionButton.add_item(c);

func update_lb(num):
	$MainMarginContainer/BudgetLabels/LB.text = "Living Budget Remaining: $" + str("%0.2f" % num);

func update_fb(num):
	$MainMarginContainer/BudgetLabels/FB.text = "Fun Budget Remaining: $" + str("%0.2f" % num);

func update_fp(num):
	$MainMarginContainer/BudgetLabels/FP.text = "Fun Pool: $" + str("%0.2f" % num);

func _on_add_transaction_pressed():
	$MainMarginContainer.hide();
	$MenuMarginContainer.show();
	$MenuMarginContainer/AddTransactionContainer.show();

func _on_exit_pressed() -> void:
	$MainMarginContainer.hide();
	$ExitMarginContainer.show();

func _on_exit_confirm_pressed() -> void:
	end_game.emit();

func _on_exit_cancel_pressed() -> void:
	load_main_screen();

func _on_menu_close_button_pressed() -> void:
	load_main_screen();

func _on_confirm_transaction_button_pressed() -> void:
	var transaction = Transaction.new();
	transaction.transaction_name = $MenuMarginContainer/AddTransactionContainer/VBoxContainer/TransactionNameLineEdit.text
	transaction.transaction_amount = $MenuMarginContainer/AddTransactionContainer/VBoxContainer/TransactionAmount.value;
	transaction.transaction_category = Main.BudgetCategory.get($MenuMarginContainer/AddTransactionContainer/VBoxContainer/CategoryOptionButton.get_item_text($MenuMarginContainer/AddTransactionContainer/VBoxContainer/CategoryOptionButton.selected));
	add_transaction.emit(transaction);
