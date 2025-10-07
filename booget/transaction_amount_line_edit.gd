class_name PrefixLineEdit extends LineEdit

@export var format_string: String = "%0.2f"
@export var prefix: String = "$"
@export var suffix: String = ""

var real_value = 0.0

## Convenience initializer that sets [member format_string] to [param fstring] if set.
func _init(fstring: String = "") -> void:
	if not fstring.is_empty():
		format_string = fstring

# Connect the signal handlers required to make this work seamlessly.
func _ready() -> void:
	text_changed.connect(_on_text_changed, CONNECT_DEFERRED)
	text_submitted.connect(_on_text_submitted, CONNECT_DEFERRED)
	focus_entered.connect(_on_text_entered, CONNECT_DEFERRED)
	focus_exited.connect(_on_focus_exited, CONNECT_DEFERRED)
	
	text = (prefix + format_string + suffix) % real_value

func update_text() -> void:
	text = (prefix + format_string + suffix) % real_value

func _on_text_changed(value: String) -> void:
	var caret = caret_column
	if (value.length() == 1 && value != prefix):
		value = prefix + value;
		caret += 1
	real_value = float(value.substr(prefix.length(), value.length() - prefix.length() - suffix.length()));
	text = (prefix + value.substr(prefix.length(), (value.length() - prefix.length() - suffix.length())) + suffix)
	if (caret == 0):
		caret = 1;
	caret_column = caret

func _on_text_submitted(value: String) -> void:
	text = (prefix + format_string + suffix) % real_value
	real_value = float(value.substr(prefix.length()));

func _on_text_entered() -> void:
	text = (prefix + format_string + suffix) % real_value
	caret_column = text.length();
	select_all();

func _on_focus_exited() -> void:
	text = (prefix + format_string + suffix) % real_value
