# Godot-4-Interface
A Custom Class for Godot 4 to Temporarily Provide Interface Function

## What is Interface?
An interface is such a thing **to define which methods should a class have and should implement**. It's such a function in most of modern computer languages like C#, Java, etc.  
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
  1. In the `class_interface.gd`, define an inner class below the comment line, with inheritance from `Interface` class
  2. In that inner class, define the abstract methods  
      **NOTE:** Currently there haven't been `abstract` keyword in GDScript, so each method to be defined are required to be filled with `pass` or `return null` initially
     ```GDScript
     class MyInterface extends Interface:
       func my_func(...) -> void: pass
       func my_func_returnal(...) -> Type: return null
     ```
  3. In the script to implement the interface, define an inner class extending the class above, and the name of the class to be define should keep the same as one to be extended:
     ```GDScript
     # In the implementer class
     class MyInterface extends Interface.MyInterface:
       ...
     ```
  4. In the inner class above, override the methods to complete implement
     ```GDSCript
     class MyInterface extends Interface.MyInterface:
       func my_func(...) -> void:
         ...
       func my_func_returnal(...) -> Type:
         ...
     ```
  5. Instantiate the class above via any one of following two ways:  
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

To call the method, you can call a static method `call_interface()` in `Interface` class:  
```GDScript
func _ready() -> void:
  for i in get_tree().get_nodes_in_group("test"): # i's type is unknown and uncertain
    Interface.call_interface(i, "MyInterface", "my_func", [...])
```

To create an instance via the interface, you can:  
```GDScript
var object: Object = Object.new()
var interface: Interface = Interface.new(object)
var interface2: Interface2 = Interface2.new(object)
```
and call `get_object()` method
``` GDScript
var object: Object = interface.get_object()
```

## Having `has_method()` and `call()`, Why there should Still be an Interface Addon?
Good question. Of course, those who prefer dynamic calling are still allowed to use `has_method()` + `call()` to call methods
```GDScript
if object.has_method("my_func"):
  object.my_func()
```
However, via this method, it's not beneficial for programmers to take up the hobby of using interface when switching to other OOP languages like C#, Java, etc. Also, `Interface.get_interface()` with `as` operator can provide coding hint
```GDScript
(Interface.get_interface(self, "MyInterface") as Interface.MyInterface/MyInterface).my_func(...)
# It will automatically pop up a hint when you done inputting "(Interface.get_interface(self, "MyInterface") as Interface.MyInterface/MyInterface)."
```

## Known Issues
Due to performance problems, if you don't implement all methods from an interface, no errors will be thrown. This is impossible to fix since method checking in `_init()` on each instance (especially when instances is of dozens) will take longer time than one without the checking. So it's allowed to partially implement, but also required to remember which methods are implemented and which are not.

## Credits
Siobhan: Inspiration provider to this addon because of his video about making an interface system in GDScript.
