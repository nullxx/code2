//
//  tools.swift
//  CODE-2 C
//
//  Created by Jon Lara Trigo on 19/01/2020.
//  Copyright © 2020 Jon Lara Trigo. All rights reserved.
//

import Foundation
import Cocoa

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
    let num = Int(hex, radix: 16) ?? 0
    let suma = num+1
    return String(format:"%04X", suma)
}
func sumarFromHex(sum1: String, sum2: String)->String{
    let num1 = Int(sum1, radix: 16) ?? 0
    let num2 = Int(sum2, radix: 16) ?? 0
    let suma = num1+num2
    return String(format:"%04X", suma)
}
extension Substring {
typealias Byte = UInt8
var hexaToBytes: [Byte] {
    var start = startIndex
    return stride(from: 0, to: count, by: 2).compactMap { _ in   // use flatMap for older Swift versions
        let end = index(after: start)
        defer { start = index(after: end) }
        return Byte(self[start...end], radix: 16)
        }
    }
}
