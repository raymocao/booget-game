extends CanvasLayer

signal add_transaction(transaction);

func show_lb():
	$LB.text = 0;
	$LB.show();

func show_fb():
	$FB.text = 0;
	$FB.show();

func update_lb(num):
	$LB.text = "Living Budget Remaining: " + str(num);

func update_fb(num):
	$FB.text = "Fun Budget Remaining: " + str(num);

func _on_add_transaction_pressed():
	var transaction = Transaction.new();
	transaction.transaction_amount = 10;
	transaction.transaction_category = Main.BudgetCategory.LIVING;
	add_transaction.emit(transaction);
