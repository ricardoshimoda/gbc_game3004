import Foundation

// Exercise 1
var secondsInYear = 60 * 60 * 24 * 366
print("There are approximately \(secondsInYear) seconds in a year.\n");

// Exercise 2
var width = 1920
var height = 1080
var resolution = "\(width) x \(height)"
var numPixels = width * height
print("Resolution: \(resolution)\nNumber of Pixels: \(numPixels)\n")

// Exercise 3
func CheckName(list: [String], name: String) -> Bool
{
    for theName in list
    {
        if theName == name
        {
            print("\(name) is in the list.")
            return true
        }
    }
    print("\(name) is not in the list.")
    return false
}

var listOfNames = ["Jackson", "Ricardo", "Brody", "Michael", "Alex"]
CheckName(list:listOfNames, name:"Charlie")
CheckName(list:listOfNames, name:"Brody")

// Exercise 1 - Optional
var optString: String?
var optInt: Int?
optInt = nil

// Exercise 2 - Optional
optString = nil
if (optString == nil)
{
    print("\nThe string is nil")
}  
else
{
    print("\n\(optString)")
}
    
// Exercise 3 - Optional
var errorCodeString: String?
errorCodeString = "404"
print("\n\(errorCodeString!)")

var famousActors: [String]? = ["Donnie Darko", "Corey Baxter", "Jim Carrey"]
print("\(famousActors!)\n")

// Exercise 4 - Initializers
class Animal
{
    var name: String

    required init(name: String)
    {
        self.name = name
    }

    func speak()
    {

    }
}

class Dog: Animal
{

    var numTricksLearned: Int

    required init(name: String)
    {
        numTricksLearned = 0
        super.init(name: name)
        speak()
    }

    override func speak()
    {
        print("Bow Wow")
    }
}




