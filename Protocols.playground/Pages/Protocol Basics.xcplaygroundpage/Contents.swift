import Foundation

//: # Protocols
//: Protocols are, as per Apple's definition in the _Swift Programming Language_ book:
//:
//: "... a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements. Any type that satisfies the requirements of a protocol is said to conform to that protocol."
//:
//: The below example shows a protocol that requires conforming types have a particular property defined.
// Getter - Read Access
// Setter - Write Access
protocol FullyNamed {
    var fullName: String { get }
    
}
// Adoption
// Conformance
struct Person: FullyNamed {
    var fullName: String
    
    
}

let michael = Person(fullName: "Michael Self")
let bronson = Person(fullName: "Bronson Mullens")

print(bronson.fullName)

class StarsShip: FullyNamed {
    var prefix: String?
    var name: String
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    // Computed Property ( Calculated Property_
    var fullName: String {
        // Ternary Operator
        return  (prefix != nil ? prefix! + " " : " ") + self.name
    }
    
}

var ncc1701 = StarsShip(name: "Enterprise", prefix: "USS")

ncc1701.fullName

var firefly = StarsShip(name: "Serenity")

firefly.fullName

//: Protocols can also require that conforming types implement certain methods.

protocol GenerateRandomNumers {
    func random() -> Int
}

class OneThroughTen: GenerateRandomNumers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
}

let rand = OneThroughTen()
rand.random()
//: Using built-in Protocols:
extension StarsShip: Equatable {
    static func == (lhs: StarsShip, rhs: StarsShip) -> Bool {
        if lhs.fullName == rhs.fullName { return true }
        else { return false }
}
}

if ncc1701 == firefly {
    print("same starship")
}



//: ## Protocols as Types
class Dice {
    let sides: Int
    let generator: GenerateRandomNumers
    
    init(sides: Int, generator: GenerateRandomNumers) {
        self.generator = generator
        self.sides = sides
    }
    
    func roll() -> Int {
        return Int(generator.random() % sides) + 1
    }
}


var d6 = Dice(sides: 6, generator: OneThroughTen())
for _ in 1...5 {
    print("random dice roll is \(d6.roll())")
}
