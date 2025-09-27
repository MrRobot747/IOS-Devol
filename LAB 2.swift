import Foundation

// -----------------
// Problem 1: FizzBuzz
// -----------------
for i in 1...100 {
    if i % 3 == 0 && i % 5 == 0 {
        print("FizzBuzz")
    } else if i % 3 == 0 {
        print("Fizz")
    } else if i % 5 == 0 {
        print("Buzz")
    } else {
        print(i)
    }
}

// -----------------
// Problem 2: Prime Numbers
// -----------------
func isPrime(_ number: Int) -> Bool {
    if number < 2 { return false }
    for i in 2..<number {
        if number % i == 0 { return false }
    }
    return true
}

for i in 1...100 {
    if isPrime(i) {
        print(i)
    }
}

// -----------------
// Problem 3: Temperature Converter
// -----------------
let value = 100.0  
let unit = "C"     // варианты: "C", "F", "K"

func celsiusToFahrenheit(_ c: Double) -> Double { return c * 9/5 + 32 }
func celsiusToKelvin(_ c: Double) -> Double { return c + 273.15 }
func fahrenheitToCelsius(_ f: Double) -> Double { return (f - 32) * 5/9 }
func kelvinToCelsius(_ k: Double) -> Double { return k - 273.15 }

if unit == "C" {
    print("F:", celsiusToFahrenheit(value))
    print("K:", celsiusToKelvin(value))
} else if unit == "F" {
    let c = fahrenheitToCelsius(value)
    print("C:", c)
    print("K:", celsiusToKelvin(c))
} else if unit == "K" {
    let c = kelvinToCelsius(value)
    print("C:", c)
    print("F:", celsiusToFahrenheit(c))
}

// -----------------
// Problem 4: Shopping List Manager
// -----------------
var shoppingList = ["Milk", "Bread"]
shoppingList.append("Eggs")        // add
shoppingList.remove(at: 0)         // remove first
print("Shopping list:", shoppingList)

// -----------------
// Problem 5: Word Frequency Counter
// -----------------
let sentence = "Hello hello world, hello Swift!"
let words = sentence.lowercased()
    .components(separatedBy: CharacterSet.alphanumerics.inverted)
    .filter { !$0.isEmpty }

var freq: [String:Int] = [:]
for w in words {
    freq[w, default: 0] += 1
}
print(freq)

// -----------------
// Problem 6: Fibonacci Sequence
// -----------------
func fibonacci(_ n: Int) -> [Int] {
    if n <= 0 { return [] }
    if n == 1 { return [0] }
    var seq = [0, 1]
    while seq.count < n {
        seq.append(seq[seq.count-1] + seq[seq.count-2])
    }
    return seq
}
print(fibonacci(10))

// -----------------
// Problem 7: Grade Calculator
// -----------------
let students = ["A": 80, "B": 95, "C": 60]
let scores = Array(students.values)
let avg = Double(scores.reduce(0, +)) / Double(scores.count)
let maxScore = scores.max()!
let minScore = scores.min()!

print("Average:", avg)
print("Max:", maxScore, "Min:", minScore)

for (name, score) in students {
    let status = score >= Int(avg) ? "Above average" : "Below average"
    print("\(name): \(score) - \(status)")
}

// -----------------
// Problem 8: Palindrome Checker
// -----------------
func isPalindrome(_ text: String) -> Bool {
    let cleaned = text.lowercased().filter { $0.isLetter }
    return cleaned == String(cleaned.reversed())
}
print(isPalindrome("A man a plan a canal Panama"))

// -----------------
// Problem 9: Simple Calculator
// -----------------
let num1 = 10.0, num2 = 0.0, op = "/"

func add(_ a: Double, _ b: Double) -> Double { a + b }
func sub(_ a: Double, _ b: Double) -> Double { a - b }
func mul(_ a: Double, _ b: Double) -> Double { a * b }
func div(_ a: Double, _ b: Double) -> Double? { b == 0 ? nil : a / b }

if op == "+" {
    print(add(num1,num2))
} else if op == "-" {
    print(sub(num1,num2))
} else if op == "*" {
    print(mul(num1,num2))
} else if op == "/" {
    if let res = div(num1,num2) {
        print(res)
    } else {
        print("Error: Division by zero")
    }
}

// -----------------
// Problem 10: Unique Characters
// -----------------
func hasUniqueCharacters(_ text: String) -> Bool {
    var seen: Set<Character> = []
    for ch in text {
        if seen.contains(ch) {
            return false
        }
        seen.insert(ch)
    }
    return true
}
print(hasUniqueCharacters("Swift"))
print(hasUniqueCharacters("Hello"))
