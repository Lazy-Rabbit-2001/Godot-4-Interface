class_name Interface

## Basic class for interface definition
##
## To define a new interface:[br]
## 1. Extend the class [Interface] with a new inner class in [Interface] class file[br]
## 2. In the inner class, code abstract functions you want to deploy. Because of lacking [code]abstract[/code] keyword, it's
## required to make all these functions [code]pass[/code] or [code]return null[/code](for returnal methods)
## [codeblock]
## class MyInterface extends Interface:
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
## To achieve such a piece of code in GDScript with [Interface] custom class:
## [codeblock]
## Interface my_interface = new Object  // Object implements the Interface
## [/codeblock]
## Just code:
## [codeblock]
## var object: Object = Object.new()
## var my_interface: Interface = Interface.new(object)
## [/codeblock]

var _object: Object


## This MUST be overrid and return the same name as your custom interface[br]
## E.g.
## [codeblock]
## class MyInterface extends Interface:
##     func _to_string() -> String:
##         return "MyInterface" 
##         # Returns the same as one following "class" keyword
## [/codeblock]
func _to_string() -> String:
	return "Base"


func _init(object: Object) -> void:
	_object = object
	_object.set_meta(&"Interface" + to_string(), self)


## Returns the object by which the interface is implemented
func get_object() -> Object:
	return _object


## Returns an [Interface] instance the [param object] is implementing
static func get_interface(object: Object, name: StringName) -> Interface:
	return object.get_meta(&"Interface" + name, null)


## Returns [code]true[/code] if the object implemented an interface named [param name]
static func has_interface(object: Object, name: StringName) -> bool:
	return get_interface(object, name) != null


## Calls an method (named [param method], with arguments [param args]) of an interface (named [param name]) implemented 
## by an [param object], and returns a value according to the method to be called
static func call_interface(object: Object, name: StringName, method: StringName, args: Array = []) -> Variant:
	var interface: Interface = get_interface(object, name)
	if !interface:
		return null
	
	var called: Callable = Callable(interface, method)
	if !called.is_valid():
		return null
	
	return called.callv(args)


# 👇 === Here you can define your own interfaces == 👇 #

class PhysicsHandler extends Interface:
	func _to_string() -> String:
		return "PhysicsHandler"

	func move(_delta: float) -> void: pass
	func jump(_jumping_speed: float) -> void: pass
