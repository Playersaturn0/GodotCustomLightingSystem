extends Marker2D
class_name LightSource

@export var radius: float = 64.0
@export var time_scale: float = 1.0
@export var variation_amount: float = 10.0
@export var falloff_band_1: float = 0.85
@export var falloff_band_2: float = 0.6
@export var light_color : Color = Color.WHITE
@export var intensity : float = 1.0
@export var attenuation : float = 0.0
@export var flicker_intensity : float = 0.0
@export var flicker_speed : float = 1.0
@export var glow_radius: float = 200.0
@export var glow_intensity: float = 0.5


func _ready() -> void:
	add_to_group("LightSource")
