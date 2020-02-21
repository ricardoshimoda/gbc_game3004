//: [⇐ Previous: 04 - Initializers](@previous)
//: ## Episode 05: Challenge: Initializers

/*:
 ## Challenge 1 😃
 Create a class named `Animal` that has…
 1. a single stored property named `name`, that is a `String`
 2. a required initializer that takes `name` as a parameter
 3.  a function `speak()` that does nothing.
 */

// TODO: Write solution here

class Animal {
    var name:String
    init(name:String){
        self.name = name
    }
    func speak(){}
}

/*:
 Create a class named `Dog` that…
 1. inherits from `Animal`
 2. has a property that stores how many tricks it has learned
 3. implements the required initializer, defaulting the trick count to `0`, and calling `speak()` at the end
 4. overrides the function `speak()` to greet you and says its name
 */

// TODO: Write solution here
class Dog:Animal{
    var numTricksLearned:Int
    
    required override init(name:String){
        self.numTricksLearned = 0
        super.init(name:name)
        //self.init(name:name, numTricksLearned:0)
        speak()
    }

    init(name:String, numTricksLearned:Int){
        self.numTricksLearned=numTricksLearned
        super.init(name:name)
        speak()
    }
    
    convenience init(learntTricks:Int){
        self.init(name:"Rover", numTricksLearned:0)
    }
    override func speak(){
        print("Hi human, my name is \(name)")
    }
}


/*:
 Add a second (non-required) initializer to `Dog` that takes both the `name` and `numTricksLearned` as parameters. Then call this initializer from the required initializer.
 */

/*:
 Add a convenience initializer to `Dog` that defaults the dog's name to your favorite dog's name, with however many tricks the dog has learned.
 */

//: [⇒ Next: 06 - Protocols](@next)

