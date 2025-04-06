extends Node

var budget_config:BudgetConfig = BudgetConfig.new();
var data:PlayerData = PlayerData.new(); 

func setup_default():
	data.living_budget_remaining = budget_config.living_budget;
	data.fun_budget_remaining = budget_config.fun_budget;

func add_transaction(transaction:Transaction):
	if (transaction.transaction_category == Main.BudgetCategory.LIVING):
		data.living_budget_remaining -= transaction.transaction_amount;
	elif (transaction.transaction_category == Main.BudgetCategory.FUN):
		data.fun_budget_remaining -= transaction.transaction_amount;
	
	if (data.living_budget_remaining < 0):
		data.fun_budget_remaining += data.living_budget_remaining;
		data.living_budget_remaining = 0;
	
	if (data.fun_budget_remaining < 0):
		data.fun_pool += data.fun_budget_remaining;
		data.fun_budget_remaining = 0;
	
	data.transactions.append(transaction);
