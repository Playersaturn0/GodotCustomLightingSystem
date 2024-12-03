shader_type canvas_item;

// Color used to modulate the overall screen color
uniform vec4 modulate_color : source_color = vec4(1.0);

// Threshold color, used to apply a "black point" below which colors are adjusted to black_point
uniform vec4 black_point : source_color = vec4(0.0);

// Array of light positions on the screen (up to 100 lights)
uniform vec2 lights[100];

// Array of base radii for each light (indicating the initial radius of each light)
uniform float light_radii[100];

// Time scale for each light, controls speed of radius fluctuation
uniform float time_scales[100];

// Amount by which each light's radius varies over time
uniform float variation_amounts[100];

// Falloff factors for each light, band 1 falloff for each light, defines a closer falloff region
uniform float falloff_band_1[100];

// Falloff factors for each light, band 2 falloff for each light, defines a secondary falloff region
uniform float falloff_band_2[100];

// Number of lights currently active in the shader
uniform int number_of_lights = 1;

// Defines the light strength within band 1 region
uniform float band_1_strength = 0.3;

// Defines the light strength within band 2 region
uniform float band_2_strength = 0.6;

// Arrays to store properties of individual lights:
// Colors of each light
uniform vec3 light_colors[100];

// Intensity factor for each light
uniform float intensities[100];

// Attenuation factor for each light, which defines how quickly light fades
uniform float attenuations[100];

// Individual glow radius and intensity for each light
uniform float light_glow_radii[100];
uniform float light_glow_intensities[100];

// Global flicker controls for all lights, adding a synchronized "flicker" effect
uniform float global_flicker_intensity = 0.0; // Intensity of the flicker effect
uniform float global_flicker_speed = 1.0; // Speed of the flicker effect

// Individual flicker control for each light, enabling unique flicker behavior per light
uniform float light_flicker_intensities[100];
uniform float light_flicker_speeds[100];

// The screen texture, which is the base image the shader will manipulate
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

// Wobble parameters
uniform float wobble_amp = 1.0; // Reduced amplitude of the wobble
uniform float wobble_freq = 6.0; // Frequency of the wobble
uniform float wobble_speed = 5.0; // Speed of the wobble

// Camera offset (should be set from the script or globally)
uniform vec2 camera_offset; // This should be the camera's position in world space

// Function to compute a dynamic light radius that changes over time using sine wave function
float get_dynamic_radius(float base_radius, float time_scale, float variation_amount) {
    return base_radius + sin(TIME * time_scale) * variation_amount;
}

// Function to create a flickering effect
float flicker(float intensity, float speed) {
    return 1.0 - intensity * (sin(TIME * speed) * 0.5 + 0.5);
}

// Function that calculates the light contribution based on distance, light radius, falloff, and attenuation
float light_contribution(float dist_to_light, float light_radius, float time_scale, float variation_amount, float falloff1, float falloff2, float attenuation, float flicker_intensity, float flicker_speed) {
    float dynamic_light_radius = get_dynamic_radius(light_radius, time_scale, variation_amount);
    if (dist_to_light > dynamic_light_radius) return 0.0;

    float contribution = 1.0;
    if (dist_to_light > dynamic_light_radius * falloff1) contribution = band_1_strength;
    else if (dist_to_light > dynamic_light_radius * falloff2) contribution = band_2_strength;

    contribution *= pow(max(0.0, 1.0 - dist_to_light / dynamic_light_radius), attenuation);
    contribution *= flicker(flicker_intensity, flicker_speed);

    return contribution;
}

// Function to create a radial glow effect around each light source
float radial_glow_contribution(float dist_to_light, float base_glow_radius, float base_glow_intensity, float time_scale, float variation_amount, float flicker_intensity, float flicker_speed) {
    // Calculate dynamic glow radius and intensity
    float dynamic_glow_radius = get_dynamic_radius(base_glow_radius, time_scale, variation_amount);
    float dynamic_glow_intensity = base_glow_intensity * flicker(flicker_intensity, flicker_speed);

    float glow_factor = max(0.0, 1.0 - dist_to_light / dynamic_glow_radius);
    return pow(glow_factor, 2.0) * dynamic_glow_intensity;
}

// Function to calculate a morphing wobble effect
vec2 morphing_wobble(float base_radius, vec2 position) {
    // Get the world position by subtracting the camera offset
    vec2 world_position = position - camera_offset;

    float wobble_offset_x = wobble_amp * (sin(world_position.x * wobble_freq + TIME * wobble_speed));
    float wobble_offset_y = wobble_amp * (sin(world_position.y * wobble_freq + TIME * wobble_speed));
    return vec2(wobble_offset_x, wobble_offset_y);
}

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);
    vec4 modulated_color = color * modulate_color;
    vec3 max_light_color = vec3(0.0);
    vec3 glow_light_color = vec3(0.0);

    for (int i = 0; i < number_of_lights; i++) {
        // Calculate the distance to the light
        float dist_to_light = distance(FRAGCOORD.xy, lights[i]);

        // Apply morphing wobble to the distance calculation
        vec2 wobble = morphing_wobble(light_radii[i], FRAGCOORD.xy);
        float distorted_radius = light_radii[i] + wobble.x + wobble.y; // Combine X and Y wobble

        // Calculate main light contribution
        float contribution = light_contribution(
            dist_to_light,
            distorted_radius,
            time_scales[i],
            variation_amounts[i],
            falloff_band_1[i],
            falloff_band_2[i],
            attenuations[i],
            light_flicker_intensities[i],
            light_flicker_speeds[i]
        );

        vec3 light_color = light_colors[i] * contribution * intensities[i];
        max_light_color = max(max_light_color, light_color);

        // Calculate individual glow contribution per light
        float glow_contrib = radial_glow_contribution(dist_to_light, light_glow_radii[i], light_glow_intensities[i], time_scales[i], variation_amounts[i], light_flicker_intensities[i], light_flicker_speeds[i]);
        glow_light_color += light_colors[i] * glow_contrib;
    }

    vec4 final_color = mix(modulated_color, color * vec4(max_light_color + glow_light_color, 1.0), length(max_light_color + glow_light_color));
    COLOR = final_color;

    float color_avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
    if (color_avg < (black_point.r + black_point.g + black_point.b) / 3.0) {
        COLOR = black_point;
    }
}
