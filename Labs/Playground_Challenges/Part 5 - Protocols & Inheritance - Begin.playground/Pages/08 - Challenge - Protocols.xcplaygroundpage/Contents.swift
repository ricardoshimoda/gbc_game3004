//: [⇐ Previous: 07 - Protocols & Extensions](@previous)
//: ## Episode 08: Challenge - Protocols

//: [Previous](@previous)

/*:
 ## Challenge 1
 - Create a protocol `Shape` that defines a read-only property `area` of type `Double`.
 - Implement `Shape` with structs representing `Square`, `Triangle` and `Circle`.
 - Add a circle, a square and a triangle to an array. Convert the array of `Shape`s to an array of `area`s using map.
 
 **HINTS**
 - The area of a square = one of its sides squared
 - The area of a triangle = 0.5 multiplied by its base multiplied by its height
 - The area of a circle = pi multiplied by its radius squared
 - `pi` is a property of `Double`!
 - You can copy the extension on `Numeric` into this page and use the `squared` property!
*/


// TODO: Write solution here

protocol Shape {
  var area: Double { get }
}
struct Square:Shape{
    let area:Double
    init(side:Double){
        self.area = side*side
    }
}
struct Triangle:Shape{
    let area:Double
    init(side:Double, height:Double){
        self.area = side*height/2
    }
}
struct Circle:Shape{
    let area:Double
    init(radius:Double){
        self.area = Double.pi * radius * radius
    }
}

var myTriangle:Triangle=Triangle(side:2, height:3)
var mySquare:Square = Square(side:4)
var myCircle:Circle = Circle(radius:2)
var myShapes:[Shape] = []
myShapes.append(myCircle)
myShapes.append(mySquare)
myShapes.append(myTriangle)
let areas = myShapes.map{$0.area}

/*:
 ## Challenge 2 Extending a Protocol
 Below is a function that takes a Double and tells you if it is an integer by comparing the Double to a rounded version of itself.
 - Turn that function into a computed property of `FloatingPoint` (a protocol that Double and other floating point numbers conform to!)
 - Try the property out on instances of `Double` and `Float`!
*/

// -----------------------------------
func isInteger(number: Double) -> Bool {
  number.rounded() == number
}
// -----------------------------------

// TODO: Write solution here

extension FloatingPoint {
    var isInteger:Bool {
        return self.rounded()==self
    }
}

let aaa:Double = 2
let bbb:Float = 4
let ccc:Double = 2.5
let ddd:Float = 4.6

print(aaa.isInteger)
print(bbb.isInteger)
print(ccc.isInteger)
print(ddd.isInteger)



