shader_type canvas_item;

// Lấy toàn bộ hình ảnh màn hình hiện tại, bật tính năng mipmap để làm mờ
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

// Biến điều khiển độ mờ từ GDScript (0.0 là rõ, 5.0 là mờ tịt)
uniform float blur_amount : hint_range(0.0, 5.0) = 0.0;

void fragment() {
    // Sử dụng textureLod để lấy mẫu hình ảnh ở độ phân giải thấp hơn, tạo hiệu ứng Blur rất nhẹ cho GPU
    vec4 color = textureLod(screen_texture, SCREEN_UV, blur_amount);
    COLOR = color;
}