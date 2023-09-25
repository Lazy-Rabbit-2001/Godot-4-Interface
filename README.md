# Godot 4 GDScript Interface v1.1
A custom class for Godot 4 to temporarily provide interface system for GDScript language

## Changelog
### v1.1:  
* Added implemention checking, now if you don't implement all methods from an interface in an implementer interface, an error will be thrown during the runtime
* Changed names of some methods:
*   `get_interface` -> `get_implemention`
*   `has_interface` -> `is_implemented_by`
* Now all custom interfaces are required to move into `InterfacesList` class. File name: `class_interfaces_list.gd`

## What is Interface?
An interface is such a thing **to define which methods should a class have and should be implemented**. It's such a function in most of modern computer languages like C#, Java, etc.  
An example in C#
```C#
interface IMyInterface
{
  void MyMethod(...);
  Type MyMethodReturnal(...);
}

public class MyClass : IMyInterface // Here it means the class MyClass implements an interface called IMyInterface
{
  public void MyMethod(...)
  {
    ...
  }
  public Type MyMethodReturnal(...)
  {
    ...
    return ...
  }
}
```
In C# you can create an Object implementing an interface:  
```C#
public class MyClass2
{
  public static void Main(String args[])
  {
    IMyInterface implementer = new MyClass(); // You can create an instance via its interface implemented
  }
}
```
Sometimes interfaces can provide more flexibility than inheritance, especially in Godot. Imagine such a situation where you have two instances, and one (let's say A) inherits `Node2D` while the other one (let's say B) `CharacterBody2D`. Now you have a main method to call their common method `run()`, you may code like this:  
```GDScript
# In A
class_name A extends Node2D

func run():
  ...

# In B
class_name B extends CharacterBody2D

func run():
  ...

# Main method
# Let's have A and B instantiated as a_ins and b_ins respectively
func _ready():
  a_ins.run()
  b_ins.run()
```
Everything seemed to work fine. However, as the project grows up, it will become gradually obvious that the system is getting more and more complex, especially when A and B have more extending classes. One day, it becomes a question: What if the type of an object is unknown, and a call to a specific method is needed?  
Thus, an interface system for GDScript is required, which is also the purpose of the addon.

## How to Install the Addon?
Very easy, just clone the git to the project being worked on  

## How to Use the Addon?
To create a custom interface:  
  1. In the `class_interfaces_list.gd`, define an inner class below the comment line, with inheritance from `Interface` class
  2. In that inner class, define the abstract methods  
      **NOTE:** Currently there haven't been `abstract` keyword in GDScript, so each method to be defined are required to be filled with `pass` or `return null` initially
     ```GDScript
     class MyInterface extends Interface:
       # This method MUST be overrid first
       static func get_interface_name() -> String:
         return &"MyInterface" # Keeps the same as the interface's name

       # This method MUST be overrid with super(object, type) returned instead,
       # and the type of returned value must be the same as the interface's type
       # When calling this method, DO NOT input the second param and just call it like "MyInterface.get_interface(self)"
       static func get_interface(object: Object, type: StringName = get_interface_name()) -> MyInterface:
         return super(object, type) as MyInterface


       func my_func(...) -> void: pass
       func my_func_returnal(...) -> Type: return null
     ```
  3. In the script to implement the interface, define an inner class extending the class above, and the name of the class to be define should keep the same as one to be extended:
     ```GDScript
     # In the implementer class
     class_name Implementer
     
     class MyInterface extends InterfacesList.MyInterface:
       ...
     ```
  4. In the inner class above, override all the methods to complete implement
     ```GDSCript
     class MyInterface extends InterfacesList.MyInterface:
       func my_func(...) -> void:
         ...
       func my_func_returnal(...) -> Type:
         ...
     ```
     Otherwise, an error will be thrown during the runtime
  5. Instantiate the class above via ANY ONE of the following two ways:  
     5.1. Via the constructor:  
     ```GDScript
     func _init(...) -> void:
       MyInterface.new(self) # "self" is REQUIRED TO BE PASSED IN
     ```
     5.2. Via an `Array[Interface]`:  
     ```GDScript
     var _implements: Array[Interface] = [
       MyInterface.new(self) # "self" is REQUIRED TO BE PASSED IN
     ]
     ```

To call the method, you can do it like this:  
```GDScript
func _ready() -> void:
  for i in get_tree().get_nodes_in_group("test"): # i's type is unknown and uncertain
    if !MyInterface.is_implemented_by(i): continue # Check if the object i has implemented the interface MyInterface, and if not, then skip calling
    MyInterface.get_implemention(i).my_func(...)
```

To create an instance via the interface implemented by some object, you can:  
```GDScript
var interface: MyInterface = MyInterface.get_implemention(Implementer.new())
var implementer: Implementer = interface.get_object()
```

To get access to the implementer object in the method in an implementer, just get access to `_object`:
```GDScript
class MyOtherInterface extends Interface.MyInterface:
  func my_func(...) -> void:
    print(_object) # Use "_object" to get access to the implementer object
```

## Having `has_method()` and `call()`, Why Should there Still Be an Interface Addon?
Good question. Of course, those who prefer dynamic calling are still allowed to use `has_method()` + `call()` to call methods
```GDScript
if object.has_method("my_func"):
  object.my_func()
```
However, via this method, it's not beneficial for them to take up hobbies of taking interface into usage when they are switching to other OOP languages like C#, Java, etc.  
Also, `MyInterface.get_interface()` will give coding hint during their programming
```GDScript
MyInterface.get_interface(self).my_func(...)
# It will automatically pop up a hint when they done inputting `MyInterface.get_interface(self)`
```

## After `trait` keyword gets implemented, will this addon be discarded?
Of course will, since you can directly use interface(trait) in GDScript, and this addon is a **temporary** solution for it.


## Known Issues
  1. Via this piece of code:  
  ```GDScript
  var interface: MyInterface = MyInterface.get_interface(Implementer.new())
  var implementer: Implementer = interface.get_object()
  ```
  Developers must make sure if the class `Implementer` does implement the interface; otherwise, the implementer will be `null`


## Credits
Siobhan: Inspiration provider to this addon because of his tutorial about making an interface system in GDScript.  
平英雄: Inspiration provider to this addon because of his tutorial about Strategy Pattern in GDScript.
