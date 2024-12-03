# 🌟 Custom Lighting System in Godot 4.3

This tutorial will guide you through creating a simple and customizable 2D lighting system in Godot 4.3. By the end, you’ll have a dynamic light source to enhance your game’s atmosphere.

---

## 🚀 Steps to Implement

### 1️⃣ Create the Light Source
1. **Create a new scene**:
   - Set the root node to **`Marker2D`**.
   - Name the node **`LightSource`**.
2. **Attach a script** to the `LightSource` node:
   - This script will handle the parameters and behavior of the light.

---

### 2️⃣ Set Up the Lighting Layer
1. In your **game world or level**:
   - Add a **`CanvasLayer`** node.
   - Add a **`ColorRect`** node as a child of the `CanvasLayer`.
   - Name the `ColorRect` node **`Lighting`**.
2. **Attach a script** to the `Lighting` node:
   - This script will interact with the shader for lighting effects.
3. In the **`Lighting` node inspector**:
   - Add a **Material > New Shader Material**.
   - Assign the provided shader to the **Shader Material**.
   - Assign your `Camera2D` to the Node

---

### 3️⃣ Adjust Lighting Properties
- In the `Lighting` node inspector:
  - Set **Modulate Color** to `#000b3cfb`.
  - Set **Black Point Color** to `#000000`.

---

### 4️⃣ Customize the Light Source
1. **Instance** the `LightSource` node into your game world or level.
2. Select the `LightSource` node and experiment with its **parameters** to achieve your desired lighting effect.

---

### 🎉 You're Done!
Enjoy your custom 2D lighting system! ✨  
Feel free to adjust shader settings or scripts to fine-tune the lighting for your project.

---
