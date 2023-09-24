@icon("class_interface.png")
class_name Interface

## Basic class for interface definition
##
## To define a new interface:[br]
## 1. Extend the class [Interface] with a new inner class in [Interface] class file[br]
## 2. In the inner class, code abstract functions you want to deploy. Because of lacking [code]abstract[/code] keyword, it's
## required to make all these functions [code]pass[/code] or [code]return null[/code](for returnal methods)
## [codeblock]
## class MyInterface extends Interface:
##     static func get_interface_name() -> StringName:
##         return &"MyInterface" # Keep the returned name the same as the interface's name
##
##
##     # Just copy and paste this, and change "MyInterface" to the name of the interface
##     static func get_interface(object: Object, type: StringName = get_interface_name()) -> MyInterface:
##         return object.get_meta(_NAME + type, null) as MyInterface
##
##
##     func my_abstract_function(args) -> void: pass
##     func my_abstract_function_with_return(args) -> Type: return null
## [/codeblock]
## 3. In the script you want to implement a interface, define a inner class extending that inner class in [Interface], and the name
## [b]MUST[/b] keep the same as the implementee
## [codeblock]
## # In the implementer's script
## class MyInterface extends Interface.MyInterface: ...
## # Keep the name same as one in the class Interface!
## [/codeblock]
## 4. Override ALL methods in the interface you just "implemented"
## [codeblock]
## class MyInterface extends Interface.MyInterface:
##     func my_abstract_function(args) -> void: pass 
##     #(or implementing codes, or "super(args)")
##     
##     func my_abstract_function_with_return(args) -> Type: return null 
##     #(or implementing codes, or "return super(args)")
## [/codeblock]
## 5. Instantiate the inner class you just coded via any one of the following two methods:[br]
## (1). Via the constructor:
## [codeblock]
## func _init(...) -> void:
##     MyInterface.new(self) # MUST INPUT "self" HERE!
## [/codeblock]
## (2). Via an [Array][[Interface]]:
## [codeblock]
## var _implements: Array[Interface] = [
##     MyInterface.new(self) # MUST INPUT "self" HERE!
## ]
## [/codeblock]
## Due to performance problems, if you don't implement all methods, no errors will be thrown, but you need to remember 
## which methods are implemented[br]
## [br]
## To call an interface, just call a static method [method call_interface][br]
## To check if an object has implemented an interface, just call a static method [method has_interface][br]
## It's also allowed to get an interface via a static method [method get_instance][br]
## [br]
## To instantiate an interface via the object implementing it, like:
## [codeblock]
## Interface my_interface = new Object(); // Object implements the Interface
## [/codeblock]
## Just code:
## [codeblock]
## var my_interface: Interface = Interface.new(ImplementerObject.new(...))
## var implementer: ImplementerObject = my_interface.get_object()
## [/codeblock]
## You can get access to "_object" in implementer interface to get reference to the implementer object

const _NAME: StringName = &"Interface"

var _object: Object


func _init(object: Object) -> void:
	if !object: return
	_object = object
	@warning_ignore("static_called_on_instance")
	_object.set_meta(_NAME + get_interface_name(), self)


## Returns the object by which the interface is implemented
func get_object() -> Object:
	return _object


## This method MUST be overrid and reset the reuturned value to the same as the name of interface you are to extend to
## E.g.
## [codeblock]
## class MyInterface extends Interface:
##     static func get_interface_name() -> StringName:
##         return &"MyInterface" # Keeps the same as the name of the interface inner class
## [/codeblock]
static func get_interface_name() -> StringName:
	return &"Base"


## Returns an [Interface] instance the [param object] is implementing[br]
## [br]
## [b]Notes:[/b][br]
## 1. When calling from the interface, please do [code]MyInterface.get_interface(object).my_abstract_method(...), making [param type] discarded when called[br]
## 2. In the inheriter interfaces, this method MUST be overrid as:
## [codeblock]
## The type of returned value should be the interface's type
## static func get_interface(object: Object, type: StringName = get_interface_name()) -> MyInterface:
##     return super(object, type) as MyInterface
## [/codeblock]
## 3. To make this work successfully, it's required to override [method get_interface_name] first
static func get_interface(object: Object, type: StringName = get_interface_name()):
	return object.get_meta(_NAME + type, null)


## Returns [code]true[/code] if the object implemented an interface named [param name]
static func has_interface(object: Object) -> bool:
	return get_interface(object) != null


# 👇 === Here you can define your own interfaces == 👇 #

class PhysicsHandler extends Interface:
	static func get_interface_name() -> StringName:
		return &"PhysicsHandler"


	static func get_interface(object: Object, type: StringName = get_interface_name()) -> PhysicsHandler:
		return super(object, type) as PhysicsHandler


	func move(_delta: float) -> void: pass
	func jump(_jumping_speed: float) -> void: pass
	func accelerate(_to: Vector2, _acceleration: float, _delta: float) -> void: pass
	func accelerate_x(_to: float, _acceleration: float, _delta: float) -> void: pass
	func accelerate_(_to: float, _acceleration: float, _delta: float) -> void: pass
	func turn_x() -> void: pass
	func turn_y() -> void: pass
