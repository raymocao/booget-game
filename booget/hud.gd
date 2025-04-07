extends CanvasLayer

signal add_transaction(transaction);
signal update_config(config:BudgetConfig)
signal end_game();
signal reset_game();

@onready var mainContainer = $MainMarginContainer;
@onready var mainLB = $MainMarginContainer/BudgetLabels/LB;
@onready var mainFB = $MainMarginContainer/BudgetLabels/FB;
@onready var mainFP = $MainMarginContainer/BudgetLabels/FP;
@onready var mainAddTransaction = $MainMarginContainer/"Add Transaction";

@onready var exitContainer = $ExitMarginContainer;

@onready var menuContainer = $MenuMarginContainer;

@onready var menuAddTransactionContainer = $MenuMarginContainer/AddTransactionContainer;
@onready var menuAddTransactionCategory = $MenuMarginContainer/AddTransactionContainer/VBoxContainer/CategoryOptionButton;
@onready var menuAddTransactionLB = $MenuMarginContainer/AddTransactionContainer/LabelContainer/ATLB;
@onready var menuAddTransactionFB = $MenuMarginContainer/AddTransactionContainer/LabelContainer/ATFB;
@onready var menuAddTransactionFP = $MenuMarginContainer/AddTransactionContainer/LabelContainer/ATFP;
@onready var menuAddTransactionName = $MenuMarginContainer/AddTransactionContainer/VBoxContainer/TransactionNameLineEdit;
@onready var menuAddTransactionAmount = $MenuMarginContainer/AddTransactionContainer/VBoxContainer/TransactionAmount;

@onready var menuSettingsContainer = $MenuMarginContainer/SettingsContainer;
@onready var menuSettingsLB = $MenuMarginContainer/SettingsContainer/VBoxContainer/LivingBudgetContainer/LivingBudget;
@onready var menuSettingsFB = $MenuMarginContainer/SettingsContainer/VBoxContainer/FunBudgetContainer/FunBudget;
@onready var menuSettingsRV = $MenuMarginContainer/SettingsContainer/VBoxContainer/RollValueContainer/RollValue;
@onready var menuSettingsMI = $MenuMarginContainer/SettingsContainer/VBoxContainer/MonthlyIncomeContainer/MonthlyIncome;

@onready var menuResetContainer = $MenuMarginContainer/ResetMarginContainer;

func _ready():
	load_main_screen();
	populate_categories();

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
	menuResetContainer.hide();

func populate_categories():
	for c in Main.BudgetCategory:
		menuAddTransactionCategory.add_item(c);

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
	menuAddTransactionFP.text = "Fun Pool: $" + s;

func _on_add_transaction_pressed():
	mainContainer.hide();
	menuContainer.show();
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
	add_transaction.emit(transaction);

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
