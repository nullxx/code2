//
//  codeEditorViewController.swift
//  CODE-2
//
//  Created by Jon Lara Trigo on 22/11/2019.
//  Copyright © 2019 Jon Lara Trigo. All rights reserved.
//

import Foundation
import Cocoa
@available(OSX 10.12.2, *)
class codeEditorViewController: NSViewController {

    var formattedCode = ""
    var programCounterCodeNow = ""
    var registroPrograma = ""
    var saved = false
    override func viewDidLoad() {
        editorInput.isAutomaticDashSubstitutionEnabled = false
        editorInput.isAutomaticSpellingCorrectionEnabled = false
        editorInput.isAutomaticDataDetectionEnabled = false
        editorInput.isAutomaticLinkDetectionEnabled = false
        editorInput.isAutomaticQuoteSubstitutionEnabled = false
        editorInput.isAutomaticTextCompletionEnabled = false
        editorInput.isAutomaticTextReplacementEnabled = false
        preferredContentSize = view.frame.size
    }
    @IBOutlet weak var editorInput: NSTextView!
    @IBOutlet weak var codigoOutput: NSTextField!
    @IBAction func abrirArchivo(_ sender: NSButton) {
    }
    @IBAction func cerrarView(_ sender: NSButton) {
        if (saved || formattedCode.count == 0){
            dismiss(self)
        }else{
            let respuesta = ask(question: "¡Cuidado!", text: "No has guardado tu archivo, ¿seguro que quieres cerrar?")
            if (respuesta == true){
                dismiss(self)
            }
        }

        
        
    }
    @IBAction func guardarArchivo(_ sender: NSButton) {

        if formattedCode != "" {
            let mySave = NSSavePanel()
            mySave.allowedFileTypes = ["txt"]
            mySave.begin { (result) -> Void in

                if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                    let filename = mySave.url

                    do {
                        try self.formattedCode.write(to: filename!, atomically: true, encoding: String.Encoding.utf8)
                        self.saved = true
                        self.fileStatus.image? = NSImage(named: "NSStatusAvailable")!
                        self.setProgramarRegistro(new: "Se ha guardado el archivo: \(filename!)")
                    } catch {
                        // failed to write file (bad permissions, bad filename etc.)
                        self.setProgramarRegistro(new: "Ha habido un error guardando el archivo.")
                    }

                } else {
                    self.setProgramarRegistro(new: "Se ha cancelado guardar el archivo.")

                }
            
            }
        }else{
            self.setProgramarRegistro(new: "No existe codigo para guardar.")
        }
    }
    @IBOutlet weak var fileStatus: NSImageView!
    @IBOutlet var registroOutput: NSTextView!
    @IBAction func close(_ sender: NSButton) {
    }
    
    @IBAction func convertirCodigo(_ sender: NSButton) {
        if (editorInput.string == ""){
            setProgramarRegistro(new: "No existe nada para convertir.")
        }else{
            formattedCode = ""
            self.saved = false
            convertirCodigo(editorInput.string)
            setProgramarRegistro(new: "Sin errores")
        }

        
    }
    func convertirCodigo(_ contenido: String){
        let contenido_1 = splitByLineBreak(text: contenido)
        
        for x in contenido_1{
            let linea = x
            createInstruccion(String(linea))
            
            
        }
    }
    func createInstruccion(_ s: String){
        let direccionSettear = s.matchingStrings(regex: "ORG H'([0-F]{4})")
        let instruccionLD = s.matchingStrings(regex: "LD r([0-F]),\\s*\\[H'([0-F]{2})\\]")
        let instruccionST = s.matchingStrings(regex: "ST \\[H'([0-F]{2})\\],\\s*r([0-F])")
        let instruccionLLI = s.matchingStrings(regex: "LLI r([0-F]),\\s*H'([0-F]{2})")
        let instruccionLHI = s.matchingStrings(regex: "LHI r([0-F]),\\s*H'([0-F]{2})")
        let instruccionIN = s.matchingStrings(regex: "IN r([0-F]),\\s*IP([0-2]{2})") // solo soporta el input 01 y 02
        let instruccionOUT = s.matchingStrings(regex: "OUT OP([0-2]{2}),\\s*r([0-F])") // solo soporta el output 01 y 02
        let instruccionADDS = s.matchingStrings(regex: "ADDS r([0-F]),\\s*r([0-F]),\\s*r([0-F])")
        let instruccionSUBS = s.matchingStrings(regex: "SUBS r([0-F]),\\s*r([0-F]),\\s*r([0-F])")
        let instruccionNAND = s.matchingStrings(regex: "NAND r([0-F]),\\s*r([0-F]),\\s*r([0-F])")
        let instruccionSHL = s.matchingStrings(regex: "SHL r([0-F])")
        let instruccionSHR = s.matchingStrings(regex: "SHR r([0-F])")
        let instruccionSHRA = s.matchingStrings(regex: "SHRA r([0-F])")
        let instruccionB = s.matchingStrings(regex: "B([ZSCVR])")
        let instruccionCALL = s.matchingStrings(regex: "CALL([ZSCVR])")
        let instruccionRET = s.matchingStrings(regex: "RET")
        let instruccionHALT = s.matchingStrings(regex: "HALT")

        if (direccionSettear.count > 0){
            programCounterCodeNow = direccionSettear[0][1]
        }
            
            
            
        if (instruccionLD.count > 0){
            let op1 = instruccionLD[0][1]
            let op2 = instruccionLD[0][2]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): LD r\(op1), [H'\(op2)]\n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionST.count > 0){
            let op1 = instruccionST[0][1]
            let op2 = instruccionST[0][2]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): ST [H'\(op1)], r\(op2)\n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionLLI.count > 0){
            let op1 = instruccionLLI[0][1]
            let op2 = instruccionLLI[0][2]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): LLI r\(op1), H'\(op2)\n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionLHI.count > 0){
            let op1 = instruccionLHI[0][1]
            let op2 = instruccionLHI[0][2]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): LHI r\(op1), H'\(op2)\n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionIN.count > 0){
            let op1 = instruccionIN[0][1]
            let op2 = instruccionIN[0][2]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): IN r\(op1), IP\(op2)\n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionOUT.count > 0){
            let op1 = instruccionOUT[0][1]
            let op2 = instruccionOUT[0][2]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): OUT OP\(op1), r\(op2)\n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionADDS.count > 0){
            let op1 = instruccionADDS[0][1]
            let op2 = instruccionADDS[0][2]
            let op3 = instruccionADDS[0][3]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): ADDS r\(op1), r\(op2), r\(op3)\n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionSUBS.count > 0){
            let op1 = instruccionSUBS[0][1]
            let op2 = instruccionSUBS[0][2]
            let op3 = instruccionSUBS[0][3]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): SUBS r\(op1), r\(op2), r\(op3)\n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionNAND.count > 0){
            let op1 = instruccionNAND[0][1]
            let op2 = instruccionNAND[0][2]
            let op3 = instruccionNAND[0][3]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): NAND r\(op1), r\(op2), r\(op3)\n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionSHL.count > 0){
            let op1 = instruccionSHL[0][1]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): SHL r\(op1) , \n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionSHR.count > 0){
            let op1 = instruccionSHR[0][1]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): SHR r\(op1) , \n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionSHRA.count > 0){
            let op1 = instruccionSHRA[0][1]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): SHRA r\(op1) , \n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionB.count > 0){
            let op1 = instruccionB[0][1]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): B\(op1) , \n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionCALL.count > 0){
            let op1 = instruccionCALL[0][1]
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): CALL\(op1) , \n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionRET.count > 0){
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): RET , \n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }else if (instruccionHALT.count > 0){
            let memoryString = createMemoryString(fromString: programCounterCodeNow)
            formattedCode += "\(memoryString): HALT , \n"
            codigoOutput.stringValue = formattedCode
            programCounterCodeNow = sumar1Hex(hex: programCounterCodeNow)
        }
    }
    func setProgramarRegistro(new: String){
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        
        self.registroPrograma += dateString + ": " + new + "\n"
        registroOutput.string = self.registroPrograma
        let smartScroll = self.registroOutput.visibleRect.maxY == self.registroOutput.bounds.maxY

        if smartScroll{
            self.registroOutput.scrollToEndOfDocument(self)
        }
    }
    
}
extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
    }
}
