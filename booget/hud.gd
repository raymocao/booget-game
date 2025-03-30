extends CanvasLayer

signal add_transaction(transaction);
signal end_game();

func _ready():
	$MarginContainer/VBoxContainer/LB.show();
	$MarginContainer/VBoxContainer/FB.show();
	$MarginContainer/"Add Transaction".show();

func update_lb(num):
	$MarginContainer/VBoxContainer/LB.text = "Living Budget Remaining: " + str(num);

func update_fb(num):
	$MarginContainer/VBoxContainer/FB.text = "Fun Budget Remaining: " + str(num);

func _on_add_transaction_pressed():
	var transaction = Transaction.new();
	transaction.transaction_amount = 10;
	transaction.transaction_category = Main.BudgetCategory.LIVING;
	add_transaction.emit(transaction);

func _on_exit_pressed() -> void:
	end_game.emit();
