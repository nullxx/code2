//
//  ViewController.swift
//  CODE-2 C
//
//  Created by Jon Lara Trigo on 19/01/2020.
//  Copyright © 2020 Jon Lara Trigo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var encendido = false
    var registro = ""
    var listaPosiciones = [String]()
    var listaMemoriavalores = [String]()
    var memoryHex = [String]()
    var sourceCodeExecuted = [Substring]()
    var direccionesCodeSourceMemoria = [String]()
    var tempLastCounter = "0000"
    override func viewDidLoad() {
        super.viewDidLoad()
        allocateMemory()
        configTableViews()
        tempLastCounter = programCounter.stringValue
        // Do any additional setup after loading the view.
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func configTableViews(){
        memoriaTableView.delegate = self
        memoriaTableView.dataSource = self
        fileInstructions.delegate = self
        fileInstructions.dataSource = self
    }
    func getValueFromResponse(response: String)->String{
        var resultado = ""
       do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(nullxScriptResponse.self, from: Data(response.utf8))
            resultado = response.valor;
        } catch let error {
            print(error.localizedDescription)
            print(response)
            
        }
        return resultado;
    }
    func getAliasRFromResponse(response: String)->String{
        var resultado = ""
       do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(nullxScriptResponse.self, from: Data(response.utf8))
            resultado = response.valor;
        } catch let error {
            print(error.localizedDescription)
            print(response)
            
        }
        return resultado;
    }
    func inputValid(text: String) -> Bool{
        let hex = UInt(text, radix: 16) ?? nil
        if (hex != nil){
            return true
        }else{
            return false
        }
    }
    func checkHex(text: String, format: Bool, leading: Int) -> Any{
        let num = UInt(text, radix: 16) ?? nil
        if (num != nil){
            if (format){
                return intToHex(num: Int(num!), leading: leading)
            }else{
                return true
            }
        }else{
            return false
        }
    }
    
    func setupAllRegistros(){
        reg0.stringValue = "\(getValueFromResponse(response: String(cString: getR(0))))";
        reg0.tag = 0;
        reg1.stringValue = "\(getValueFromResponse(response: String(cString: getR(1))))";
        reg1.tag = 1;
        reg2.stringValue = "\(getValueFromResponse(response: String(cString: getR(2))))";
        reg2.tag = 2;
        reg3.stringValue = "\(getValueFromResponse(response: String(cString: getR(3))))";
        reg3.tag = 3;
        reg4.stringValue = "\(getValueFromResponse(response: String(cString: getR(4))))";
        reg4.tag = 4;
        reg5.stringValue = "\(getValueFromResponse(response: String(cString: getR(5))))";
        reg5.tag = 5;
        reg6.stringValue = "\(getValueFromResponse(response: String(cString: getR(6))))";
        reg6.tag = 6;
        reg7.stringValue = "\(getValueFromResponse(response: String(cString: getR(7))))";
        reg7.tag = 7;
        reg8.stringValue = "\(getValueFromResponse(response: String(cString: getR(8))))";
        reg8.tag = 8;
        reg9.stringValue = "\(getValueFromResponse(response: String(cString: getR(9))))";
        reg9.tag = 9;
        regA.stringValue = "\(getValueFromResponse(response: String(cString: getR(10))))";
        regA.tag = 10;
        regB.stringValue = "\(getValueFromResponse(response: String(cString: getR(11))))";
        regB.tag = 11;
        regC.stringValue = "\(getValueFromResponse(response: String(cString: getR(12))))";
        regC.tag = 12;
        regD.stringValue = "\(getValueFromResponse(response: String(cString: getR(13))))";
        regD.tag = 13;
        regE.stringValue = "\(getValueFromResponse(response: String(cString: getR(14))))";
        regE.tag = 14;
        regF.stringValue = "\(getValueFromResponse(response: String(cString: getR(15))))";
        regF.tag = 15;
        
        AdressRegister.stringValue = "\(getValueFromResponse(response: String(cString: getR(16))))";
        AdressRegister.tag = 16;
        dataRegister.stringValue = "\(getValueFromResponse(response: String(cString: getR(17))))";
        dataRegister.tag = 17;
        instructionRegister.stringValue = "\(getValueFromResponse(response: String(cString: getR(18))))";
        instructionRegister.tag = 18;
        programCounter.stringValue = "\(getValueFromResponse(response: String(cString: getR(19))))";
        programCounter.tag = 19;
        tecladoIp1.stringValue = "\(getValueFromResponse(response: String(cString: getR(20))))";
        tecladoIp1.tag = 20;
        PDireccionOP1.stringValue = "\(getValueFromResponse(response: String(cString: getR(21))))";
        PDireccionOP1.tag = 21;
        PDireccionOP2.stringValue = "\(getValueFromResponse(response: String(cString: getR(22))))";
        PDireccionOP2.tag = 22;
        PDireccionIP1.stringValue = "\(getValueFromResponse(response: String(cString: getR(23))))";
        PDireccionIP1.tag = 23;
        PDireccionIP2.stringValue = "\(getValueFromResponse(response: String(cString: getR(24))))";
        PDireccionIP2.tag = 24;
        PDireccionOP1.stringValue = "\(getValueFromResponse(response: String(cString: getR(25))))";
        PDireccionOP1.tag = 25;
        PDireccionOP2.stringValue = "\(getValueFromResponse(response: String(cString: getR(26))))";
        PDireccionOP2.tag = 26;
    }
    func setProgramarRegistro(new: String){
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        
        self.registro += dateString + ": " + new + "\n"
        registroPrograma.string = self.registro
        let smartScroll = self.registroPrograma.visibleRect.maxY == self.registroPrograma.bounds.maxY

        if smartScroll{
            self.registroPrograma.scrollToEndOfDocument(self)
        }
    }
    func startAnimating(_ animating: Bool){
        if (animating){
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimation(self)
        }else{
            self.loadingIndicator.stopAnimation(self)
            self.loadingIndicator.isHidden = true
        }
    }
    func isDirectionInUserCode(direction: String) -> Int {
        var result = -1;
        let direccionesUsuario = getDireccionesM(from: sourceCodeExecuted);
        let indexUsuario = direccionesUsuario.firstIndex(of: direction); // buscar en las direcciones del usuario
        if (indexUsuario != nil){
            // ejecutar codigo usuario
            result = indexUsuario!;
            
        }else{
            // ejecutar codigo memoria
            result = -1;
        }
        return result;
    }
    func executeUserCode(indexUserCode: Int, continuar: Bool){
        setProgramarRegistro(new: "Debug-> User code")
        let index: IndexSet = [indexUserCode]
        self.fileInstructions.selectRowIndexes(index, byExtendingSelection: false)
       // self.fileInstructions.scrollRowToVisible(self.fileInstructions.selectedRow)
        let programCounter = sourceCodeExecuted[self.fileInstructions.selectedRow].components(separatedBy: "[")[1].components(separatedBy: "]")[0]

        let nem = sourceCodeExecuted[self.fileInstructions.selectedRow].components(separatedBy: ": ")[1].components(separatedBy: " ")[0]
         var op1 = ""
         var op2 = ""
         var op3 = ""
          if (nem == "ADDS" || nem == "SUBS" || nem == "NAND"){
              // 3 REGISTROS
              op1 = sourceCodeExecuted[self.fileInstructions.selectedRow].components(separatedBy: ", ")[0].components(separatedBy: " ")[2]
              op2 = sourceCodeExecuted[self.fileInstructions.selectedRow].components(separatedBy: ", ")[1]
              op3 = sourceCodeExecuted[self.fileInstructions.selectedRow].components(separatedBy: ", ")[2]
             print(programCounter, nem, op1, op2, op3)
             ejecutarInstruccion(PC: programCounter, nem: nem, op1: op1, op2: op2, op3: op3, continuar: continuar)
             setProgramarRegistro(new: "Ejecutado \(nem) \(op1) \(op2) \(op3) <--- instrucción \(programCounter)")

          }else{
              // 2 REGISTROS
             let op1 = sourceCodeExecuted[self.fileInstructions.selectedRow].components(separatedBy: ", ")[0].components(separatedBy: " ")[2]
             let op2 = sourceCodeExecuted[self.fileInstructions.selectedRow].components(separatedBy: ", ")[1]
             print(programCounter, nem, op1, op2, op3)
             ejecutarInstruccion(PC: programCounter, nem: nem, op1: op1, op2: op2, op3: op3, continuar: continuar)
             setProgramarRegistro(new: "Ejecutado \(nem) \(op1) \(op2) \(op3) <--- instrucción \(programCounter)")

          }
    }
    func executeMemoryCode(continuar: Bool, valorMemoria: String){
        //let valorMemoria = getValueFromResponse(response: String(cString: getR(Int32(19))))
        let pos = search(something: valorMemoria, ina: listaPosiciones)
        if (pos == -1){
            alert(title: "Error", msg: "La dirección de memoria no existe en CODE-2")
            return
        }
        let valorMemoria_1 = memoryHex[pos]
        
        let nemINDec = Int(String(valorMemoria_1[0]), radix: 16)!
        var nem = instruccionesHex[nemINDec]
        var op1 = ""
        var op2 = ""
        var op3 = ""
        if (nem == "ADDS" || nem == "SUBS" || nem == "NAND"){
            // vale para ads subs nand shl shr shra
            op1 = "r" + String(valorMemoria_1[1])
            op2 = "r" + String(valorMemoria_1[2])
            op3 = "r" + String(valorMemoria_1[3])
        }else if (nem == "LD"){
            op1 = "r" + String(valorMemoria_1[1])
            op2 = "[" + restCeros(text: String(valorMemoria_1[2]), numOfCeros: 2, biestableV: self.biestableV, biestableC: self.biestableC) + "]"
        }else if (nem == "ST"){
            op2 = "r" + String(valorMemoria_1[2])
            op1 = "[" + restCeros(text: String(valorMemoria_1[1]), numOfCeros: 2, biestableV: self.biestableV, biestableC: self.biestableC) + "]"
        }else if (nem == "LLI" || nem == "LHI"){
            op1 = "r" + String(valorMemoria_1[1])
            op2 = "H'" + restCeros(text: String(valorMemoria_1[2]) + String(valorMemoria_1[3]), numOfCeros: 2, biestableV: self.biestableV, biestableC: self.biestableC)
        }else if (nem == "IN"){
            op1 = "r" + String(valorMemoria_1[1])
            op2 = "IP" + String(valorMemoria_1[2])
        }else if (nem == "OUT"){
            op1 = "r" + String(valorMemoria_1[1])
            op2 = "OP" + String(valorMemoria_1[2])
        }else if (nem == "SHL"){
            op1 = "r" + String(valorMemoria_1[1])
        }else if (nem == "SHR"){
            op1 = "r" + String(valorMemoria_1[1])
        }else if (nem == "SHRA"){
            op1 = "r" + String(valorMemoria_1[1])
        }else if (nem.contains("B")){
            nem = nem.replacingOccurrences(of: "-", with: String(valorMemoria_1[1]))
        }else if (nem.contains("CALL")){
            nem = nem.replacingOccurrences(of: "-", with: String(valorMemoria_1[1]))
            
        }else if (nem.contains("RET")){
            
        }else if (nem.contains("HALT")){
            
        }
        
        ejecutarInstruccion(PC: getValueFromResponse(response: String(cString: getR(20))), nem: nem, op1: op1, op2: op2, op3: op3, continuar: continuar)
        setProgramarRegistro(new: "Ejecutado \(nem) \(op1) \(op2) \(op3) mem(\(valorMemoria))")
        
    }
    func ejecutarInstruccion(PC: String, nem: String, op1: String, op2: String, op3: String, continuar: Bool){
        faseCaptacion(PC: PC, continuar: continuar)
        faseEjecucion(nem: nem, op1: op1, op2: op2, op3: op3)
    }
    func faseCaptacion(PC: String, continuar: Bool){
        // pasar el PC al AR
            //setteo el PC al valor del script
        PC.withCString { s1 in
            let parsed = UnsafeMutablePointer<Int8>(mutating: (PC as NSString).utf8String)
            setR(19, parsed)
            setupAllRegistros()
        }
            //paso el valor del programCounter al AR
        programCounter.stringValue.withCString { s1 in
            let parsed = UnsafeMutablePointer<Int8>(mutating: (programCounter.stringValue as NSString).utf8String)
            setR(16, parsed)
            setupAllRegistros()
        }
        // coger de memoria AR y guardarlo en DR
            // buscar en la posicion del AR
            let pos = search(something: AdressRegister.stringValue, ina: listaPosiciones)
            if (pos == -1){
                alert(title: "Error", msg: "La dirección de memoria no existe en CODE-2")
                return
            }
            let valorMemoria = memoryHex[pos]
            //guardar el valor (en esa posicion de memoria) y guardarlo en DR
            valorMemoria.withCString { s1 in
                let parsed = UnsafeMutablePointer<Int8>(mutating: (valorMemoria as NSString).utf8String)
                setR(17, parsed)
                setupAllRegistros()
            }
        
        // pasar DR A IR
        dataRegister.stringValue.withCString { s1 in
            let parsed = UnsafeMutablePointer<Int8>(mutating: (dataRegister.stringValue as NSString).utf8String)
            setR(18, parsed)
            setupAllRegistros()
        }
        if (continuar == true){ // si paso a paso encendido, solo se aumenta en 1 cuando se presiona sobre continuar
            let nextProgramCounter = sumar1Hex(hex: tempLastCounter)
            
            nextProgramCounter.withCString { s1 in
                let parsed = UnsafeMutablePointer<Int8>(mutating: (nextProgramCounter as NSString).utf8String)
                setR(19, parsed)
                setR(16, parsed)
                setupAllRegistros()
            }

            tempLastCounter = nextProgramCounter
        }else{
            let nextProgramCounter = sumar1Hex(hex: getValueFromResponse(response: String(cString: getR(20))))
            
            nextProgramCounter.withCString { s1 in
                let parsed = UnsafeMutablePointer<Int8>(mutating: (nextProgramCounter as NSString).utf8String)
                setR(19, parsed)
                setupAllRegistros()
            }
            // en la practica hay que usar esto
            let nextAddressRegister = nextProgramCounter
            nextAddressRegister.withCString { s1 in
                let parsed = UnsafeMutablePointer<Int8>(mutating: (nextAddressRegister as NSString).utf8String)
                setR(16, parsed)
                setupAllRegistros()
            }
            tempLastCounter = nextProgramCounter
        }
        // aumentar el PC en 1
        
    }
    func faseEjecucion(nem: String, op1: String, op2: String, op3: String){
            //OPERADORES NECESARIOS MAX 3 EN  ADDS, SUBS y NAND
            if (nem == "LD"){
                resetBiestables()
                //cargar
                //registro destino op1
                //v es op2
                let v = op2.replacingOccurrences(of: "[H'", with: "").replacingOccurrences(of: "]", with: "")
                let posicionMemoriaABuscar = sumarFromHex(sum1: getRegistro(registro: "rD"), sum2: v)
                let indexOfMemoria = search(something: posicionMemoriaABuscar, ina: listaPosiciones)
                if (indexOfMemoria == -1){
                    alert(title: "Error", msg: "La dirección de memoria no existe en CODE-2")
                    return
                }
                let valorMemoria = memoryHex[indexOfMemoria]
                setRegistro(registro: op1, value: valorMemoria)
                
            }else if (nem == "ST"){
                resetBiestables()
                //almacenar
                let v = op1.replacingOccurrences(of: "[H'", with: "").replacingOccurrences(of: "]", with: "")
                let posicionMemoriaABuscar = sumarFromHex(sum1: getRegistro(registro: "rD"), sum2: v)
                let indexOfMemoria = search(something: posicionMemoriaABuscar, ina: listaPosiciones)
                if (indexOfMemoria == -1){
                    alert(title: "Error", msg: "La dirección de memoria no existe en CODE-2")
                    return
                }
                memoryHex[indexOfMemoria] = getRegistro(registro: op2)
                listaMemoriavalores[indexOfMemoria] = hexStringtoAscii(hexString: getRegistro(registro: op2))
                // falta meterlo con setMem
                memoriaTableView.reloadData()
            }else if (nem == "LLI"){
                resetBiestables()
                //carga inmediata baja
                //op1 registro donde guardar
                //op2 valor que hay que guardar en el registro declarado en op1
    /*
                let valorDelRegistro = getRegistro(registro: op1) //coger valor del registro
                let hexASumar = op2.replacingOccurrences(of: "H'", with: "")
                let resultado = sumarFromHex(sum1: valorDelRegistro, sum2: hexASumar)
                setRegistro(registro: op1, value: resultado)
                controlBiestables(val: resultado)
    */
                let hexASumar = op2.replacingOccurrences(of: "H'", with: "")
                let hexASumarC = checkHex(text: hexASumar, format: true, leading: 2) as! String
                let antes = "00"
                let despues = hexASumarC
                let resultado = antes + despues
                
                setRegistro(registro: op1, value: String(resultado))
            }else if (nem == "LHI"){
                resetBiestables()
                //carga inmediata alta
                let valorDelRegistro = getRegistro(registro: op1) //coger valor del registro
                let hexASumar = op2.replacingOccurrences(of: "H'", with: "")
                let hexASumarC = checkHex(text: hexASumar, format: true, leading: 2) as! String
                let antes = valorDelRegistro.suffix(2)
                let despues = hexASumarC
                let resultado = despues + antes
                setRegistro(registro: op1, value: String(resultado))
                
            }else if (nem == "IN"){
                resetBiestables()
                // entrada
                //OP1 registro destino
                //op2 posicion del Pinput
                
                let n = op2.replacingOccurrences(of: "IP", with: "")
                if (Int(n) ?? 65 > 64){
                    alert(title: "Error", msg: "Code-2 soporta los 64 primeros puertos de entrada.")
                    return
                }
                if (n == "1"){
                    setRegistro(registro: op1, value: PDireccionIP1.stringValue)
                }else if (n == "2"){
                    setRegistro(registro: op1, value: PDireccionIP2.stringValue)
                }
            }else if (nem == "OUT"){
                resetBiestables()
                //salida
                //OP1 registro destino
                //op2 posicion del Pinput
                let n = op1.replacingOccurrences(of: "OP", with: "")
                if (n == "01"){
                    direccionOP1.stringValue = getRegistro(registro: op2)
                    PDireccionOP1.stringValue = getRegistro(registro: op2)
                }else if (n == "02"){
                    direccionOP2.stringValue = getRegistro(registro: op2)
                    PDireccionOP2.stringValue = getRegistro(registro: op2)
                }
            }else if (nem == "ADDS"){
                resetBiestables()
                //suma
                // registro destino es op1
                // sum1 es op2
                // sum2 es op3
                let resultado = sumarFromHex(sum1: getRegistro(registro: op2), sum2: getRegistro(registro: op3))
                setRegistro(registro: op1, value: resultado)
                controlBiestables(val: resultado, acarreo: "")
                
            }else if (nem == "SUBS"){
                resetBiestables()
                //resta
                let resultado = restarFromHex(r1: getRegistro(registro: op2),r2: getRegistro(registro: op3))
                setRegistro(registro: op1, value: resultado)
                controlBiestables(val: resultado, acarreo: "")
                
            }else if (nem == "NAND"){
                resetBiestables()
                // NNAND
                let op1_0 = getRegistro(registro: op2)
                let op2_0 = getRegistro(registro: op3)
                let op1_1 = op1_0.hexaToBinary
                let op2_1 = op2_0.hexaToBinary
                let op1_2 = restCeros(text: op1_1, numOfCeros: 16, biestableV: self.biestableV, biestableC: self.biestableC)
                let op2_2 = restCeros(text: op2_1, numOfCeros: 16, biestableV: self.biestableV, biestableC: self.biestableC)

                //op1 donde se guarda el resultado
                var res = ""
                for (index, x) in op1_2.enumerated(){
                    if (x == op2_2[index] && x == "0"){
                        res += "1"
                    }else if (x == op2_2[index] && x == "1"){
                        res += "0"
                    }else if (x != op2_2[index]){
                        res += "1"
                    }
            
                
                }
                let value = checkHex(text: binToHex(bin: res), format: true, leading: 4) as! String
                setRegistro(registro: op1, value: value)
                controlBiestables(val: value, acarreo: "")
            }else if (nem == "SHL"){
                resetBiestables()
                //DESPLAZA IZQ
                //se desplaza hacia la izq el op1
                var opABin = getRegistro(registro: op1).hexaToBinary
                opABin.remove(at: opABin.firstIndex(of: opABin[0])!)
                let meterCero = String(opABin) + "0"
               // let restoCeros = restCeros(text: meterCero, numOfCeros: 16)
                let finalHex = binToHex(bin: meterCero)
                let finalHexC = restCeros(text: finalHex, numOfCeros: 4, biestableV: self.biestableV ,biestableC: self.biestableC)
                let acarreo = finalHexC[0] // para el acarreo luego -- sin settear
                // biestableC.state = .on // siempre hya acarreo
                
                setRegistro(registro: op1, value: finalHexC)
                controlBiestables(val: finalHexC, acarreo: String(acarreo))
            }else if (nem == "SHR"){
                resetBiestables()
                // DESPLAZA DERECHA
                //se desplaza hacia la der el op1
                var opABin = getRegistro(registro: op1).hexaToBinary
                opABin.remove(at: opABin.lastIndex(of: opABin.last!)!)
                let meterCero = "0" + String(opABin)
               // let restoCeros = restCeros(text: meterCero, numOfCeros: 16)
                let finalHex = binToHex(bin: meterCero)
                let finalHexC = restCeros(text: finalHex, numOfCeros: 4, biestableV: self.biestableV, biestableC: self.biestableC)
                let acarreo = opABin.last! // para el acarreo luego -- sin settear
                // biestableC.state = .on // siempre hya acarreo
                
                setRegistro(registro: op1, value: finalHexC)
                controlBiestables(val: finalHexC, acarreo: String(acarreo))
            }else if (nem == "SHRA"){
                resetBiestables()
                // DESPLAZA ARIT. DERECHA
                
                var opABin = getRegistro(registro: op1).hexaToBinary
                let primero = opABin[0]
                opABin.remove(at: opABin.lastIndex(of: opABin.last!)!)
                let meterCero = String(primero) + String(opABin)
               // let restoCeros = restCeros(text: meterCero, numOfCeros: 16)
                let finalHex = binToHex(bin: meterCero)
                let finalHexC = restCeros(text: finalHex, numOfCeros: 4, biestableV: self.biestableV, biestableC: self.biestableC)
                let acarreo = opABin.last! // para el acarreo luego -- sin settear
                // biestableC.state = .on // siempre hya acarreo
                
                setRegistro(registro: op1, value: finalHexC)
                controlBiestables(val: finalHexC, acarreo: String(acarreo))
            }else if (nem.contains("B")){
                // no ignorar bidestables
                let bi = getBiActivated(biestableV: self.biestableV, biestableC: self.biestableC, biestableS: self.biestableS, biestableZ: self.biestableZ)
                let op1_1 = nem.components(separatedBy: "B")[1]
                if (op1_1 == "R"){
                    // no se resetean los biestables (CREO)
                    // SALTO INCONDICIONAL
                    //SALTAR
                    let rD = getRegistro(registro: "rD")
                    rD.withCString { s1 in
                    let parsed = UnsafeMutablePointer<Int8>(mutating: (rD as NSString).utf8String)
                        setR(19, parsed)
                    }
                }else if (op1_1 == "Z"){
                    // SALTO SI ES CERO
                    if (bi.contains("Z")){// COMPROBAR SI BI Z ACTIVADO
                        // no se resetean los biestables (CREO)
                        //ACTIVADO
                        //SALTAR
                        let rD = getRegistro(registro: "rD")
                        rD.withCString { s1 in
                        let parsed = UnsafeMutablePointer<Int8>(mutating: (rD as NSString).utf8String)
                            setR(19, parsed)
                        }
                    }
                }else if (op1_1 == "S"){
                    // SALTO SI ES NEGATIVO
                    if (bi.contains("S")){// COMPROBAR SI BI S ACTIVADO
                        // no se resetean los biestables (CREO)
                        //ACTIVADO
                        //SALTAR
                        let rD = getRegistro(registro: "rD")
                        rD.withCString { s1 in
                        let parsed = UnsafeMutablePointer<Int8>(mutating: (rD as NSString).utf8String)
                            setR(19, parsed)
                        }
                    }
                }else if (op1_1 == "V"){
                    // SALTO SI ES OVERFLOW
                    if (bi.contains("V")){// COMPROBAR SI BI V ACTIVADO
                        // no se resetean los biestables (CREO)
                        //ACTIVADO
                        //SALTAR
                        let rD = getRegistro(registro: "rD")
                        rD.withCString { s1 in
                        let parsed = UnsafeMutablePointer<Int8>(mutating: (rD as NSString).utf8String)
                            setR(19, parsed)
                        }
                    }
                }else if (op1_1 == "C"){
                    // SALTO SI HAY ACARREO
                    if (bi.contains("C")){// COMPROBAR SI BI C ACTIVADO
                        // no se resetean los biestables (CREO)
                        //ACTIVADO
                        //SALTAR
                        let rD = getRegistro(registro: "rD")
                        rD.withCString { s1 in
                        let parsed = UnsafeMutablePointer<Int8>(mutating: (rD as NSString).utf8String)
                            setR(19, parsed)
                        }
                    }
                }
                // SALTO
            }else if (nem.contains("CALL")){
                // SUBRUTINA
                let bi = getBiActivated(biestableV: self.biestableV, biestableC: self.biestableC, biestableS: self.biestableS, biestableZ: self.biestableZ)
                  let op1_1 = nem.components(separatedBy: "CALL")[1]
                  if (op1_1 == "R"){
                      // no se resetean los biestables (CREO)
                      // SALTO INCONDICIONAL
                      //SALTAR
                      insertMemoriaPila(programCounter.stringValue) // PC -> PILA
                      let rD = getRegistro(registro: "rD")
                      rD.withCString { s1 in
                      let parsed = UnsafeMutablePointer<Int8>(mutating: (rD as NSString).utf8String)
                          setR(19, parsed)
                      }
                  }else if (op1_1 == "Z"){
                      // SALTO SI ES CERO
                      if (bi.contains("Z")){// COMPROBAR SI BI Z ACTIVADO
                          // no se resetean los biestables (CREO)
                          //ACTIVADO
                          //SALTAR
                          insertMemoriaPila(programCounter.stringValue) // PC -> PILA
                          let rD = getRegistro(registro: "rD")
                          rD.withCString { s1 in
                          let parsed = UnsafeMutablePointer<Int8>(mutating: (rD as NSString).utf8String)
                              setR(19, parsed)
                          }
                        
                    }
                  }else if (op1_1 == "S"){
                      // SALTO SI ES NEGATIVO
                      if (bi.contains("S")){// COMPROBAR SI BI S ACTIVADO
                          // no se resetean los biestables (CREO)
                          //ACTIVADO
                          //SALTAR
                          insertMemoriaPila(programCounter.stringValue) // PC -> PILA
                          let rD = getRegistro(registro: "rD")
                          rD.withCString { s1 in
                          let parsed = UnsafeMutablePointer<Int8>(mutating: (rD as NSString).utf8String)
                              setR(19, parsed)
                          }
                        
                    }
                  }else if (op1_1 == "V"){
                      // SALTO SI ES OVERFLOW
                      if (bi.contains("V")){// COMPROBAR SI BI V ACTIVADO
                          // no se resetean los biestables (CREO)
                          //ACTIVADO
                          //SALTAR
                          insertMemoriaPila(programCounter.stringValue) // PC -> PILA
                          let rD = getRegistro(registro: "rD")
                          rD.withCString { s1 in
                          let parsed = UnsafeMutablePointer<Int8>(mutating: (rD as NSString).utf8String)
                              setR(19, parsed)
                          }
                        
                    }
                  }else if (op1_1 == "C"){
                      // SALTO SI HAY ACARREO
                      if (bi.contains("C")){// COMPROBAR SI BI C ACTIVADO
                          // no se resetean los biestables (CREO)
                          //ACTIVADO
                          //SALTAR
                          insertMemoriaPila(programCounter.stringValue) // PC -> PILA
                          let rD = getRegistro(registro: "rD")
                          rD.withCString { s1 in
                          let parsed = UnsafeMutablePointer<Int8>(mutating: (rD as NSString).utf8String)
                              setR(19, parsed)
                          }
                        
                    }
                  }

            }else if (nem.contains("RET")){
                //RETORNO
                let lastMPila = getLastMemoriaPila()
                lastMPila.withCString { s1 in
                let parsed = UnsafeMutablePointer<Int8>(mutating: (lastMPila as NSString).utf8String)
                    setR(19, parsed)
                }
            }else if (nem == "HALT"){
                //PARAR
                alert(title: "Info", msg: "Fin de la ejecución.")
                
                return
            }
            
        }
    func controlBiestables(val: String, acarreo: String){ // revisar esta funcion!!!
        let conv = UInt(val, radix: 16) ?? 999
        if (conv == 0){
            biestableZ.state = .on
        }
        if (acarreo.count > 0){
            biestableC.state = .on
        }
    }
    func setRegistro(registro: String, value: String){
        let registroCh = registro.lowercased()
        value.withCString { s1 in
            let parsed = UnsafeMutablePointer<Int8>(mutating: (value as NSString).utf8String)
            if (registroCh == "r0"){
                setR(0, parsed)
            }else if (registroCh == "r1"){
                setR(1, parsed)
            }else if (registroCh == "r2"){
                setR(2, parsed)
            }else if (registroCh == "r3"){
                setR(3, parsed)
            }else if (registroCh == "r4"){
                setR(4, parsed)
            }else if (registroCh == "r5"){
                setR(5, parsed)
            }else if (registroCh == "r6"){
                setR(6, parsed)
            }else if (registroCh == "r7"){
                setR(7, parsed)
            }else if (registroCh == "r8"){
                setR(8, parsed)
            }else if (registroCh == "r9"){
                setR(9, parsed)
            }else if (registroCh == "ra"){
                setR(10, parsed)
            }else if (registroCh == "rb"){
                setR(11, parsed)
            }else if (registroCh == "rc"){
                setR(12, parsed)
            }else if (registroCh == "rd"){
                setR(13, parsed)
            }else if (registroCh == "re"){
                setR(14, parsed)
            }else if (registroCh == "rf"){
                setR(15, parsed)
            }
            setupAllRegistros()
        }
    }
    func getRegistro(registro: String)->String{
        let registroCh = registro.lowercased()
        var toReturn = ""
        let registros = [
            "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", "r8", "r9", "ra", "rb", "rc", "rd", "re", "rf"
        ]
        let index = registros.firstIndex(of: registroCh)
        if (index != nil){
            toReturn = getValueFromResponse(response: String(cString: getR(Int32(index!))))
        }
        return toReturn
    }
    func resetBiestables(){
        biestableC.state = .off
        biestableS.state = .off
        biestableZ.state = .off
        biestableV.state = .off
    }
    func verNumeros(bool: Bool){
        if (bool == true){
            instructionRegister.textColor = NSColor.green
            programCounter.textColor = NSColor.green
            tecladoIp1.textColor = NSColor.green
            direccionOP1.textColor = NSColor.green
            direccionOP2.textColor = NSColor.green
            AdressRegister.textColor = NSColor.green
            dataRegister.textColor = NSColor.green
            reg0.textColor = NSColor.green
            reg1.textColor = NSColor.green
            reg2.textColor = NSColor.green
            reg3.textColor = NSColor.green
            reg4.textColor = NSColor.green
            reg5.textColor = NSColor.green
            reg6.textColor = NSColor.green
            reg7.textColor = NSColor.green
            reg8.textColor = NSColor.green
            reg9.textColor = NSColor.green
            regA.textColor = NSColor.green
            regB.textColor = NSColor.green
            regC.textColor = NSColor.green
            regD.textColor = NSColor.green
            regE.textColor = NSColor.green
            regF.textColor = NSColor.green
            PDireccionIP1.textColor = NSColor.green
            PDireccionIP2.textColor = NSColor.green
            PDireccionOP1.textColor = NSColor.green
            PDireccionOP2.textColor = NSColor.green
            
            instructionRegister.isEnabled = true
            programCounter.isEnabled = true
            tecladoIp1.isEnabled = true
            inputTeclado.isEnabled = true
            direccionOP1.isEnabled = true
            direccionOP2.isEnabled = true
            AdressRegister.isEnabled = true
            dataRegister.isEnabled = true
            reg0.isEnabled = true
            reg1.isEnabled = true
            reg2.isEnabled = true
            reg3.isEnabled = true
            reg4.isEnabled = true
            reg5.isEnabled = true
            reg6.isEnabled = true
            reg7.isEnabled = true
            reg8.isEnabled = true
            reg9.isEnabled = true
            regA.isEnabled = true
            regB.isEnabled = true
            regC.isEnabled = true
            regD.isEnabled = true
            regE.isEnabled = true
            regF.isEnabled = true
            PDireccionIP1.isEnabled = true
            PDireccionIP2.isEnabled = true
            PDireccionOP1.isEnabled = true
            PDireccionOP2.isEnabled = true
            direccionBIO.isEnabled = true
            registrosBIO.isEnabled = true
            cargarBIO.isEnabled = true
            ejecutarBIO.isEnabled = true
            continuarBIO.isEnabled = true
            indicadorEncendido.state = .on
            setProgramarRegistro(new: "code200: Encendido")
        }else{
            instructionRegister.textColor = NSColor.black
            programCounter.textColor = NSColor.black
            tecladoIp1.textColor = NSColor.black
            direccionOP1.textColor = NSColor.black
            direccionOP2.textColor = NSColor.black
            AdressRegister.textColor = NSColor.black
            dataRegister.textColor = NSColor.black
            reg0.textColor = NSColor.black
            reg1.textColor = NSColor.black
            reg2.textColor = NSColor.black
            reg3.textColor = NSColor.black
            reg4.textColor = NSColor.black
            reg5.textColor = NSColor.black
            reg6.textColor = NSColor.black
            reg7.textColor = NSColor.black
            reg8.textColor = NSColor.black
            reg9.textColor = NSColor.black
            regA.textColor = NSColor.black
            regB.textColor = NSColor.black
            regC.textColor = NSColor.black
            regD.textColor = NSColor.black
            regE.textColor = NSColor.black
            regF.textColor = NSColor.black
            PDireccionIP1.textColor = NSColor.black
            PDireccionIP2.textColor = NSColor.black
            PDireccionOP1.textColor = NSColor.black
            PDireccionOP2.textColor = NSColor.black
            
            instructionRegister.isEnabled = false
            programCounter.isEnabled = false
            tecladoIp1.isEnabled = false
            inputTeclado.isEnabled = true
            direccionOP1.isEnabled = false
            direccionOP2.isEnabled = false
            AdressRegister.isEnabled = false
            dataRegister.isEnabled = false
            reg0.isEnabled = false
            reg1.isEnabled = false
            reg2.isEnabled = false
            reg3.isEnabled = false
            reg4.isEnabled = false
            reg5.isEnabled = false
            reg6.isEnabled = false
            reg7.isEnabled = false
            reg8.isEnabled = false
            reg9.isEnabled = false
            regA.isEnabled = false
            regB.isEnabled = false
            regC.isEnabled = false
            regD.isEnabled = false
            regE.isEnabled = false
            regF.isEnabled = false
            PDireccionIP1.isEnabled = false
            PDireccionIP2.isEnabled = false
            PDireccionOP1.isEnabled = false
            PDireccionOP2.isEnabled = false
            direccionBIO.isEnabled = false
            registrosBIO.isEnabled = false
            cargarBIO.isEnabled = false
            ejecutarBIO.isEnabled = false
            continuarBIO.isEnabled = false
            direccionBIO.isEnabled = false
            registrosBIO.isEnabled = false
            cargarBIO.isEnabled = false
            ejecutarBIO.isEnabled = false
            indicadorEncendido.state = .off
            setProgramarRegistro(new: "code200: Apagado");
        }
    }
    // --------
    @IBOutlet weak var buttonOn: NSButton!
    @IBOutlet weak var buttonStepByStep: NSButton!
    @IBOutlet weak var indicadorEncendido: NSButton!
    @IBOutlet weak var indicadorPasoAPaso: NSButton!
        
    @IBOutlet weak var direccionBIO: NSButton!
    @IBOutlet weak var registrosBIO: NSButton!
    @IBOutlet weak var cargarBIO: NSButton!
    @IBOutlet weak var ejecutarBIO: NSButton!
    @IBOutlet weak var continuarBIO: NSButton!
        
    @IBOutlet weak var memoriaTableView: NSTableView!
        
    @IBOutlet weak var biestableZ: NSButton!
    @IBOutlet weak var indicadorBiestableZ: NSButton!
    @IBOutlet weak var biestableS: NSButton!
    @IBOutlet weak var indicadorBiestableS: NSButton!
    @IBOutlet weak var biestableC: NSButton!
    @IBOutlet weak var indicadorBiestableC: NSButton!
    @IBOutlet weak var biestableV: NSButton!
    @IBOutlet weak var indicadorBiestableV: NSButton!
        
    @IBOutlet weak var instructionRegister: NSTextField!
    @IBOutlet weak var programCounter: NSTextField!
    @IBOutlet weak var tecladoIp1: NSTextField!
    @IBOutlet weak var inputTeclado: NSTextField!
    @IBOutlet weak var direccionOP1: NSTextField!
    @IBOutlet weak var direccionOP2: NSTextField!
    @IBOutlet weak var PDireccionIP1: NSTextField!
    @IBOutlet weak var PDireccionIP2: NSTextField!
    @IBOutlet weak var PDireccionOP1: NSTextField!
    @IBOutlet weak var PDireccionOP2: NSTextField!
    @IBOutlet weak var AdressRegister: NSTextField!
        
    @IBOutlet weak var fileInstructions: NSTableView!
        
    @IBOutlet weak var reg0: NSTextField!
    @IBOutlet weak var reg1: NSTextField!
    @IBOutlet weak var reg2: NSTextField!
    @IBOutlet weak var reg3: NSTextField!
    @IBOutlet weak var reg4: NSTextField!
    @IBOutlet weak var reg5: NSTextField!
    @IBOutlet weak var reg6: NSTextField!
    @IBOutlet weak var reg7: NSTextField!
    @IBOutlet weak var reg8: NSTextField!
    @IBOutlet weak var reg9: NSTextField!
    @IBOutlet weak var regA: NSTextField!
    @IBOutlet weak var regB: NSTextField!
    @IBOutlet weak var regC: NSTextField!
    @IBOutlet weak var regD: NSTextField!
    @IBOutlet weak var regE: NSTextField!
    @IBOutlet weak var regF: NSTextField!
    @IBOutlet var registroPrograma: NSTextView!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    @IBOutlet weak var themeSwitch: NSSwitch!
        
    @IBAction func borrarRegistroPrograma(_ sender: NSButton) {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
        self.registroPrograma.string = "CODE-2 v\(appVersion) nullx.me"
    }
    @IBAction func themeChange(_ sender: NSSwitch) {
        if (sender.state == .on){
            DispatchQueue.main.async {
                self.view.superview?.appearance = NSAppearance(named: .darkAqua)
            }
        }else{
            DispatchQueue.main.async{
                self.view.superview?.appearance = NSAppearance(named: .aqua)
            }
        }
    }
    @IBAction func botonDireccion(_ sender: NSButton) {

    }
    @IBOutlet weak var dataRegister: NSTextField!
    @IBAction func botonRegistros(_ sender: NSButton) {
            //se ponen todos los op1 y op2 en 0000

    }
    @IBAction func botonCargar(_ sender: NSButton) {
        let dialog = NSOpenPanel();
         
         dialog.title                   = "Choose a .txt, .ehc file";
         dialog.showsResizeIndicator    = true;
         dialog.showsHiddenFiles        = true;
         dialog.canChooseDirectories    = false;
         dialog.canCreateDirectories    = true;
         dialog.allowsMultipleSelection = false;
         dialog.allowedFileTypes        = ["ehc", "txt"];

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
             
             if (result != nil) {
                let path = result!.path
                let byLineBreak = splitByLineBreak(text: readFile(fromPath: path))
                sourceCodeExecuted = byLineBreak
                direccionesCodeSourceMemoria = getDireccionesM(from: sourceCodeExecuted)
                fileInstructions.reloadData()
                ejecutarBIO.isEnabled = true
                continuarBIO.isEnabled = true
                setProgramarRegistro(new: "code200: Archivo abierto")
             }
         } else {
             // User clicked on "Cancel"
             return
         }
        }
    @IBAction func botonPasoAPasoAccion(_ sender: NSButton) {
       }
    @IBAction func cambiarRegistro(_ sender: NSTextField){
        let registroNum = Int32(sender.tag);
        print(registroNum)
        if (inputValid(text: sender.stringValue) && sender.stringValue.count == 4){
            sender.stringValue.withCString { s1 in
                let parsed = UnsafeMutablePointer<Int8>(mutating: (sender.stringValue as NSString).utf8String)
                setR(registroNum, parsed)
                setupAllRegistros()
            }
        }else{
            alert(title: "Ups", msg: "Has introducido un valor no valido.")
        }
        
       }
    @IBAction func writeTeclado(_ sender: NSTextField) {
        if (inputValid(text: sender.stringValue) && sender.stringValue.count == 4){
            sender.stringValue.withCString { s1 in
                let parsed = UnsafeMutablePointer<Int8>(mutating: (sender.stringValue as NSString).utf8String)
                setR(20, parsed)
                setR(23, parsed)
                setupAllRegistros()
            }
        }else{
            alert(title: "Ups", msg: "Has introducido un valor no valido.")
        }
       }
    func buscarEnMemoriaParaInput2DesdeInput1(_1: String){
       }
    @IBAction func writePInput(_ sender: NSTextField) {
       }
    @IBAction func botonEjecutar(_ sender: NSButton) {
        let indexUserCode = isDirectionInUserCode(direction: getValueFromResponse(response: String(cString: getR(23))))
        if (indexUserCode != -1){
            // ejecutar codigo usuario
            executeUserCode(indexUserCode: indexUserCode, continuar: false)
        }else{
            // ejecutar codigo memoria
            executeMemoryCode(continuar: false, valorMemoria: tempLastCounter)
        }
    }
    @IBAction func botonContinuar(_ sender: NSButton) {
         
        let tempCounter = sumarFromHex(sum1: getValueFromResponse(response: String(cString: getR(23))), sum2: "0001")
        let indexUserCode = isDirectionInUserCode(direction: tempCounter)
               if (indexUserCode != -1){
                   // ejecutar codigo usuario
                   executeUserCode(indexUserCode: indexUserCode, continuar: true)
               }else{
                   // ejecutar codigo memoria
                   executeMemoryCode(continuar: true, valorMemoria: sumarFromHex(sum1: getValueFromResponse(response: String(cString: getR(19))), sum2: "0001"))
               }
        }
    @IBAction func botonEncenderAccion(_ sender: NSButton) {
        if (encendido){
           //apagar
            verNumeros(bool: false)
            deleteMemoryData()
            self.memoriaTableView.reloadData()
           // deleteInstructionsCode()
            self.fileInstructions.reloadData()
            self.encendido = false
        }else{
            //encender
            self.startAnimating(true)
            self.buttonOn.isEnabled = false
            setupAllRegistros()
            DispatchQueue.main.async{
                self.verNumeros(bool: true)
                //self.flistaPosiciones()
                //self.flistaMemoriavalores()
                //self.setNewValues()
                self.getMemoryHex()
                self.encendido = true
                self.startAnimating(false)
                self.buttonOn.isEnabled = true
            }
        }
    }

}
@available(OSX 10.15, *)
extension ViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell: NSTableCellView? = nil
        if (tableColumn!.identifier.rawValue == "posicionesCell"){
            cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "posicionesCell"), owner: nil) as? NSTableCellView)!
            cell?.textField!.stringValue = "H" +  listaPosiciones[row]
            
        }else if (tableColumn!.identifier.rawValue == "valhexCell"){
            cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "valhexCell"), owner: nil) as? NSTableCellView)!
            cell?.textField!.stringValue = memoryHex[row]
        }else if (tableColumn!.identifier.rawValue == "valCell"){
            cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "valCell"), owner: nil) as? NSTableCellView)!
            cell?.textField!.stringValue = listaMemoriavalores[row]
        }else if (tableColumn!.identifier.rawValue == "instrCell"){
            cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "instrCell"), owner: nil) as? NSTableCellView)!
            cell?.textField!.stringValue = 
                String(sourceCodeExecuted[row])
        }
        return cell

    }
    func flistaPosiciones(){
        var lista = [String]()
        for x in 0...61439{
            var hex = String(x, radix: 16, uppercase: true)
            if (hex.count < 4){
                let toAssign = 4 - hex.count
                let newString = String(repeating: "0", count: toAssign)
                hex = newString + hex
            }
            lista.append(hex)
        }
        listaPosiciones = lista
        memoriaTableView.reloadData()
    }
    func getMemoryHex(){
        flistaPosiciones()
        var lista = [String]()
        for i in 0...61439{
            lista.append(getValueFromResponse(response: String(cString: getMem(Int32(i)))))
        }
        memoryHex = lista
        memoriaTableView.reloadData()
        hexToAscii(lista: memoryHex)
        
    }
    func hexToAscii(lista: Array<String>){
        var lista2 = [String]()
        for hex in lista{
            lista2.append(hexStringtoAscii(hexString: hex))
        }
        listaMemoriavalores = lista2
        memoriaTableView.reloadData()
    }
    func deleteMemoryData(){
        memoryHex = []
        listaMemoriavalores = []
        listaPosiciones = []
    }



}
@available(OSX 10.15, *)
extension ViewController: NSTableViewDataSource {
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    var toReturn = 0
    if (tableView == memoriaTableView){
        toReturn = listaPosiciones.count

    }else if (tableView == fileInstructions){
        toReturn = sourceCodeExecuted.count

    }
    return toReturn
  }

}
