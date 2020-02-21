//: [⇐ Previous: 02 - Inheritance](@previous)
//: ## Episode 03: Challenge - Inheritance

/*:
## Challenge 1 - Building a Class Heirarchy
Create a class named `Animal` that has…
1. a function named `speak()` that does nothing.
 
Create two `Animal` subclasses...
1. `WildAnimal` that...
  - has an `isPoisonous` property, that is a `Bool`
  - has an initializer that takes `isPoisonous` as a parameter
2. `Pet` that...
  - has a stored property named `name`, that is a `String`
  - has an initializer that takes `name` as a parameter
  - has a `play()` method that prints out a message
  - overrides `speak()` - It should print out a message

Create one subclass of your choice of `WildAnimal` or `Pet`. It should do at least one of the following:
 - override `speak()`
 - override `play()`
 - Add a new computed property
 - Add a new method
*/

// TODO: Write solution here

class Animal {
    func speak(){}
}

class WildAnimal:Animal{
    var isPoisonous: Bool
    init(isPoisonous:Bool){
        self.isPoisonous = isPoisonous;
    }
}

class Pet:Animal{
    var name:String
    func play(){
        print("I am \(name)")
    }
    override func speak(){
        print("woof, woof")
    }
    init(name:String){
        self.name = name
    }
}

class Hamster:Pet{
    var damages:Float
    func damage(){
        print("Oh no, my new couch")
        damages+=100
    }
    override func speak(){
        print("Squeak")
    }
    override func play(){
        super.play()
        print("And I like to destroy stuff")
    }
    init(name:String, damages:Float){
        self.damages = damages
        super.init(name:name)
    }
}

/*:
## Challenge 2 - Casting
- Create at least one instance of each class from the first challenge.
- Create an array that contains all of the instances.
- Write a function that takes an `Animal` and does something different depending on what subclass it is. Try using conditional downcasting!
- Call the function with each of your instances using a loop or whatever other method you'd like!
*/



// TODO: Write solution here

var myFavPet:Pet = Pet(name: "Rover")
var iHateThisOne:Hamster = Hamster(name: "Moustache", damages: 1000)
var carefulWithThis:WildAnimal = WildAnimal(isPoisonous: true)
var microbe:Animal = Animal()

var myPetShop:[Animal]=[]
myPetShop.append(myFavPet)
myPetShop.append(iHateThisOne)
myPetShop.append(carefulWithThis)
myPetShop.append(microbe)

func iDoDifferentStuff(currentAnimal:Animal){
    if currentAnimal is Hamster {
        let unlikeable = currentAnimal as! Hamster
        print("I hate this thing - it cost me \(unlikeable.damages)")
    } else if currentAnimal is Pet {
        print("I love this pet")
        currentAnimal.speak()
    } else if currentAnimal is WildAnimal {
        let dangerous = currentAnimal as! WildAnimal
        if dangerous.isPoisonous {
            print("This wild beast has already killed 3 people")
        } else {
            print("This wild beast too strong")
        }
    } else if currentAnimal is Animal {
        print("Come here and we shall see it under the microscope")
    }
}

for creature in myPetShop{
    iDoDifferentStuff(currentAnimal:creature)
}

//: [⇒ Next: 04 - Initializers](@next)
