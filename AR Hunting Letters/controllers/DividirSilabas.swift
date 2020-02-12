//
//  DividirSilabas.swift
//  AR Hunting Letters
//
//  Created by pablo millan lopez on 03/01/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit

let arrayVocales = ["A","E","I","O","U"]
let arrayGrupoDiptongo = ["IA","IE","IO","UE","UO","AU","AI","EU","EI"]
let arrayGrupoConsonantico = ["BR","BL","CR","CC","CL","DR","FR","FL","GL","GR","PR","PL","TR","LL","RR"]



func dividirEnSilabas(palabra: String) -> [String]{
    var arrayLetrasPalabra = [String]()
    var arrayVocalConsonante = [String]()
    var arrayResultadoSilabas = [String]()
    var silaba1 = ""
    var inicioIndiceSiguienteArrayVocal = 0
    
    //crea un array con las letras de la palabra y otro array indicando si es vocal o consonante.
    for l in palabra{
        arrayLetrasPalabra.append(String(l))
        if arrayVocales.contains(String(l)){
            arrayVocalConsonante.append("vocal")
        }
        else{
            arrayVocalConsonante.append("cons")
        }
    }
    
    while arrayVocalConsonante.count > 0 {
        //si empieza por vocal
         if arrayVocalConsonante[0] == "vocal"{
            if arrayVocalConsonante.count == 1 {
                silaba1 = arrayLetrasPalabra[0]
                inicioIndiceSiguienteArrayVocal = 1
            }
            if arrayVocalConsonante.count == 2{
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]
                inicioIndiceSiguienteArrayVocal = 2
            }
            if arrayVocalConsonante.count > 2{
                if arrayVocalConsonante[0] == "vocal" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "vocal"{
                    //ejemplo a-la
                    silaba1 = arrayLetrasPalabra[0]
                    inicioIndiceSiguienteArrayVocal = 1
                }
                if arrayVocalConsonante[0] == "vocal" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "cons"{
                    //ejemplo aus-picio
                    silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]
                    inicioIndiceSiguienteArrayVocal = 2
                    let grupoDosVocales = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]
                    if arrayGrupoDiptongo.contains(grupoDosVocales){
                        //diri-ais
                        silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]  + arrayLetrasPalabra[2]
                        inicioIndiceSiguienteArrayVocal = 3
                    }
                }
            }
            if arrayVocalConsonante.count > 3{
                if arrayVocalConsonante[0] == "vocal" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "cons" && arrayVocalConsonante[3] == "cons"{
                    //ejemplo aus-tria
                    silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                    inicioIndiceSiguienteArrayVocal = 3
                }
                if arrayVocalConsonante[0] == "vocal" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "cons" && arrayVocalConsonante[3] == "vocal"{
                    
                    let consonantes = arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                    if arrayGrupoConsonantico.contains(consonantes){
                        //ejemplo o-gro
                        silaba1 = arrayLetrasPalabra[0]
                        inicioIndiceSiguienteArrayVocal = 1

                    }
                    else{
                        //ejemplo al-to
                        silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]
                        inicioIndiceSiguienteArrayVocal = 2
                    }

                }
                if arrayVocalConsonante[0] == "vocal" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "cons" && arrayVocalConsonante[3] == "vocal"{
                    //ejemplo autonomo
                    silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]
                    inicioIndiceSiguienteArrayVocal = 2
                }
            }
            if arrayVocalConsonante.count > 4{
                if arrayVocalConsonante[0] == "vocal" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "cons" && arrayVocalConsonante[3] == "cons" && arrayVocalConsonante[4] == "vocal"{
                        //Si de las tres consonantes, las dos ultimas forman un grupo consonántico, se unen a la vocal posterior.
                        let consonatesUltimos = arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                        if arrayGrupoConsonantico.contains(consonatesUltimos){
                            
                            silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]
                            inicioIndiceSiguienteArrayVocal = 2
                        }
                        //Si hay tres consonantes entre vocales, las dos primeras consonantes se unen a la vocal anterior, y la tercera consonante a la vocal posterior.
                        else{
                          //ejemplo cons-truccion
                            silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                            inicioIndiceSiguienteArrayVocal = 3
                        }
                }
                if arrayVocalConsonante[0] == "vocal" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "cons" && arrayVocalConsonante[3] == "cons" && arrayVocalConsonante[4] == "cons"{
                        //Cuando concurren cuatro consonantes entre vocales, las dos primeras se unen a la vocal anterior y las dos ultimas, que siempre constituyen grupo consonántico, a la vocal posterior.
                        //ejemplo ins-tructor
                        silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                        inicioIndiceSiguienteArrayVocal = 3
                }
            }


        }
            
            
            //si empieza por consonante
        else if arrayVocalConsonante[0] == "cons"{
            
            if arrayVocalConsonante.count == 1 {
                silaba1 = arrayLetrasPalabra[0]
                inicioIndiceSiguienteArrayVocal = 1
            }
            if arrayVocalConsonante.count == 2{
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]
                inicioIndiceSiguienteArrayVocal = 2
            }
            if arrayVocalConsonante.count > 2{
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "cons"{
                    //ejemplo mor-tandad
                    silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                    inicioIndiceSiguienteArrayVocal = 3
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "vocal"{
                    //ejemplo mor-tandad
                    silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                    inicioIndiceSiguienteArrayVocal = 3
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "vocal"{
                    //ejemplo mor-tandad
                    silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                    inicioIndiceSiguienteArrayVocal = 3
                }
            }

            if arrayVocalConsonante.count > 3 {
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "cons" && arrayVocalConsonante[3] == "vocal"{
                    //ejemplo mu-jer
                    silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]
                    inicioIndiceSiguienteArrayVocal = 2
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "cons"{
                    //ejemplo tri-buna
                    silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                    inicioIndiceSiguienteArrayVocal = 3
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "vocal"{
                    //ejemplo trau-ma
                    silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                    inicioIndiceSiguienteArrayVocal = 4
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "cons" {
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                inicioIndiceSiguienteArrayVocal = 4
                    }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "vocal" {
                    //eusta-quio
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                inicioIndiceSiguienteArrayVocal = 4
                    }
            }
            if arrayVocalConsonante.count > 4{
                if  arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "cons" && arrayVocalConsonante[4] == "vocal" {
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                inicioIndiceSiguienteArrayVocal = 3
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "cons" && arrayVocalConsonante[4] == "cons" {
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                inicioIndiceSiguienteArrayVocal = 3
                let grupoConsonantes = arrayLetrasPalabra[3] + arrayLetrasPalabra[4]
                    if arrayGrupoConsonantico.contains(grupoConsonantes) == false{
                        //cuer-po
                        silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                        inicioIndiceSiguienteArrayVocal = 4
                    }
                    
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "vocal" && arrayVocalConsonante[4] == "cons" {
                    //diriais
                    let DosUltimasVocales = arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                    if arrayGrupoDiptongo.contains(DosUltimasVocales){
                        silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]
                        inicioIndiceSiguienteArrayVocal = 2
                    }

                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "cons" && arrayVocalConsonante[3] == "cons" && arrayVocalConsonante[4] == "cons"{
                    //Si de las tres consonantes, las dos ultimas forman un grupo consonántico, se unen a la vocal posterior.
                    let consonatesUltimos = arrayLetrasPalabra[3] + arrayLetrasPalabra[4]
                    if arrayGrupoConsonantico.contains(consonatesUltimos){
                        //ejemplo ham-bre - con-flicto dis-creto
                        silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                        inicioIndiceSiguienteArrayVocal = 3
                    }
                    //Si hay tres consonantes entre vocales, las dos primeras consonantes se unen a la vocal anterior, y la tercera consonante a la vocal posterior.
                    else{
                      //ejemplo cons-truccion
                        silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                        inicioIndiceSiguienteArrayVocal = 4
                    }
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "cons" && arrayVocalConsonante[4] == "cons"{
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                inicioIndiceSiguienteArrayVocal = 4
                    //ESTRELLADO
                    let excepcionLL = arrayLetrasPalabra[3] + arrayLetrasPalabra[4]
                    
                    if arrayGrupoConsonantico.contains(excepcionLL){
                        silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                        inicioIndiceSiguienteArrayVocal = 3
                    }
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "vocal" && arrayVocalConsonante[4] == "cons"{
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2] + arrayLetrasPalabra[3] + arrayLetrasPalabra[4]
                inicioIndiceSiguienteArrayVocal = 5
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "vocal" && arrayVocalConsonante[2] == "cons" && arrayVocalConsonante[3] == "cons" && arrayVocalConsonante[4] == "vocal"{
                //ejemplo mur-cielago
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                inicioIndiceSiguienteArrayVocal = 3
                    
                let grupoconsonantico = arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                    if arrayGrupoConsonantico.contains(grupoconsonantico){
                        silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1]
                        inicioIndiceSiguienteArrayVocal = 2
                    }
                }
            }
            if arrayVocalConsonante.count > 5{
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "cons" && arrayVocalConsonante[4] == "cons" && arrayVocalConsonante[5] == "cons"{
                    //TRANSGREDIR
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2] + arrayLetrasPalabra[3] + arrayLetrasPalabra[4]
                inicioIndiceSiguienteArrayVocal = 5
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "vocal" && arrayVocalConsonante[4] == "cons" && arrayVocalConsonante[5] == "vocal"{
                    //TRUEQUE
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                inicioIndiceSiguienteArrayVocal = 4
                }
                if arrayVocalConsonante[0] == "cons" && arrayVocalConsonante[1] == "cons" && arrayVocalConsonante[2] == "vocal" && arrayVocalConsonante[3] == "cons" && arrayVocalConsonante[4] == "cons" && arrayVocalConsonante[5] == "vocal"{
                    //construccion
                silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2] + arrayLetrasPalabra[3]
                inicioIndiceSiguienteArrayVocal = 4
                    
                    //ESTRELLADO
                    let excepcionLL = arrayLetrasPalabra[3] + arrayLetrasPalabra[4]
                    
                    if arrayGrupoConsonantico.contains(excepcionLL){
                        silaba1 = arrayLetrasPalabra[0] + arrayLetrasPalabra[1] + arrayLetrasPalabra[2]
                        inicioIndiceSiguienteArrayVocal = 3
                    }
                }
            }
            
            
        }
        
        arrayResultadoSilabas.append(silaba1)
        for _ in 0...(inicioIndiceSiguienteArrayVocal - 1){
            arrayVocalConsonante.remove(at: 0)
            arrayLetrasPalabra.remove(at: 0)
        }
    }
    return arrayResultadoSilabas
}


