//: [⇐ Previous: 02 - Enumerations](@previous)
//: ## Episode 03: Challenge - Enumerations

import SwiftUI

/*:
 ## Challenge 1
 Another handy use case for an enumeration is storing a specific set of strings you need to use!
 - Create a "Suit" enumeration with a `String` raw value type
 - Make a case for each string used to create an `Image` in the code below. (Watch for misspellings!)
 - Replace each use of a string with the raw value of an enumeration case
*/

// TODO: Write enumeration here
enum Suit: String {
    case spades = "suit.spade.fill"
    case hearts = "suit.heart.fill"
    case diamonds = "suite.diamond.fill"
    case clubs = "suit.club.fil"
}

// --------------------------------------
let heart = Image(systemName: Suit.hearts.rawValue).resizable()
let club = Image(systemName: Suit.clubs.rawValue).resizable()
let spade = Image(systemName: Suit.spades.rawValue).resizable()
let diamond = Image(systemName: Suit.diamonds.rawValue).resizable()
// --------------------------------------



/*:
 ## Challenge 2
 Integer raw values don’t have to be in an incremental order! Coins are a good use case.
 
 - Create an enumeration called "Coin" and add cases for different types of coins.
 - Create an array called `coinPurse` that contains coins. Add an assortment of pennies, nickels, dimes, and quarters (or whatever coins you used!) to it.
*/

// TODO: Write solution here
enum Coin:Int{
    case pennies = 1
    case nickels = 5
    case dimes   = 10
    case quarters = 25
    case loonies = 100
    case tunies = 200
}

var coinPurse:[Int]=[]
coinPurse.append(Coin.pennies.rawValue)
coinPurse.append(Coin.dimes.rawValue)
coinPurse.append(Coin.nickels.rawValue)
coinPurse.append(Coin.quarters.rawValue)
coinPurse.append(Coin.loonies.rawValue)
coinPurse.append(Coin.tunies.rawValue)

/*:
 ## Bonus Challenge!
 Try using `reduce` to figure out how much money is in your coin purse.
 Remember to use the `rawValue` property!
*/

let myMoney = coinPurse.reduce(0, { x, y in (x + y)})


//: [⇒ Next: 04 - Switch Statements](@next)
