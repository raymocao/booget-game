extends Node

var budget_config:BudgetConfig = BudgetConfig.new();
var data:PlayerData = PlayerData.new(); 

func setup_default():
	data.living_budget_remaining = budget_config.living_budget;
	data.fun_budget_remaining = budget_config.fun_budget;
	data.fun_pool = 0.0;
	data.current_month_transactions.clear();
	data.transactions.clear();

func add_transaction(transaction:Transaction):
	if (transaction.transaction_category == Main.BudgetCategory.LIVING):
		data.living_budget_remaining -= transaction.transaction_amount;
	elif (transaction.transaction_category == Main.BudgetCategory.FUN):
		data.fun_budget_remaining -= transaction.transaction_amount;
	
	if (data.living_budget_remaining < 0):
		data.fun_budget_remaining += data.living_budget_remaining;
		
		var spill_over_transaction = Transaction.new();
		spill_over_transaction.transaction_amount = -data.living_budget_remaining;
		spill_over_transaction.transaction_name = transaction.transaction_name + " (SPILL-OVER)";
		spill_over_transaction.transaction_category = Main.BudgetCategory.FUN;
		spill_over_transaction.transaction_subcategory = "Spill Over";
		data.current_month_transactions.append(spill_over_transaction);
		data.transactions.append(spill_over_transaction);
		
		transaction.transaction_amount += data.living_budget_remaining;
		data.living_budget_remaining = 0;
	
	if (data.fun_budget_remaining < 0):
		data.fun_pool += data.fun_budget_remaining;
		data.fun_budget_remaining = 0;
	
	data.current_month_transactions.append(transaction);
	data.transactions.append(transaction);
