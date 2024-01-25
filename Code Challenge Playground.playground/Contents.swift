import UIKit

/// Odd Numbers
let n = 10

print((1...n).filter { $0 % 2 == 1 })

print((1...n).filter { $0 ^ 1 == $0 - 1})

stride(from: 1, to: n + 1, by: 2).forEach { print($0) }

///Swap function
func swap<E: Equatable>(_ left: inout E, _ right: inout E) {
   guard left != right else {
       return
   }
   (left, right) = (right, left)
}

var f = "foo"
var b = "boo"
print("f: \(f), b:\(b)")
swap(&f, &b)
print("f: \(f), b:\(b)")


///Filter Prime Number
func findPrimes(_ numbers: [Int]) -> [Int] {
   var primes = [Int]()

   for number in numbers {
       if number <= 1 {
           continue
       }

       var isPrime = true

       for i in 2..<number {
           if number % i == 0 {
               isPrime = false
               break
           }
       }
       if isPrime {
           primes.append(number)
       }
   }

   return primes
}

func isPrime(num: Int) -> Bool {
   if num < 2 {
       return false
   }

   for i in 2..<num {
       if num % i == 0 {
           return false
       }
   }

   return true
}

func randomArray(len: Int) -> [Int] {
   var results = [Int]()

   for num in 0..<len {
       results.append(num)
   }

   return results.filter(isPrime)
}

print(findPrimes([2,3,4,5]))
print(randomArray(len: 6))

///Count days between two dates
func daysIn24HoursBetween(from: Date, to: Date) -> Int? {
   Calendar.current.dateComponents([.day], from: from, to: to).day
}

func daysInMidNightsBetween(from: Date, to: Date) -> Int? {
   let calendar = Calendar.current

   let startOfFromDay = calendar.startOfDay(for: from)
   let startOfToDay = calendar.startOfDay(for: to)

   return calendar.dateComponents([.day], from: startOfFromDay, to: startOfToDay).day
}

enum TimeUnit {
   case fullDay
   case midnight
}

func daysBetween(from: Date, to: Date, unit: TimeUnit) -> Int? {
   let result: Int?

   switch unit {
   case .fullDay:
       result = daysIn24HoursBetween(from: from, to: to)
   case .midnight:
       result = daysInMidNightsBetween(from: from, to: to)
   }

   return result
}

if let startDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()),
  let toDate = Calendar.current.date(byAdding: DateComponents(second: 5), to: startDate) {
   if let days = daysIn24HoursBetween(from: startDate, to: toDate) {
       print(days)
   }

   if let midnights = daysInMidNightsBetween(from: startDate, to: toDate) {
       print(midnights)
   }

   if let days = daysBetween(from: startDate, to: toDate, unit: .fullDay) {
       print(days)
   }

   if let midnights = daysBetween(from: startDate, to: toDate, unit: .midnight) {
       print(midnights)
   }
}


/// Calculate Sum(n)
func sum(_ n: Int) -> Int {
   var total = 0
   for i in 0...n {
       total += i
   }
   return total
   (n * (n+1))/2
}

print(sum(5))
print(sum(20))

/// Rock Paper Scissors
enum Choice: String, CaseIterable {
   case rock
   case paper
   case scissors
}

enum Outcome: String {
   case win
   case loose
   case draw
}
func playRockPaperScissors(choice: Choice) -> Outcome {
   guard let dealersChoice = Choice.allCases.randomElement() else { return .win }
   var result = Outcome.draw

   switch (choice, dealersChoice) {
   case (.paper, .rock), (.scissors, .paper), (.rock, .scissors):
       result = .win
   case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
       result = .loose
   default:
       result = .draw
   }

   return result
}

let userChoice = Choice.rock
print(playRockPaperScissors(choice: userChoice))


///Convert dictionary to JSON
let colorsDict = ["red": "FF0000", "green": "00FF00", "blue": "0000FF"] //["red": UIColor.red, "green": UIColor.green, "blue": UIColor.green]

// 1. Using JSONEncoder
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

if let jsonData = try? encoder.encode(colorsDict) {
   if let jsonString = String(data: jsonData, encoding: .utf8) {
       print("Json String: " + jsonString)
   }
}

// 2. Using JSONSerialization
if let jsonData = try? JSONSerialization.data(withJSONObject: colorsDict, options: [.prettyPrinted]) {
   if let jsonString = String(data: jsonData, encoding: .utf8) {
       print("Json String: " + jsonString)
   }
}

// 3. Elegance
extension Dictionary {
   func toJSONStirng() -> String? {
       guard let jsonData = try? JSONSerialization.data(withJSONObject: colorsDict, options: [.prettyPrinted]) else { return nil }
       return String(data: jsonData, encoding: .utf8)
   }
}

if let jsonString = colorsDict.toJSONStirng() {
   print("Json String: " + jsonString)
}

///Count Vowels and Consonants
func countVowels(_ text: String) -> Int {
   var totalCount = 0
   text.lowercased().forEach { char in
       switch char {
       case "a","e","i","o","u":
           totalCount += 1
       default:
           break
       }
   }
   return totalCount
}

func countConsonants(_ text: String) -> Int {
   let letters = text.filter { $0.isLetter }.lowercased()
   return letters.count - countVowels(letters)
}

print("Number of Vowels: \(countVowels("Isn't Swift fun?"))")
print("Number of Consonants: \(countConsonants("Isn't Swift fun?"))")

///Find missing Number
func smallestMissingNumber(_ numbers: [Int]) -> Int {
   var result = 1
   var last = 0

   guard !numbers.isEmpty else {
       return result
   }

   numbers.sorted().forEach { num in
       if result == num {
           result += 1
       }
   }

   for number in numbers.filter({ $0 > 0 }).sorted() {
       if last == number {
           continue
       } else if result < number {
           return result
       }

       result += 1
       last = number
   }

   return result
}

smallestMissingNumber([1,3,4])
smallestMissingNumber([-2,4,1,2,2])
smallestMissingNumber([])
smallestMissingNumber([0])
smallestMissingNumber([1,4,11,111])


///Generate randomn passwords
func generatePassword(_ length: Int) -> String {
   var passwordCharSet = "abcdefghijklmnopqrstuvwxyz"
   passwordCharSet += passwordCharSet.uppercased()
   passwordCharSet += "~`!@#$%^&*()-_==|][{},.<>/?"
   passwordCharSet += "1234567890"

    /*
    var password = ""
    for _ in 0..<length {
        if let randomChar = passwordCharSet.randomElement() {
            password.append(randomChar)
        }
    }
    return password
     */
   return String((0..<length).compactMap{ _ in passwordCharSet.randomElement() })
}

print(generatePassword(12))

///Check for palindromes
func isPalindrome(_ text: String) -> Bool {
   let text = text.filter { $0.isLetter }
   guard text.count > 1 else { return true }
   return text.elementsEqual(text.reversed())
   return String(text.reversed()).caseInsensitiveCompare(text) == .orderedSame

    // Two pointer Index method
   let chars = Array(text.lowercased())

   var leftIndex = 0
   var rightIndex = chars.count - 1

   while leftIndex < rightIndex {
       if chars[leftIndex] != chars[rightIndex] {
           return false
       }
       leftIndex += 1
       rightIndex -= 1
   }

   return true
}

isPalindrome("Dad")
isPalindrome("moM")
isPalindrome("daddy")

print(isPalindrome("Amore, Roma"))
print(isPalindrome("A man, a plan, a canal: Panama"))

import Security

///Storing strings securely
func secureStore(string: String, forKey key: String) -> Bool {
    guard !string.isEmpty && !key.isEmpty else {
        return false
    }

    let queryDictionary: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecValueData as String: string.data(using: .utf8)!,
                                          kSecAttrAccount as String: key.data(using: .utf8)!]
    return false
}
