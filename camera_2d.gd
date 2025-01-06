extends Camera2D

const ORIGIN = Vector2(0, 0)
var _strength = 0
var _timer = 0
var _fade = 1

func _ready():
    Signals.shake_camera.connect(shake)
    pass


func shake(amount: float, duration: float, fade: float=1):
    _strength = amount
    _timer = duration
    _fade = fade

func _process(delta):
    if _timer > 0:
        _timer -= delta
    if _timer <= 0:
        _strength = 0
    if _strength > 0:
        _strength -= delta * _fade
        if _strength < 0:
            _strength = 0
    offset = ORIGIN + _random_offset()
    
func _random_offset():
    return Vector2(randf_range( - _strength, _strength), randf_range( - _strength, _strength))
