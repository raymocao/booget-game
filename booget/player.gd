extends Node

@export var living_budget = 1500;
@export var fun_budget = 1500;

var living_budget_remaining = living_budget;
var fun_budget_remaining = fun_budget;
var fun_pool = 0;

func add_transaction(amount, category):
	if (category == Main.BudgetCategory.LIVING):
		living_budget_remaining -= amount;
	elif (category == Main.BudgetCategory.FUN):
		fun_budget_remaining -= amount;
	
	if (living_budget_remaining < 0):
		fun_budget_remaining += living_budget_remaining;
		living_budget_remaining = 0;
	
	if (fun_budget_remaining < 0):
		fun_pool += fun_budget_remaining;
		fun_budget_remaining = 0;
