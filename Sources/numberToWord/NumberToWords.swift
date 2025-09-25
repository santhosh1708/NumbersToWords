// The Swift Programming Language
// https://docs.swift.org/swift-book
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
}
