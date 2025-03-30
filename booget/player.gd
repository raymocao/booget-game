extends Node

@export var living_budget = 1500;
@export var fun_budget = 1500;

var living_budget_remaining = living_budget;
var fun_budget_remaining = fun_budget;

func add_transaction(amount, category):
	if (category == Main.BudgetCategory.LIVING):
		living_budget_remaining -= amount;
	elif (category == Main.BudgetCategory.FUN):
		fun_budget_remaining -= amount;
