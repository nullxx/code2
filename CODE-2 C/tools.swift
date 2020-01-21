//
//  tools.swift
//  CODE-2 C
//
//  Created by Jon Lara Trigo on 19/01/2020.
//  Copyright © 2020 Jon Lara Trigo. All rights reserved.
//

import Foundation
import Cocoa

let instruccionesHex = [
"LD",
"ST",
"LLI",
"LHI",
"IN",
"OUT",
"ADDS",
"SUBS",
"NAND",
"SHL",
"SHR",
"SHRA",
"B-",
"CALL-",
"RET",
"HALT"
]

func alert(title: String, msg: String) {
    let alert = NSAlert()
    alert.messageText = title
    alert.informativeText = msg
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    DispatchQueue.main.async {
        alert.runModal()
    }
}
func hexStringtoAscii(hexString : String) -> String {

    let pattern = "(0x)?([0-9a-f]{2})"
    let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    let nsString = hexString as NSString
    let matches = regex.matches(in: hexString, options: [], range: NSMakeRange(0, nsString.length))
    let characters = matches.map {
        Character(UnicodeScalar(UInt32(nsString.substring(with: $0.range(at: 2)), radix: 16)!) ?? "0")
    }
    return String(characters)
}

func createMemoryString(fromString: String)->String{
    return "[" + fromString + "]"
}
func splitByLineBreak(text: String)->Array<Substring>{
    return text.split(separator: "\n")
}
func ask(question: String, text: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "SI")
    alert.addButton(withTitle: "NO")
    return alert.runModal() == .alertFirstButtonReturn
}
func readFile(fromPath: String) -> String {
    var result = ""
        do {
            let contents = try String(contentsOfFile: fromPath)
            result = contents
        } catch {
            alert(title: "Error", msg: "No se ha podido leer el archivo")
        }
    return result
 
}
func getDireccionesM(from: Array<Substring>)->Array<String>{
    var arrayOfDirecciones = [String]()
    for x in from{
        let Dmemoria = x.components(separatedBy: "[")[1].components(separatedBy: "]")[0]
        arrayOfDirecciones.append(Dmemoria)
    }
    return arrayOfDirecciones
}
func search(something: String, ina: Array<String>) -> Int{
    var result = -1 // -1 -> soltar error, no existe el valor de memoria
    for x in ina{
        if (something == x){
            result = ina.firstIndex(where: {$0 == x}) ?? -1
            break
        }
    }
    return result
}

func sumar1Hex(hex: String)-> String{
    let num = hexToInt(hex: hex)
    let suma = num+1
    return intToHex(num: suma, leading: 4)
}
func sumarFromHex(sum1: String, sum2: String)->String{
    let num1 = hexToInt(hex: sum1)
    let num2 = hexToInt(hex: sum2)
    let suma = num1+num2
    return intToHex(num: suma, leading: 4)
}
func restarFromHex(r1: String, r2: String)->String{
    let num1 = hexToInt(hex: r1)
    let num2 = hexToInt(hex: r2)
    let suma = num1-num2
    return intToHex(num: suma, leading: 4)
}
var memoriaPila = [String]()
func getLastMemoriaPila()->String{
    return memoriaPila.popLast() ?? ""
}
func insertMemoriaPila(_ new: String){
    memoriaPila.append(new)
}
func intToHex(num: Int, leading: Int)->String{
    return String(format:"%0\(leading)X", num)
}
func hexToInt(hex: String)->Int{
    return Int(hex, radix: 16) ?? 0
}
private func limitString(forS: String, limit: Int, asc: Bool)->String{
    if (asc){
        let index = forS.index(forS.startIndex, offsetBy: limit)
        let mySubstring = forS[..<index] // Hello
        return String(mySubstring)
    }else{
        let index = forS.index(forS.endIndex, offsetBy: -limit)
        let mySubstring = forS[index...] // Hello
        return String(mySubstring)
    }
}
func restCeros(text: String, numOfCeros: Int, biestableV: NSButton, biestableC: NSButton) ->String {
    let count = numOfCeros - text.count
    if (count < 0){
        //bidestable acarreo text[0], bidestable overflow true
        biestableC.state = .on
        biestableC.state = .on // valor de text[0]
        return limitString(forS: text, limit: 4, asc: false)
    }
    return String(repeating: "0", count: count) + text
}
func binToHex(bin : String) -> String {
    let num = bin.withCString { strtoul($0, nil, 2) }
    let hex = String(num, radix: 16, uppercase: true) 
    return hex
}
func getBiActivated(biestableV: NSButton, biestableC: NSButton, biestableS: NSButton, biestableZ: NSButton)-> Array<String>{
    var result = [String]()
    if (biestableV.state == .on){
        result.append("V")
    }
    if (biestableC.state == .on){
        result.append("C")
    }
    if (biestableS.state == .on){
        result.append("S")
    }
    if (biestableZ.state == .on){
        result.append("Z")
    }
    return result
}
extension String {
    typealias Byte = UInt8
    var hexaToBytes: [Byte] {
        var start = startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in   // use flatMap for older Swift versions
            let end = index(after: start)
            defer { start = index(after: end) }
            return Byte(self[start...end], radix: 16)
        }
    }
    var hexaToBinary: String {
        return hexaToBytes.map {
            let binary = String($0, radix: 2)
            return repeatElement("0", count: 8-binary.count) + binary
        }.joined()
    }
}
extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}
