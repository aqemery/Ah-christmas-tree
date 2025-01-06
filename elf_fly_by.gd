extends Node2D
const ELF = preload("res://elf.tscn")
@export var count = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.
    for i in range(count):
        var elf = ELF.instantiate()
        elf.position = Vector2(400, randf_range(10, 150))
        add_child(elf)
        await get_tree().create_timer(0.5).timeout
    


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if not get_child_count():
        Signals.next_stage.emit()
        queue_free()
