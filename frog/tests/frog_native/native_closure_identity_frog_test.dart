// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

typedef void MyFunctionType();

class A native "*A" {
  setClosure(MyFunctionType f) native;
  check(MyFunctionType f) native;
  invoke() native;
}

makeA() native { return new A(); }

void setup() native """
function A() {}
A.prototype.setClosure = function(f) { this.f = f; };
A.prototype.check = function(f) { return this.f === f; };
A.prototype.invoke = function() { return this.f(); };
makeA = function(){return new A;};
""";

var staticClosure;
staticMethod() => 42;

class B {
  var instanceClosure;
  instanceMethod() => 43;
}

checkUntyped(a, closure) {
  a.setClosure(closure);
  Expect.isTrue(a.check(closure));
  Expect.equals(closure(), a.invoke());
}

checkTyped(A a, MyFunctionType closure) {
  a.setClosure(closure);
  Expect.isTrue(a.check(closure));
  Expect.equals(closure(), a.invoke());
}

main() {
  setup();

  staticClosure = () => 44;
  B b = new B();
  b.instanceClosure = () => 45;

  closureStatement() => 46;
  var closureExpression = () => 47;

  checkUntyped(makeA(), staticClosure);
  checkTyped(makeA(), staticClosure);

  checkUntyped(makeA(), staticMethod);
  checkTyped(makeA(), staticMethod);

  checkUntyped(makeA(), b.instanceClosure);
  checkTyped(makeA(), b.instanceClosure);

  checkUntyped(makeA(), b.instanceMethod);
  checkTyped(makeA(), b.instanceMethod);

  checkUntyped(makeA(), closureStatement);
  checkTyped(makeA(), closureStatement);

  checkUntyped(makeA(), closureExpression);
  checkTyped(makeA(), closureExpression);
}
