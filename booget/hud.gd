extends CanvasLayer

signal add_transaction(transaction);
signal end_game();

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
	load_main_screen();

func _on_confirm_transaction_button_pressed() -> void:
	var transaction = Transaction.new();
	transaction.transaction_name = menuAddTransactionName.text
	transaction.transaction_amount = menuAddTransactionAmount.real_value;
	transaction.transaction_category = Main.BudgetCategory.get(menuAddTransactionCategory.get_item_text(menuAddTransactionCategory.selected));
	add_transaction.emit(transaction);
