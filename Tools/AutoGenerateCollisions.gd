@tool
extends EditorScript

func _run():
	var root := get_scene()
	if root == null:
		push_error("Bạn phải mở scene level trước.")
		return

	var old := root.get_node_or_null("AutoCollisions")
	if old:
		old.queue_free()

	var holder := Node3D.new()
	holder.name = "AutoCollisions"
	root.add_child(holder)
	holder.owner = root

	var meshes: Array[MeshInstance3D] = []
	_collect_meshes(root, meshes)

	var count := 0

	for m in meshes:
		if m.mesh == null:
			continue

		var shape := m.mesh.create_trimesh_shape()
		if shape == null:
			continue

		var body := StaticBody3D.new()
		body.name = "COL_" + m.name
		body.global_transform = m.global_transform
		holder.add_child(body)
		body.owner = root

		var col := CollisionShape3D.new()
		col.shape = shape
		body.add_child(col)
		col.owner = root

		count += 1

	print("Generated collision bodies: ", count)
	print("Nhớ Ctrl+S để lưu scene.")


func _collect_meshes(node: Node, result: Array[MeshInstance3D]) -> void:
	if node.name == "AutoCollisions":
		return

	if node is MeshInstance3D:
		result.append(node)

	for child in node.get_children():
		_collect_meshes(child, result)
