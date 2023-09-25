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
## To call an interface method, just code like this:
## [codeblock]
## MyInterface.get_implemention(<implementer, generally "self">).my_abstract_method(...)
## [/codeblock]
## To check if an interface has benn implemented by an object, just call a static method [method is_implemented_by][br]
## It's also allowed to get an interface via a static method [method get_implemention][br]
## [br]
## To instantiate an interface via the object implementing it, like:
## [codeblock]
## Interface my_interface = new Object(); // Object implements the Interface
## [/codeblock]
## Just code:
## [codeblock]
## var my_interface: MyInterface = MyInterface.get_implemention(ImplementerObject.new(...))
## var implementer: ImplementerObject = my_interface.get_object()
## [/codeblock]
## You can get access to "_object" in implementer interface to get reference to the implementer object

const _NAME: StringName = &"Interface"
const _EXCEPTIONS: PackedStringArray = [
	"_init",
	"get_object",
	"get_interface_name",
	"get_implemention",
	"is_implemented_by"
]


var _object: Object


func _init(object: Object) -> void:
	if !object: return
	_object = object
	
	# Register implemention
	@warning_ignore("static_called_on_instance")
	_object.set_meta(_NAME + get_interface_name(), self)

	# Implemention validation checking
	var list: Array[Dictionary] = get_script().get_script_method_list()
	var methods: Array[StringName] = []
	for i in list:
		var method: StringName = i.name
		if method in _EXCEPTIONS:
			continue
		methods.append(method)
	for j in methods:
		var count: int = methods.count(j)
		assert(count > 1, "Method %s is not implemented!" % [j])


## Returns the object by which the interface is implemented
func get_object() -> Object:
	return _object


## This method MUST be firstly overrid and reset the reuturned value to the same as the name of interface you are to extend to
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
## 1. The instance MUST be got from the implementer interface, like [code]MyInterface.get_instance(self)[/code] 
## rather than [code]Interface.get_instance(self)[/code] or [code]Interface.MyInterface.get_instance(self)[/code][br]
## 2. When calling from the interface, please do [code]MyInterface.get_interface(object).my_abstract_method(...)[/code], 
## making [param type] discarded when called[br]
## 3. In the inheriter interfaces, this method MUST be overrid as:
## [codeblock]
## # The type of returned value should be the interface's type
## static func get_interface(object: Object, type: StringName = get_interface_name()) -> MyInterface:
##     return super(object, type) as MyInterface
## [/codeblock]
## 4. To make this work successfully, it's required to override [method get_interface_name] first
static func get_implemention(object: Object, type: StringName = get_interface_name()):
	return object.get_meta(_NAME + type, null)


## Returns [code]true[/code] if the object implemented an interface named [param name]
static func is_implemented_by(object: Object) -> bool:
	return get_implemention(object) != null


# 👇 === Here you can define your own interfaces == 👇 #