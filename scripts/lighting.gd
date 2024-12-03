extends ColorRect
class_name Lighting

@export var camera: Camera2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var light_positions = _get_light_positions()
	var light_radii = _get_light_radii()
	var time_scales = _get_time_scales()
	var variation_amounts = _get_variation_amounts()
	var falloff_band_1 = _get_falloff_band_1()
	var falloff_band_2 = _get_falloff_band_2()
	var light_colors = _get_light_colors()
	var intensities = _get_intensities()
	var attenuations = _get_attenuations()
	var flicker_intensities = _get_flicker_intensities()
	var flicker_speeds = _get_flicker_speeds()
	var glow_radii = _get_glow_radii()
	var glow_intensities = _get_glow_intensities()

	material.set_shader_parameter("number_of_lights", light_positions.size())
	material.set_shader_parameter("lights", light_positions)
	material.set_shader_parameter("light_radii", light_radii)
	material.set_shader_parameter("time_scales", time_scales)
	material.set_shader_parameter("variation_amounts", variation_amounts)
	material.set_shader_parameter("falloff_band_1", falloff_band_1)
	material.set_shader_parameter("falloff_band_2", falloff_band_2)
	material.set_shader_parameter("light_colors", light_colors)
	material.set_shader_parameter("intensities", intensities)
	material.set_shader_parameter("attenuations", attenuations)
	material.set_shader_parameter("light_flicker_intensities", flicker_intensities)
	material.set_shader_parameter("light_flicker_speeds", flicker_speeds)
	material.set_shader_parameter("light_glow_radii", glow_radii)
	material.set_shader_parameter("light_glow_intensities", glow_intensities)
	material.set_shader_parameter("camera_offset", camera.global_position);


# Returns glow radii of the lights
func _get_glow_radii() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.glow_radius
	)

# Returns glow intensities of the lights
func _get_glow_intensities() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.glow_intensity
	)

# Returns positions of the lights
func _get_light_positions() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.get_global_transform_with_canvas().origin
	)

# Returns radii of the lights
func _get_light_radii() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.radius
	)

# Returns time scale of the lights
func _get_time_scales() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.time_scale
	)

# Returns variation amount of the lights
func _get_variation_amounts() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.variation_amount
	)

# Returns falloff factor for band 1 of the lights
func _get_falloff_band_1() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.falloff_band_1
	)

# Returns falloff factor for band 2 of the lights
func _get_falloff_band_2() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.falloff_band_2
	)

# Returns light colors
func _get_light_colors() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.light_color
	)

# Returns light intensities
func _get_intensities() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.intensity
	)

# Returns attenuation values of the lights
func _get_attenuations() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.attenuation # Assuming each light has an attenuation property
	)

# Returns flicker intensities of the lights
func _get_flicker_intensities() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.flicker_intensity
	)

# Returns flicker speeds of the lights
func _get_flicker_speeds() -> Array:
	return get_tree().get_nodes_in_group("LightSource").map(
		func(light: Node2D):
			return light.flicker_speed
	)
