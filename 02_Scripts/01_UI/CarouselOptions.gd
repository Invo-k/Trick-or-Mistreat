extends OptionButton
class_name CarouselOptionButton

@export var wrap_around := true
@export var slide_time := 0.25
@export_range(0.1, 1.0) var slide_distance := 0.6   # fracción del ancho que se desplaza
@export_group("Flechas")
@export var arrow_left: Control    
@export var arrow_right: Control
@export var arrow_move_distance := 8.0
@export var arrow_move_time := 0.35
@export var arrow_fade_time := 0.12

var _arrow_tween: Tween
var _arrow_fade: Tween
var _arrow_offset := 0.0
var _left_base := 0.0
var _right_base := 0.0

const COLOR_PROPS := [
	"font_color", "font_focus_color", "font_hover_color",
	"font_pressed_color", "font_hover_pressed_color", "font_disabled_color",
]

var _current: Label
var _outgoing: Label
var _tween: Tween
var _pending_dir := 0
var _last_index := -1
var _font: Font
var _font_size: int
var _font_color: Color

func _ready() -> void:
	clip_contents = true

	# Guardamos el estilo del texto antes de ocultarlo
	_font = get_theme_font("font")
	_font_size = get_theme_font_size("font_size")
	_font_color = get_theme_color("font_color")
	for p in COLOR_PROPS:
		add_theme_color_override(p, Color.TRANSPARENT)

	item_selected.connect(_on_item_selected)
	_current = _make_label(text)
	_last_index = selected

	# Desactiva el dibujo de la flecha del tema
	add_theme_constant_override("arrow_margin", 0)
	# Le asigna un icono vacío para que no muestre nada
	add_theme_icon_override("arrow", ImageTexture.new())
	
	for a in [arrow_left, arrow_right]:
		if a:
			a.modulate.a = 0.0

	if arrow_left:
		var arrows_container := arrow_left.get_parent() as Container
		if arrows_container:
			arrows_container.sort_children.connect(_capture_arrow_bases)

	focus_entered.connect(_show_arrows)
	focus_exited.connect(_hide_arrows)
	if has_focus():
		_show_arrows()

func _process(_delta: float) -> void:
	# Mantiene el texto sincronizado si se cambia por código
	# (select(), carga de ajustes, items añadidos después, etc.)
	if _tween and _tween.is_running():
		return
	if _current and _current.text != text:
		_current.text = text
	_last_index = selected

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and _current:
		_current.text = text

# --- Input -------------------------------------------------------------

func _gui_input(event: InputEvent) -> void:
	if not has_focus() or item_count == 0:
		return
	if event.is_action_pressed("ui_left", true):
		_step(-1)
		accept_event()
	elif event.is_action_pressed("ui_right", true):
		_step(1)
		accept_event()

func _step(direction: int) -> void:
	var new_index := selected
	for i in item_count:
		new_index += direction
		if wrap_around:
			new_index = wrapi(new_index, 0, item_count)
		else:
			new_index = clampi(new_index, 0, item_count - 1)
		if not is_item_disabled(new_index):
			break
	if new_index == selected:
		return
	_pending_dir = direction
	select(new_index)
	item_selected.emit(new_index)

# --- Animación ---------------------------------------------------------

func _on_item_selected(index: int) -> void:
	var dir := _pending_dir if _pending_dir != 0 else (1 if index >= _last_index else -1)
	_pending_dir = 0
	_last_index = index
	_animate_to(get_item_text(index), dir)

func _animate_to(new_text: String, direction: int) -> void:
	# Si el usuario pulsa rápido, cortamos la animación anterior
	if _tween:
		_tween.kill()
	if _outgoing:
		_outgoing.queue_free()

	_outgoing = _current
	_current = _make_label(new_text)

	var dist := size.x * slide_distance
	_current.position.x = dist * direction
	_current.modulate.a = 0.0

	_tween = create_tween().set_parallel(true)
	_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(_outgoing, "position:x", -dist * direction, slide_time)
	_tween.tween_property(_outgoing, "modulate:a", 0.0, slide_time)
	_tween.tween_property(_current, "position:x", 0.0, slide_time)
	_tween.tween_property(_current, "modulate:a", 1.0, slide_time)
	_tween.finished.connect(_on_tween_finished)

func _on_tween_finished() -> void:
	if _outgoing:
		_outgoing.queue_free()
		_outgoing = null

func _make_label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE   # los clics pasan al botón
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.add_theme_font_override("font", _font)
	l.add_theme_font_size_override("font_size", _font_size)
	l.add_theme_color_override("font_color", _font_color)
	add_child(l)
	l.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return l

# El contenedor acaba de colocar las flechas: esa es su posición real
func _capture_arrow_bases() -> void:
	if arrow_left:
		_left_base = arrow_left.position.x
	if arrow_right:
		_right_base = arrow_right.position.x
	_apply_arrow_offset(_arrow_offset)   # reaplica el desplazamiento en curso

func _apply_arrow_offset(o: float) -> void:
	_arrow_offset = o
	if arrow_left:
		arrow_left.position.x = _left_base - o    # la izquierda va hacia afuera (←)
	if arrow_right:
		arrow_right.position.x = _right_base + o  # la derecha va hacia afuera (→)

func _fade_arrows(target_alpha: float) -> void:
	if _arrow_fade:
		_arrow_fade.kill()
	_arrow_fade = create_tween().set_parallel(true)
	if arrow_left:
		_arrow_fade.tween_property(arrow_left, "modulate:a", target_alpha, arrow_fade_time)
	if arrow_right:
		_arrow_fade.tween_property(arrow_right, "modulate:a", target_alpha, arrow_fade_time)

func _show_arrows() -> void:
	if not arrow_left or not arrow_right:
		return
	if _arrow_tween:
		_arrow_tween.kill()
	_fade_arrows(1.0)

	# Vaivén lineal: hacia afuera y de vuelta, en bucle
	_arrow_tween = create_tween().set_loops()
	_arrow_tween.set_trans(Tween.TRANS_SPRING)
	_arrow_tween.tween_method(_apply_arrow_offset, _arrow_offset, arrow_move_distance, arrow_move_time)
	_arrow_tween.tween_method(_apply_arrow_offset, arrow_move_distance, 0.0, arrow_move_time)

func _hide_arrows() -> void:
	if not arrow_left or not arrow_right:
		return
	if _arrow_tween:
		_arrow_tween.kill()
	_fade_arrows(0.0)

	# Vuelven a su sitio mientras se desvanecen
	_arrow_tween = create_tween()
	_arrow_tween.tween_method(_apply_arrow_offset, _arrow_offset, 0.0, arrow_fade_time)
