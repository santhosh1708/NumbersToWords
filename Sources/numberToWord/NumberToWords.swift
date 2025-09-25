// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
public struct NumberToWords {
    
    private static let ones: [Int: String] = [
        0: "zero", 1: "one", 2: "two", 3: "three", 4: "four",
        5: "five", 6: "six", 7: "seven", 8: "eight", 9: "nine",
        10: "ten", 11: "eleven", 12: "twelve", 13: "thirteen",
        14: "fourteen", 15: "fifteen", 16: "sixteen",
        17: "seventeen", 18: "eighteen", 19: "nineteen"
    ]
    
    private static let tens: [Int: String] = [
        20: "twenty", 30: "thirty", 40: "forty",
        50: "fifty", 60: "sixty", 70: "seventy",
        80: "eighty", 90: "ninety"
    ]
    
    private static let thousands: [Int: String] = [
        1: "thousand", 2: "million", 3: "billion",
        4: "trillion", 5: "quadrillion", 6: "quintillion"
    ]
    
    private static let wordToNumberMap: [String: Int] = [
          "zero": 0, "one": 1, "two": 2, "three": 3, "four": 4,
          "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9,
          "ten": 10, "eleven": 11, "twelve": 12, "thirteen": 13,
          "fourteen": 14, "fifteen": 15, "sixteen": 16,
          "seventeen": 17, "eighteen": 18, "nineteen": 19,
          "twenty": 20, "thirty": 30, "forty": 40, "fifty": 50,
          "sixty": 60, "seventy": 70, "eighty": 80, "ninety": 90,
          "hundred": 100, "thousand": 1_000, "million": 1_000_000,
          "billion": 1_000_000_000, "trillion": 1_000_000_000_000
      ]
    
    public static func convert(_ number: Int) -> String {
        if number == 0 { return "zero" }
        
        var num = number
        var parts: [String] = []
        var chunkIndex = 0
        
        while num > 0 {
            let chunk = num % 1000
            if chunk > 0 {
                var chunkWords = convertChunk(chunk)
                if chunkIndex > 0, let suffix = thousands[chunkIndex] {
                    chunkWords += " " + suffix
                }
                parts.insert(chunkWords, at: 0)
            }
            num /= 1000
            chunkIndex += 1
        }
        
        return parts.joined(separator: " ")
    }
    
    public static func convertRange(_ range: ClosedRange<Int>) -> [String] {
         return range.map { NumberToWords.convert($0) }
     }
    
    private static func convertChunk(_ number: Int) -> String {
        var n = number
        var words: [String] = []
        
        if n >= 100 {
            let hundreds = n / 100
            words.append("\(ones[hundreds]!) hundred")
            n %= 100
        }
        
        if n >= 20 {
            let ten = (n / 10) * 10
            words.append(tens[ten]!)
            n %= 10
        }
        
        if n > 0 {
            words.append(ones[n]!)
        }
        
        return words.joined(separator: " ")
    }
    
    public static func convertWordToNumber(_ words: String) -> Int? {
          let tokens = words.lowercased().split(separator: " ").map { String($0) }
          var total = 0
          var current = 0
          
          for token in tokens {
              guard let value = wordToNumberMap[token] else {
                  return nil  // unknown word
              }
              
              if value == 100 {
                  current *= value
              } else if value >= 1000 {
                  current *= value
                  total += current
                  current = 0
              } else {
                  current += value
              }
          }
          total += current
          return total
      }
    
    // MARK: - Decimal conversion (Double)
      public static func convertDecimal(_ number: Double) -> String {
          let intPart = Int(number)
          let decimalPart = number - Double(intPart)
          
          var result = convert(intPart)
          
          if decimalPart > 0 {
              let decimalString = String(decimalPart).split(separator: ".")[1]
              let decimalWords = decimalString.map { NumberToWords.convert(Int(String($0))!) }
              result += " point " + decimalWords.joined(separator: " ")
          }
          
          return result
      }
    
    public static func convertWordToDecimal(_ words: String) -> Double? {
        // Explicit CharacterSet reference
        let lowercased = String(words).lowercased()
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // Split at " point "
        let parts = lowercased.components(separatedBy: " point ")
        
        guard !parts.isEmpty else { return nil }
        
        // Integer part
        guard let intPart = convertWordToNumber(String(parts[0])
            .trimmingCharacters(in: CharacterSet.whitespaces)) else {
            return nil
        }
        
        var result = Double(intPart)
        
        // Fractional part
        if parts.count > 1 {
            let decimalWords = parts[1].split(separator: " ")
            var decimalString = ""
            
            for sub in decimalWords {
                let word = String(sub)
                if let digit = wordToNumberMap[word] {
                    decimalString += String(digit)
                } else {
                    return nil
                }
            }
            
            if let decimalValue = Double("0." + decimalString) {
                result += decimalValue
            } else {
                return nil
            }
        }
        
        return result
    }



}
