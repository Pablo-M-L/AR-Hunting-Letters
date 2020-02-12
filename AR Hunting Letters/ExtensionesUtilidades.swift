//
//  ExtensionesUtilidades.swift
//  AR Hunting Letters
//
//  Created by admin on 02/12/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

extension String{
    //para quitar diatrices (acentos.....)
    func toNoSmartQuotes() -> String {
    let userInput: String = self
    return userInput.folding(options: .diacriticInsensitive, locale: .current)
    }
}


func redondearConDecimales(numeroDecimales: Int, numeroFloat: Float) -> Float{
    var multiplicarPor: Float = 10.0
    if numeroDecimales < 1{
        return numeroFloat
    }
    else if numeroDecimales == 1{
        let numeroInt = Int(numeroFloat * multiplicarPor)
        let numeroRedondeado = Float(numeroInt) / multiplicarPor
        
        return numeroRedondeado
    }
    else{
        
        for _ in 1...(numeroDecimales - 1){
            multiplicarPor *= 10.0
        }
        
        let numeroInt = Int(numeroFloat * multiplicarPor)
        let numeroRedondeado = Float(numeroInt) / multiplicarPor
        
        return numeroRedondeado
    }
}
