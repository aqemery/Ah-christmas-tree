extends Area2D

@export var velocity:Vector2 = Vector2.ZERO


func _ready() -> void:
    await get_tree().create_timer(3).timeout
    print("Free snowball")
    queue_free()
    

func _physics_process(delta: float) -> void:
    position += velocity * delta


func _on_area_entered(area: Area2D) -> void:
    print("Free snowball")
    queue_free()
