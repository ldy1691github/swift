// RUN: %swift -parse %s -verify

class A {
  var x = 0
}

struct B : _ObjectiveCBridgeable {
  static func _isBridgedToObjectiveC() -> Bool {
    return true
  }
  
  static func _getObjectiveCType() -> Any.Type {
    return A.self
  }
  func _bridgeToObjectiveC() -> A {
    return A()
  }
  static func _forceBridgeFromObjectiveC(x: A) -> B {
    return B()
  }
  static func _conditionallyBridgeFromObjectiveC(x: A) -> B? {
    return B()
  }
}

var a: [A] = []
var b: [B] = []

a = b

b = a // expected-error {{'A' is not identical to 'B'}}

var aa: [[A]] = []
var bb: [[B]] = []

aa = bb // expected-error {{'B' is not identical to 'A'}}

class C {
}

// In this case, bridged conversion should win
class E {
  var x = 0
}

struct F : _ObjectiveCBridgeable {
  static func _isBridgedToObjectiveC() -> Bool {
    return true
  }
  
  static func _getObjectiveCType() -> Any.Type {
    return E.self
  }
  func _bridgeToObjectiveC() -> E {
    return E()
  }
  static func _forceBridgeFromObjectiveC(x: E) -> F {
    return F()
  }
  static func _conditionallyBridgeFromObjectiveC(x: E) -> F? {
    return F()
  }
}

var e: [E] = []
var f: [F] = []

e = f
f = e // expected-error {{'E' is not identical to 'F'}}

class G {
  var x = 0
}

struct H : _ObjectiveCBridgeable {
  static func _getObjectiveCType() -> Any.Type {
    return G.self
  }
  func _bridgeToObjectiveC() -> G {
    return G()
  }
  static func _forceBridgeFromObjectiveC(x: G) -> H {
    return H()
  }
  static func _conditionallyBridgeFromObjectiveC(x: G) -> H? {
    _preconditionFailure("implement")
  }
  static func _isBridgedToObjectiveC() -> Bool {
    return false
  }
}

var g: [G] = []
var h: [H] = []

g = h // should type check, but cause a failure at runtime


struct I : _ObjectiveCBridgeable {
  static func _isBridgedToObjectiveC() -> Bool {
    return true
  }
  
  static func _getObjectiveCType() -> Any.Type {
    return A.self
  }
  func _bridgeToObjectiveC() -> AnyObject {
    return A()
  }
  static func _forceBridgeFromObjectiveC(x: AnyObject) -> I {
    return I()
  }
  static func _conditionallyBridgeFromObjectiveC(x: AnyObject) -> I? {
    return I()
  }
}

var aoa: [AnyObject] = []
var i: [I] = []

aoa = i
i = aoa // expected-error {{'AnyObject' is not identical to 'I'}}
