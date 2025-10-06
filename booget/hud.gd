extends CanvasLayer

signal add_transaction(transaction);
signal update_config(config:BudgetConfig)
signal end_game();
signal reset_game();

var subcategories:Subcategories;
var living_transaction_dict:Dictionary;
var fun_transaction_dict:Dictionary;

@onready var mainContainer = $MainMarginContainer;
@onready var mainLB = $MainMarginContainer/BudgetLabels/LB;
@onready var mainFB = $MainMarginContainer/BudgetLabels/FB;
@onready var mainFP = $MainMarginContainer/BudgetLabels/FP;
@onready var mainAddTransaction = $"MainMarginContainer/ButtonContainer/Add Transaction"

@onready var exitContainer = $ExitMarginContainer;

@onready var menuContainer = $MenuMarginContainer;

@onready var menuAddTransactionContainer = $MenuMarginContainer/AddTransactionContainer;
@onready var menuAddTransactionVBoxContainer = $MenuMarginContainer/AddTransactionContainer/AddTransactionVBoxContainer;
@onready var menuAddTransactionCategory = $MenuMarginContainer/AddTransactionContainer/AddTransactionVBoxContainer/CategoryOptionButton;
@onready var menuAddTransactionSubcategory = $MenuMarginContainer/AddTransactionContainer/AddTransactionVBoxContainer/SubcategoryOptionButton;
@onready var menuAddTransactionLB = $MenuMarginContainer/AddTransactionContainer/LabelContainer/ATLBContainer/ATLB;
@onready var menuAddTransactionFB = $MenuMarginContainer/AddTransactionContainer/LabelContainer/ATFBContainer/ATFB;
@onready var menuAddTransactionFP = $MenuMarginContainer/AddTransactionContainer/LabelContainer/ATFP;
@onready var menuAddTransactionName = $MenuMarginContainer/AddTransactionContainer/AddTransactionVBoxContainer/TransactionNameLineEdit;
@onready var menuAddTransactionAmount = $MenuMarginContainer/AddTransactionContainer/AddTransactionVBoxContainer/TransactionAmount;

@onready var menuBreakdownContainer = $MenuMarginContainer/AddTransactionContainer/BreakdownContainer;
@onready var menuBreakdownLabel = $MenuMarginContainer/AddTransactionContainer/BreakdownContainer/BreakdownLabel;

@onready var menuSettingsContainer = $MenuMarginContainer/SettingsContainer;
@onready var menuSettingsLB = $MenuMarginContainer/SettingsContainer/VBoxContainer/LivingBudgetContainer/LivingBudget;
@onready var menuSettingsFB = $MenuMarginContainer/SettingsContainer/VBoxContainer/FunBudgetContainer/FunBudget;
@onready var menuSettingsRV = $MenuMarginContainer/SettingsContainer/VBoxContainer/RollValueContainer/RollValue;
@onready var menuSettingsMI = $MenuMarginContainer/SettingsContainer/VBoxContainer/MonthlyIncomeContainer/MonthlyIncome;

@onready var menuGachaContainer = $MenuMarginContainer/GachaContainer;

@onready var menuTasksContainer = $MenuMarginContainer/TasksContainer;

@onready var menuCollectionContainer = $MenuMarginContainer/CollectionContainer;

@onready var menuResetContainer = $MenuMarginContainer/ResetMarginContainer;

func _ready():
	load_main_screen();
	populate_categories();

func set_subcategories(sc:Subcategories):
	subcategories = sc;

func set_current_month_transactions(transactions:Array[Transaction]):
	living_transaction_dict.clear();
	fun_transaction_dict.clear();
	
	for lsc in subcategories.living_subcategories:
		living_transaction_dict[lsc] = 0.0;
	for fsc in subcategories.fun_subcategories:
		fun_transaction_dict[fsc] = 0.0;
		
	for t in transactions:
		if (t.transaction_category == Main.BudgetCategory.LIVING):
			if (living_transaction_dict.has(t.transaction_subcategory)):
				living_transaction_dict[t.transaction_subcategory] += t.transaction_amount;
			else:
				living_transaction_dict[t.transaction_subcategory] = t.transaction_amount;
		elif (t.transaction_category == Main.BudgetCategory.FUN):
			if (fun_transaction_dict.has(t.transaction_subcategory)):
				fun_transaction_dict[t.transaction_subcategory] += t.transaction_amount;
			else:
				fun_transaction_dict[t.transaction_subcategory] = t.transaction_amount;

func load_main_screen():
	mainContainer.show();
	mainLB.show();
	mainFB.show();
	mainFP.show();
	mainAddTransaction.show();
	exitContainer.hide();
	hide_menus();

func hide_menus():
	menuContainer.hide();
	menuAddTransactionContainer.hide();
	menuSettingsContainer.hide();
	menuGachaContainer.hide();
	menuTasksContainer.hide();
	menuCollectionContainer.hide();
	menuResetContainer.hide();

func populate_categories():
	for c in Main.BudgetCategory:
		menuAddTransactionCategory.add_item(c);

func populate_subcategories():
	menuAddTransactionSubcategory.clear();
	var category = Main.BudgetCategory.get(menuAddTransactionCategory.get_item_text(menuAddTransactionCategory.selected));
	if (category == Main.BudgetCategory.LIVING):
		for sc in subcategories.living_subcategories:
			menuAddTransactionSubcategory.add_item(sc);
	elif (category == Main.BudgetCategory.FUN):
		for sc in subcategories.fun_subcategories:
			menuAddTransactionSubcategory.add_item(sc);
	menuAddTransactionSubcategory.select(0);

func update_lb(num):
	var s = str("%0.2f" % num);
	mainLB.text = "Living Budget Remaining: $" + s;
	menuAddTransactionLB.text = "Living Budget Remaining: $" + s;

func update_fb(num):
	var s = str("%0.2f" % num);
	mainFB.text = "Fun Budget Remaining: $" + s;
	menuAddTransactionFB.text = "Fun Budget Remaining: $" + s;

func update_fp(num):
	var s = str("%0.2f" % num);
	mainFP.text = "Fun Pool: $" + s;
	menuAddTransactionFP.text = "   Fun Pool: $" + s;

func populate_breakdown(category:Main.BudgetCategory):
	if (category == Main.BudgetCategory.LIVING):
		var s = "Living Budget Breakdown: \n";
		var total = 0.0;
		for sc in living_transaction_dict:
			s += sc + ": $" + str("%0.2f" % living_transaction_dict[sc]) + "\n";
			total += living_transaction_dict[sc];
		s += "Total: $" + str("%0.2f" % total);
		menuBreakdownLabel.text = s;
	elif (category == Main.BudgetCategory.FUN):
		var s = "Fun Budget Breakdown: \n";
		var total = 0.0;
		for sc in fun_transaction_dict:
			s += sc + ": $" + str("%0.2f" % fun_transaction_dict[sc]) + "\n";
			total += fun_transaction_dict[sc];
		s += "Total: $" + str("%0.2f" % total);
		menuBreakdownLabel.text = s;

func _on_add_transaction_pressed():
	mainContainer.hide();
	populate_subcategories();
	menuContainer.show();
	menuAddTransactionVBoxContainer.show();
	menuBreakdownContainer.hide();
	menuAddTransactionContainer.show();

func _on_exit_pressed() -> void:
	mainContainer.hide();
	exitContainer.show();

func _on_exit_confirm_pressed() -> void:
	end_game.emit();

func _on_exit_cancel_pressed() -> void:
	load_main_screen();

func _on_menu_close_button_pressed() -> void:
	update_config.emit(null);
	load_main_screen();

func _on_confirm_transaction_button_pressed() -> void:
	var transaction = Transaction.new();
	transaction.transaction_name = menuAddTransactionName.text
	transaction.transaction_amount = menuAddTransactionAmount.real_value;
	transaction.transaction_category = Main.BudgetCategory.get(menuAddTransactionCategory.get_item_text(menuAddTransactionCategory.selected));
	transaction.transaction_subcategory = menuAddTransactionSubcategory.get_item_text(menuAddTransactionSubcategory.selected);
	add_transaction.emit(transaction);
	menuAddTransactionName.text = "";
	menuAddTransactionAmount.real_value = 0.0;
	menuAddTransactionAmount.update_text();
	menuAddTransactionCategory.selected = Main.BudgetCategory.LIVING;

func update_config_hud(config:BudgetConfig):
	menuSettingsLB.real_value = config.living_budget;
	menuSettingsFB.real_value = config.fun_budget;
	menuSettingsRV.real_value = config.roll_value;
	menuSettingsMI.real_value = config.monthly_income;
	
	menuSettingsLB.update_text();
	menuSettingsFB.update_text();
	menuSettingsRV.update_text();
	menuSettingsMI.update_text();

func _on_settings_pressed() -> void:
	mainContainer.hide();
	menuResetContainer.hide();
	menuContainer.show();
	menuSettingsContainer.show();

func _on_settings_save_button_pressed() -> void:
	var config = BudgetConfig.new();
	config.living_budget = menuSettingsLB.real_value;
	config.fun_budget = menuSettingsFB.real_value;
	config.roll_value = menuSettingsRV.real_value;
	config.monthly_income = menuSettingsMI.real_value;
	update_config.emit(config);
	load_main_screen();

func _on_reset_button_pressed() -> void:
	menuSettingsContainer.hide();
	menuResetContainer.show();

func _on_reset_confirm_pressed() -> void:
	load_main_screen();
	reset_game.emit();

func _on_reset_cancel_pressed() -> void:
	_on_settings_pressed();

func _on_gacha_pressed() -> void:
	mainContainer.hide();
	menuContainer.show();
	menuGachaContainer.show();

func _on_category_option_button_item_selected(index: int) -> void:
	populate_subcategories();

func _on_atlb_button_pressed() -> void:
	populate_breakdown(Main.BudgetCategory.LIVING);
	menuAddTransactionVBoxContainer.hide();
	menuBreakdownContainer.show();

func _on_atfb_button_pressed() -> void:
	populate_breakdown(Main.BudgetCategory.FUN);
	menuAddTransactionVBoxContainer.hide();
	menuBreakdownContainer.show();

func _on_breakdown_button_pressed() -> void:
	menuAddTransactionVBoxContainer.show();
	menuBreakdownContainer.hide();

func _on_tasks_pressed() -> void:
	mainContainer.hide();
	menuContainer.show();
	menuTasksContainer.show();

func _on_collection_pressed() -> void:
	mainContainer.hide();
	menuContainer.show();
	menuCollectionContainer.show();
