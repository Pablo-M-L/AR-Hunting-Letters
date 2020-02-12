//
//  Scene.swift
//  AR Hunting Letters
//
//  Created by admin on 29/11/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import SpriteKit
import ARKit
import GameplayKit

class Scene: SKScene {
    
    var arrayPosiblesDistancias = [2,2.5,3]
    var arrayPosicionesY: [Float] = []
    var arrayPosicionesX: [Float] = []
    var arrayPosicionesZ: [Float] = []
    var posicionZ: Float = -3.5
    var posicionX: Float = 0.0
    var posicionY: Float = 0.0
    var timer: Timer?
    var conteoReparto = 0
    var configuradoEnSilabas = false
    var inidiceArraySilabas = 0
    
    //datos partida
    var listaEmpezada = false
    var palabraAjugar = UserDefaults.standard.string(forKey: "palabraAjugar")
    let largoPalabraAjugar = UserDefaults.standard.integer(forKey: "largoPalabraAjugar")
    var conteoNumerosEnelCentro = 0
    var indiceUltimaLetraCapturada = 0
    var cuentaIndiceArrayPalabraAjugar = 0
    var arrayCaracteresPalabraAjugar = [Character]()

    
    let sonidocazado = SKAction.playSoundFileNamed("laser-sound", waitForCompletion: false)
    let sonidofallado = SKAction.playSoundFileNamed("slam", waitForCompletion: false)
    let sonidoFinPartida = SKAction.playSoundFileNamed("finPartida", waitForCompletion: false)
    let sonidoExplosion = SKAction.playSoundFileNamed("NFF-explode", waitForCompletion: false)
    var spriteCruceta = SKSpriteNode()
    var spriteBotonDerecho = SKSpriteNode()
    var spriteBotonIzquierdo = SKSpriteNode()
    var spriteBotonStart = SKSpriteNode()
    var spriteLaserVerde = SKSpriteNode()
    var spriteFondoBlanco = SKSpriteNode()
    var spriteLetraGuia = SKSpriteNode()
    let imgMirillaNegra = SKTexture(imageNamed: "mirillaNegra")
    let imgMirillaVerde = SKTexture(imageNamed: "mirillaVerde")
    let imgBoton = SKTexture(imageNamed: "botonDisparo")
    let imgBotonStart = SKTexture(imageNamed: "botonStart")
    let imgLaser = SKTexture(imageNamed: "laserVerde")
    let imgLaserRojo = SKTexture(imageNamed: "rayoLaserRojo")
    let imgMangoLaser = SKTexture(imageNamed: "mangoLaser")
    let fondoBlanco = SKTexture(imageNamed: "fondoBlanco")
    
    //silabas
    var arraySilabas = [String]()
    var silaba = ""
    var conteoLetrasSilaba = 0
    var posicionXguardada: Float?
    var posicionYguardada: Float?
    var posicionZguardada: Float?
    
    var rotateX: simd_float4x4?
    var rotateY: simd_float4x4?
    //var rotateZ: simd_float4x4?
    var rotateZ = matrix_identity_float4x4
    //crear una translacion de 1.5 metros den la direccion de la pantalla.
    var translation = matrix_identity_float4x4
        
    override func didMove(to view: SKView) {
        let palabraAjugar = UserDefaults.standard.string(forKey: "palabraAjugar")
        
        configuradoEnSilabas = UserDefaults.standard.bool(forKey: "dividirEnSilabas")
        if configuradoEnSilabas{
            arraySilabas = dividirEnSilabas(palabra: palabraAjugar!)
            silaba = arraySilabas[inidiceArraySilabas]
            conteoLetrasSilaba = silaba.count
        }

        
        crearArrayPalabraAjugar()
        calcularPosiciones()
        ponerBotonStart()
        
        if UserDefaults.standard.bool(forKey: "mostrarPalabra"){
            spriteFondoBlanco.isHidden = false
        }
        else{
            spriteFondoBlanco.isHidden = true
        }
        //ponerLaserVerde()
        
        switch UserDefaults.standard.integer(forKey: "perimetroJuego") {
        case 0:
            arrayPosiblesDistancias = [1.5,2,2.5]
        case 1:
            arrayPosiblesDistancias = [2,2.5,3]
        case 2:
            arrayPosiblesDistancias = [2.5,3,3.5]
        default:
            arrayPosiblesDistancias = [2,2.5,3]
        }
        
    }
    
 
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        conteoNumerosEnelCentro = 0
        scene?.enumerateChildNodes(withName: "HL-*", using: { node, _ in
            let numero = node as! SKSpriteNode
            
            let distanciaAlCentro: CGFloat = distanceBetweenPoints(p1: self.spriteCruceta.position, p2: numero.position)
            if distanciaAlCentro < 30.0{
                self.conteoNumerosEnelCentro += 1
            }
            else if distanciaAlCentro > 30{
                self.conteoNumerosEnelCentro += 0
            }
                
            })
        if conteoNumerosEnelCentro > 0 {
            self.spriteCruceta.texture = self.imgMirillaVerde
        }
        else{
            self.spriteCruceta.texture = self.imgMirillaNegra
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                    //localizar el primer toque del conjunto de toques
            guard let touch = touches.first else{return}
            let locaton = touch.location(in: self)
            
            //mirar si el toque cae dento de nuestra vista de AR
            let hit = nodes(at: locaton)
            
            //asignar botones y mitilla
            for i in hit{
                if i.name == "btnDerecho"{
                    self.buscarNodos()
                }
                if i.name == "btnIzquierdo"{
                    self.buscarNodos()
                }
                if i.name == "btnStart"{
                    if !listaEmpezada{
                        ponerMirilla()
                        ponerBotonDerecho()
                        ponerBotonIzquierdo()
                        ponerPalabraGuia()
                        ponerFondoBlanco()
                        cambiarStartPorMango()
                        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                            self.repartirNumero()
                        })
                    }
                }
                
            }

    }

    func buscarNodos(){
        scene?.enumerateChildNodes(withName: "HL-*", using: { node, _ in
            let letra = node as! SKSpriteNode
            let distanciaAlCentro: CGFloat = distanceBetweenPoints(p1: self.spriteCruceta.position, p2: letra.position)
            if distanciaAlCentro < 30.0{
                
                let letraCapturada = self.obtenerLetra(spriteCapturado: letra)

                if letraCapturada == String(self.arrayCaracteresPalabraAjugar[self.indiceUltimaLetraCapturada]) {//|| numeroCapturado < 100
                    self.indiceUltimaLetraCapturada += 1
                    //self.marcador.isHidden = false
                    //self.spriteFondoBlanco.isHidden = false
                    self.lanzarLaserDestruir(numero: letra)

                    //self.marcador.text = String(self.ultimoCapturado) + ", " + self.arrayTextoNumeros[(self.ultimoCapturado - 1)]
                    //self.marcadorTexto.text = ", " + self.arrayTextoNumeros[(self.ultimoCapturado - 1)]
                    
                    if self.indiceUltimaLetraCapturada >= self.arrayCaracteresPalabraAjugar.count{
                      let timer2 = Timer.scheduledTimer(withTimeInterval: 3.2, repeats: false) { (timer) in
                      NotificationCenter.default.post(name: NSNotification.Name("irFinPartida"), object: nil)
                        }

                    }
                }
                else{
                    letra.run(self.sonidofallado)
                }
            }
            else{
                print("fallo")
            }
            
        })
    }
    
    func obtenerLetra(spriteCapturado: SKNode) ->String{
        let nombre = spriteCapturado.name
        let largoString = nombre?.count
        var letraObtenida = ""
        switch largoString {
        case 4:
            guard let numeroSubString = nombre?.suffix(1) else{return ""}
            letraObtenida = String(numeroSubString)
        case 5:
            guard let numeroSubString = nombre?.suffix(2) else{return ""}
            letraObtenida = String(numeroSubString)
        default:
            letraObtenida = ""
        }
        
        return letraObtenida
    }
    
    func crearArrayPalabraAjugar(){
        for letra in palabraAjugar! {
            arrayCaracteresPalabraAjugar.append(letra)
        }
    }
    
    //MARK: poner botones y laser
    func lanzarLaserDestruir(numero: SKNode){
        numero.run(sonidocazado)
        ponerLaserVerde()
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.72, repeats: false) { (timer) in
            self.spriteLaserVerde.removeFromParent()
            
            let numeroCazado = numero
            let animaFrame = [SKTexture(imageNamed: "exp1"),SKTexture(imageNamed: "exp2"),SKTexture(imageNamed: "exp3"),SKTexture(imageNamed: "exp4"),SKTexture(imageNamed: "exp5"),SKTexture(imageNamed: "exp6"),SKTexture(imageNamed: "exp7"),SKTexture(imageNamed: "exp8"),SKTexture(imageNamed: "exp9"),SKTexture(imageNamed: "exp10"),SKTexture(imageNamed: "exp11"),SKTexture(imageNamed: "exp12"),SKTexture(imageNamed: "exp13"),SKTexture(imageNamed: "exp14"),SKTexture(imageNamed: "exp15"),SKTexture(imageNamed: "exp16"),SKTexture(imageNamed: "exp17"),SKTexture(imageNamed: "exp18"),SKTexture(imageNamed: "exp19"),SKTexture(imageNamed: "exp20")]
            let animationFrames = SKAction.animate(with: animaFrame, timePerFrame: 0.06, resize: false, restore: true)
            let scaleOut = SKAction.scale(to: 10, duration: 1.2)
            let groupAction = SKAction.group([animationFrames,scaleOut, self.sonidoExplosion])
            let sequenceAction = SKAction.sequence([groupAction,SKAction.removeFromParent()])
            numeroCazado.run(sequenceAction)
            
        }
    }
    
    func ponerMirilla(){
        spriteCruceta = SKSpriteNode(texture: imgMirillaNegra)
        spriteCruceta.position = .zero

        spriteCruceta.zPosition = 3
        spriteCruceta.name = "cruceta"
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            spriteCruceta.scale(to: CGSize(width: (self.view?.frame.midX)! * 1.3, height: (self.view?.frame.midY)! / 1.6))

        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            if UIDevice.current.orientation == .portrait{
            spriteCruceta.scale(to: CGSize(width: (self.view?.frame.midX)!, height: (self.view?.frame.midY)! / 1.3))
            }
            else{
                spriteCruceta.scale(to: CGSize(width: ((self.view?.frame.midX)! / 1.5) , height: (self.view?.frame.midY)! / 1.5))
            }

        }
        
        addChild(spriteCruceta)
    }
    
    func ponerLaserVerde(){
        spriteLaserVerde = SKSpriteNode(texture: imgLaserRojo)

        spriteLaserVerde.zPosition = 2
        spriteLaserVerde.name = "laserVerde"
        
        if UIDevice.current.userInterfaceIdiom == .phone{

            switch UIScreen.main.nativeBounds.width {
            case 0...641:
                //print("640 iphone se")
                spriteLaserVerde.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (self.spriteBotonStart.frame.height * 1.9))
                spriteLaserVerde.scale(to: CGSize(width: ((self.view?.frame.width)! / 7 ), height: ((self.view?.frame.height)! ) / 2.1 ))
            case 642...751:
                    //print("750 iphone 8")
                    spriteLaserVerde.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (self.spriteBotonStart.frame.height * 1.9))
                    spriteLaserVerde.scale(to: CGSize(width: ((self.view?.frame.width)! / 7), height: ((self.view?.frame.height)! ) / 2.1 ))
            
            case 752...1125:
                        //print("1125 iphone 11 pro y 828 iphone 11 y iphone 7 plus (coge phisycal pixel 1080) ")
                        if UIScreen.main.nativeBounds.width == 1080{
                            spriteLaserVerde.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (self.spriteBotonStart.frame.height * 2))
                            spriteLaserVerde.scale(to: CGSize(width: ((self.view?.frame.width)! / 7), height: ((self.view?.frame.height)! ) / 2.3 ))
                        }
                        else{
                            spriteLaserVerde.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (self.spriteBotonStart.frame.height * 2.4))
                            spriteLaserVerde.scale(to: CGSize(width: ((self.view?.frame.width)! / 7), height: ((self.view?.frame.height)! ) / 2.5 ))
                    }

                    

            case 1160...1250:
                    if UIScreen.main.nativeBounds.height > 2300{
                        //print("1242 * 2688 iphone 11 pro max")
                        spriteLaserVerde.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (self.spriteBotonStart.frame.height * 2.5))
                        spriteLaserVerde.scale(to: CGSize(width: ((self.view?.frame.width)! / 7 ), height: ((self.view?.frame.height)! ) / 2.5))
                    }
                    else{
                        //print("1242 * 2208 iphone 8 plus")
                        spriteLaserVerde.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (self.spriteBotonStart.frame.height * 2.2))
                        spriteLaserVerde.scale(to: CGSize(width: ((self.view?.frame.width)! / 7), height: ((self.view?.frame.height)! ) / 2.5 ))
                    }

            default:
                print("default")
                spriteLaserVerde.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (self.spriteBotonStart.frame.height * 2))
                spriteLaserVerde.scale(to: CGSize(width: ((self.view?.frame.width)!  / 7), height: ((self.view?.frame.height)! ) / 2.5 ))
            }


        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            if UIDevice.current.orientation.isPortrait{
                spriteLaserVerde.scale(to: CGSize(width: ((self.view?.frame.width)! / 7 ), height: ((self.view?.frame.height)! ) / 2.5 ))
                spriteLaserVerde.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (self.spriteBotonStart.frame.height * 2.8))

            }
            else{
                spriteLaserVerde.scale(to: CGSize(width: ((self.view?.frame.width)! / 9 ), height: ((self.view?.frame.height)! ) / 2.5 ))
                spriteLaserVerde.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (self.spriteBotonStart.frame.height * 2))

            }
        }
        
        addChild(spriteLaserVerde)
    }
    
    func ponerBotonDerecho(){

        spriteBotonDerecho = SKSpriteNode(texture: imgBoton)
        spriteBotonDerecho.scale(to: CGSize(width: ((self.view?.frame.width)! / 4), height: ((self.view?.frame.width)! / 4)))
        spriteBotonDerecho.position = CGPoint(x: self.frame.maxX - (spriteBotonDerecho.size.width / 1.7), y: self.frame.minY + (self.spriteBotonDerecho.frame.height * 1.7))
        spriteBotonDerecho.zPosition = 1
        spriteBotonDerecho.name = "btnDerecho"
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.width {
            case 0...641:
                print("640 iphone se")
            case 642...751:
                    print("750 iphone 8")
            case 752...1125:
                //print("1125 iphone 11 pro y 828 iphone 11 y iphone 7 plus (coge phisycal pixel 1080) ")
                if UIScreen.main.nativeBounds.width == 1080{
                    spriteBotonDerecho.position = CGPoint(x: self.frame.maxX - (spriteBotonDerecho.size.width / 1.7), y: self.frame.minY + (self.spriteBotonDerecho.frame.height * 1.7))
                }
            case 1160...1250:
                    if UIScreen.main.nativeBounds.height > 2300{
                        //print("1242 * 2688 iphone 11 pro max")
                    }
                    else{
                        //print("1242 * 2208 iphone 8 plus")
                    }

            default:
                print("default")

            }

        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            if UIDevice.current.orientation.isPortrait{
                spriteBotonDerecho.scale(to: CGSize(width: ((self.view?.frame.width)! / 7), height: ((self.view?.frame.width)! / 7)))
                spriteBotonDerecho.position = CGPoint(x: self.frame.maxX - (spriteBotonDerecho.size.width / 1.2), y: self.frame.minY + (self.spriteBotonDerecho.frame.height * 1.7))
            }
            else{
                spriteBotonDerecho.scale(to: CGSize(width: ((self.view?.frame.width)! / 9), height: ((self.view?.frame.width)! / 9)))
                spriteBotonDerecho.position = CGPoint(x: self.frame.maxX - (spriteBotonDerecho.size.width), y: self.frame.minY + (self.spriteBotonDerecho.frame.height * 1.7))
            }
        }
        
        addChild(spriteBotonDerecho)
        
    }
    
    func ponerBotonIzquierdo(){
        spriteBotonIzquierdo = SKSpriteNode(texture: imgBoton)
        spriteBotonIzquierdo.scale(to: CGSize(width: ((self.view?.frame.width)! / 4), height: ((self.view?.frame.width)! / 4)))
        spriteBotonIzquierdo.position = CGPoint(x: self.frame.minX + (spriteBotonIzquierdo.size.width / 1.7), y: self.frame.minY +  (self.spriteBotonIzquierdo.frame.height * 1.7))
        spriteBotonIzquierdo.zPosition = 1
        spriteBotonIzquierdo.name = "btnIzquierdo"
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.width {
            case 0...641:
                print("640 iphone se")

            case 642...751:
                print("750 iphone 8")

            
            case 752...1125:
                //print("1125 iphone 11 pro y 828 iphone 11 y iphone 7 plus (coge phisycal pixel 1080) ")
                if UIScreen.main.nativeBounds.width == 1080{
                    spriteBotonIzquierdo.position = CGPoint(x: self.frame.minX + (spriteBotonIzquierdo.size.width / 1.7), y: self.frame.minY +  (self.spriteBotonIzquierdo.frame.height * 1.7))
                }
            case 1160...1250:
                    
                    if UIScreen.main.nativeBounds.height > 2300{
                        //print("1242 * 2688 iphone 11 pro max")
                    }
                    else{
                        //print("1242 * 2208 iphone 8 plus")
                    }

            default:
                print("default")

            }



        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            if UIDevice.current.orientation.isPortrait{
                spriteBotonIzquierdo.scale(to: CGSize(width: ((self.view?.frame.width)! / 7), height: ((self.view?.frame.width)! / 7)))
                spriteBotonIzquierdo.position = CGPoint(x: self.frame.minX + (spriteBotonIzquierdo.size.width / 1.2), y: self.frame.minY +  (self.spriteBotonIzquierdo.frame.height * 1.7))
            }
            else{
                spriteBotonIzquierdo.scale(to: CGSize(width: ((self.view?.frame.width)! / 9), height: ((self.view?.frame.width)! / 9)))
                spriteBotonIzquierdo.position = CGPoint(x: self.frame.minX + (spriteBotonIzquierdo.size.width), y: self.frame.minY +  (self.spriteBotonIzquierdo.frame.height * 1.7))
            }



        }
        addChild(spriteBotonIzquierdo)
        
    }
    
    func ponerBotonStart(){
        spriteBotonStart = SKSpriteNode(texture: imgBotonStart)
        spriteBotonStart.scale(to: CGSize(width: ((self.view?.frame.width)! / 4), height: ((self.view?.frame.width)! / 4)))
        //spriteBotonStart.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (self.spriteBotonStart.frame.height / 1.9))
        spriteBotonStart.position = CGPoint(x: 0.0, y: 0.0)
        spriteBotonStart.zPosition = 3
        spriteBotonStart.name = "btnStart"
        addChild(spriteBotonStart)
    }
    
    func cambiarStartPorMango(){
           spriteBotonStart.removeFromParent()
           spriteBotonStart = SKSpriteNode(texture: imgMangoLaser)
           spriteBotonStart.scale(to: CGSize(width: ((self.view?.frame.width)! / 10), height: ((self.view?.frame.width)! / 4)))
           spriteBotonStart.position = CGPoint(x: 0.0, y: self.frame.minY + (self.spriteBotonStart.frame.height / 1.9))
           spriteBotonStart.zPosition = 3
           spriteBotonStart.name = "btnStart"
           
           if UIDevice.current.userInterfaceIdiom == .phone{
               switch UIScreen.main.nativeBounds.width {
               case 0...641:
                   print("640 iphone se")
               case 642...751:
                     //  print("750 iphone 8")
                       spriteBotonStart.position = CGPoint(x: 0.0, y: self.frame.minY + (self.spriteBotonStart.frame.height / 2.1))

               
               case 752...1125:
                   //print("1125 iphone 11 pro y 828 iphone 11 y iphone 7 plus (coge phisycal pixel 1080) poner el mango")
                   if UIScreen.main.nativeBounds.width == 1080{
                       spriteBotonStart.position = CGPoint(x: 0.0, y: self.frame.minY + (self.spriteBotonStart.frame.height / 1.9))
                   }
               case 1160...1250:
                       
                       if UIScreen.main.nativeBounds.height > 2300{
                           //print("1242 * 2688 iphone 11 pro max")
                           spriteBotonStart.position = CGPoint(x: 0.0, y: self.frame.minY + (self.spriteBotonStart.frame.height / 2))

                       }
                       else{
                           //print("1242 * 2208 iphone 8 plus")
                           spriteBotonStart.position = CGPoint(x: 0.0, y: self.frame.minY + (self.spriteBotonStart.frame.height / 2))
                       }

               default:
                   print("default")

               }

           }
           else if UIDevice.current.userInterfaceIdiom == .pad{
               if UIDevice.current.orientation.isPortrait{
                   spriteBotonStart.scale(to: CGSize(width: ((self.view?.frame.width)! / 13), height: ((self.view?.frame.width)! / 7)))
                   spriteBotonStart.position = CGPoint(x: 0.0, y: self.frame.minY + (self.spriteBotonStart.frame.height / 1.8))

               }
               else{
                   spriteBotonStart.scale(to: CGSize(width: ((self.view?.frame.width)! / 15), height: ((self.view?.frame.width)! / 10)))
                   spriteBotonStart.position = CGPoint(x: 0.0, y: self.frame.minX + (self.spriteBotonStart.frame.height * 1.8))

               }
           }
           addChild(spriteBotonStart)
       }
    
    func ponerFondoBlanco(){
        let anchoNavigationBar = CGFloat(45)

        spriteFondoBlanco = SKSpriteNode(texture: fondoBlanco)
        spriteFondoBlanco.zPosition = -1
        spriteFondoBlanco.scale(to: CGSize(width: (self.view?.frame.size.width)!, height: anchoNavigationBar * 1.5))
        spriteFondoBlanco.position = CGPoint(x: (self.view?.frame.minX)!, y: self.frame.maxY - CGFloat(anchoNavigationBar))
        
        if UIDevice.current.userInterfaceIdiom == .phone{

            switch UIScreen.main.nativeBounds.width {
            case 0...641:
                //print("640 iphone se")
                spriteFondoBlanco.position = CGPoint(x: (self.view?.frame.minX)!, y: self.frame.maxY - CGFloat(anchoNavigationBar * 1.8))
            case 642...751:
                  //  print("750 iphone 8")
                spriteFondoBlanco.position = CGPoint(x: (self.view?.frame.minX)!, y: self.frame.maxY - CGFloat(anchoNavigationBar * 1.8))
            case 752...1125:
                    //print("1125 iphone 11 pro y 828 iphone 11 y iphone 7 plus (coge phisycal pixel 1080) ")
                    if UIScreen.main.nativeBounds.width == 1080{
                        spriteFondoBlanco.position = CGPoint(x: (self.view?.frame.minX)!, y: self.frame.maxY - CGFloat(anchoNavigationBar * 1.8))
                    }
                    else{
                      //  print("iphone 11 y 11 pro")
                        spriteFondoBlanco.position = CGPoint(x: (self.view?.frame.minX)!, y: self.frame.maxY - CGFloat(anchoNavigationBar / 1.2))
                }
            case 1160...1250:
                    if UIScreen.main.nativeBounds.height > 2300{
                        //print("1242 * 2688 iphone 11 pro max")
                        spriteFondoBlanco.position = CGPoint(x: (self.view?.frame.minX)!, y: self.frame.maxY - CGFloat(anchoNavigationBar / 1.2))
                    }
                    else{
                        //print("1242 * 2208 iphone 8 plus")
                        spriteFondoBlanco.position = CGPoint(x: (self.view?.frame.minX)!, y: self.frame.maxY - CGFloat(anchoNavigationBar * 1.8))
                    }

            default:
                print("default")

            }


        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            print("ipad fondo")
            if UIDevice.current.orientation.isPortrait{
                spriteFondoBlanco.scale(to: CGSize(width: (self.view?.frame.size.width)!, height: anchoNavigationBar * 2.5))
                spriteFondoBlanco.position = CGPoint(x: (self.view?.frame.minX)!, y: self.frame.maxY - CGFloat(anchoNavigationBar * 2.5))
            }
            else{
                spriteFondoBlanco.scale(to: CGSize(width: (self.view?.frame.size.width)!, height: anchoNavigationBar * 2.5))
                spriteFondoBlanco.position = CGPoint(x: (self.view?.frame.minX)!, y: self.frame.maxY - CGFloat(anchoNavigationBar * 2.5))
            }

        }
        addChild(spriteFondoBlanco)
        
        if UserDefaults.standard.bool(forKey: "mostrarPalabra"){
            spriteFondoBlanco.isHidden = false
        }
        else{
            spriteFondoBlanco.isHidden = true
        }
    }
    
    func ponerPalabraGuia(){
        
        if UserDefaults.standard.bool(forKey: "mostrarPalabra"){
            spriteLetraGuia.isHidden = false
        }
        else{
            spriteLetraGuia.isHidden = true
        }
        //calcular ancho sprite
        let anchoDispositivo = self.view?.frame.width
        let anchoNavigationBar = CGFloat(45)

        let numeroLetrasPalabra = arrayCaracteresPalabraAjugar.count
        let numeroLetrasAdividir = numeroLetrasPalabra <= 5 ? 5 : arrayCaracteresPalabraAjugar.count
        let anchoSpriteLetra = anchoDispositivo! / CGFloat(numeroLetrasAdividir + 3) //le añado 3, como si hubiera 3 palabras mas para compensar en la palabas largas.
        //calcular alto sprite
        let altoSpriteLetra = anchoSpriteLetra
        //bucle
        for i in 0...(numeroLetrasPalabra - 1){
            //obtener imagen sprite
            let stringTextura = "HL-" + String(arrayCaracteresPalabraAjugar[i])
            let textura = SKTexture(imageNamed: stringTextura)
            spriteLetraGuia = SKSpriteNode(texture: textura)
            spriteLetraGuia.zPosition = 1
            spriteLetraGuia.name = stringTextura
            spriteLetraGuia.scale(to: CGSize(width: anchoSpriteLetra, height: altoSpriteLetra))
            let posX = self.frame.minX + (anchoSpriteLetra * 2 ) + (anchoSpriteLetra * CGFloat(i))
            spriteLetraGuia.position = CGPoint(x: Int(posX), y: Int(self.frame.maxY - CGFloat(anchoNavigationBar)))
            if UIDevice.current.userInterfaceIdiom == .phone{

                switch UIScreen.main.nativeBounds.width {
                case 0...641:
                    print("640 iphone se")
                    spriteLetraGuia.position = CGPoint(x: Int(posX), y: Int(self.frame.maxY - CGFloat(anchoNavigationBar * 1.8)))
                case 642...751:
                        print("750 iphone 8")
                    spriteLetraGuia.position = CGPoint(x: Int(posX), y: Int(self.frame.maxY - CGFloat(anchoNavigationBar * 1.8)))
                case 752...1125:
                        //print("1125 iphone 11 pro y 828 iphone 11 y iphone 7 plus (coge phisycal pixel 1080) ")
                        if UIScreen.main.nativeBounds.width == 1080{
                            spriteLetraGuia.position = CGPoint(x: Int(posX), y: Int(self.frame.maxY - CGFloat(anchoNavigationBar * 1.8)))
                        }
                        else{
                            spriteLetraGuia.position = CGPoint(x: Int(posX), y: Int(self.frame.maxY - CGFloat(anchoNavigationBar / 1.2)))
                        }
                case 1160...1250:
                        if UIScreen.main.nativeBounds.height > 2300{
                            print("1242 * 2688 iphone 11 pro max")
                            spriteLetraGuia.position = CGPoint(x: Int(posX), y: Int(self.frame.maxY - CGFloat(anchoNavigationBar / 1.2)))
                        }
                        else{
                            print("1242 * 2208 iphone 8 plus ")
                            spriteLetraGuia.position = CGPoint(x: Int(posX), y: Int(self.frame.maxY - CGFloat(anchoNavigationBar * 1.8)))
                        }
                default:
                    print("default")
                }


            }
            else if UIDevice.current.userInterfaceIdiom == .pad{
                if UIDevice.current.orientation.isPortrait{
                    spriteLetraGuia.scale(to: CGSize(width: anchoSpriteLetra / 1.3, height: altoSpriteLetra / 1.3))
                    spriteLetraGuia.position = CGPoint(x: Int(posX), y: Int(self.frame.maxY - CGFloat(anchoNavigationBar * 2.5)))
                }
                else{
                    print("landscape ipad")
                    spriteLetraGuia.scale(to: CGSize(width: anchoSpriteLetra / 1.6, height: altoSpriteLetra / 1.6))
                    let posX = self.frame.minY + (anchoSpriteLetra * 2 ) + (anchoSpriteLetra * CGFloat(i))
                    spriteLetraGuia.position = CGPoint(x: Int(posX), y: Int(self.frame.maxY - CGFloat(anchoNavigationBar * 2.5)))
                }


            }
            //colocar sprite
            addChild(spriteLetraGuia)
            if UserDefaults.standard.bool(forKey: "mostrarPalabra"){
                spriteLetraGuia.isHidden = false
            }
            else{
                spriteLetraGuia.isHidden = true
            }
        }


    }
    
    func calcularPosiciones(){
        var posicion: Float = 0.00
        //crear una matriz de rotacion aleatoria en y. es el eje de rotacion que va de arriba a abajo de la pantalla del iphone.
        for _ in 0...(largoPalabraAjugar){
            let intervaloFloat = 1.0 / Float(largoPalabraAjugar)
            let intervalo = redondearConDecimales(numeroDecimales: 2, numeroFloat: intervaloFloat)
            posicion += intervalo
            if posicion > 1{
                posicion -= 1
            }
            else if posicion == 1{
                posicion = 0.01
            }
            
            arrayPosicionesY.append(redondearConDecimales(numeroDecimales: 2, numeroFloat: posicion))
        }
        arrayPosicionesX = arrayPosicionesY.reversed()
        arrayPosicionesZ = arrayPosicionesY
    }
    
    func repartirNumero(){
        //clase del generador de nuemeros aleatorios.
        let random = GKRandomSource.sharedRandom()
        
        if conteoReparto >= largoPalabraAjugar{
            timer?.invalidate()
            timer = nil
            listaEmpezada = true
        }
        else if configuradoEnSilabas == false{
            guard let sceneView = self.view as? ARSKView else{return}
            
            //Float.pi seria 180 grados.
            //2.0 * Float.pi es una vuelta entera.
            //el random es entre 0 y 1.
            //para indicar el eje en el que se quiere rotar se le indica poniendo un 0 o un 1 en los argumentos x,y,z
            //crear una matriz de rotacion aleatoria en x. es el eje de rotacion que va de izquierda a derecha de la pantalla.
            let multiplicador = arrayPosicionesX.randomElement()!
            let rotateX = simd_float4x4(SCNMatrix4MakeRotation(2 * Float.pi * multiplicador, 1, 0, 0))
            let indiceXABorrar = quitarPosicion(posicion: multiplicador, array: arrayPosicionesX)
            arrayPosicionesX.remove(at: indiceXABorrar)
            
            
            let multiplicadorY = arrayPosicionesY.randomElement()!
            let rotateY = simd_float4x4(SCNMatrix4MakeRotation(2.0 * Float.pi * multiplicadorY , 0, 1, 0))
            let indiceYABorrar = quitarPosicion(posicion: multiplicadorY, array: arrayPosicionesY)
            arrayPosicionesY.remove(at: indiceYABorrar)
            
            /*
            //el eje de rotacion z es el que atraviesa la pantalla.
            let multiplicadorZ = arrayPosicionesZ.randomElement()!
            let rotateZ = simd_float4x4(SCNMatrix4MakeRotation(2.0 * Float.pi * multiplicadorZ , 0, 0, 1))
            let indiceZABorrar = quitarPosicion(posicion: multiplicadorZ, array: arrayPosicionesY)
            arrayPosicionesZ.remove(at: indiceZABorrar)
            */
            
            // combinar las dos rotaciones con un producto de matrices.
            let rotation = simd_mul(rotateX, rotateY)
            //let rotationTotal = simd_mul(rotation, rotateZ)
            
            //crear una translacion de 1.5 metros den la direccion de la pantalla.
            var translation = matrix_identity_float4x4
            
            
            let indiceArrayDistancia = random.nextInt(upperBound: arrayPosiblesDistancias.count)
            let distancia = arrayPosiblesDistancias[indiceArrayDistancia]
            translation.columns.3.z = Float(distancia) * -1
            
            //combinar la matriz de rotacion con la matriz de translacion. primero se rota y despues se translada.
            let finalTransform = simd_mul(rotation, translation)

            //creamos el punto de anclaje.
            let anchor = ARAnchor(transform: finalTransform)
            
            //añadir esa ancla a la escena.
            sceneView.session.add(anchor: anchor)
            
            conteoReparto += 1
        }
        else if configuradoEnSilabas == true {
            
            
            if conteoLetrasSilaba == 0{
                inidiceArraySilabas += 1
                silaba = arraySilabas[inidiceArraySilabas]
                conteoLetrasSilaba = silaba.count
            }
            var multiplicadorY: Float?

            let random = GKRandomSource.sharedRandom()

            
            guard let sceneView = self.view as? ARSKView else{return}
            let posicionNueva = posicionEnXNueva()
            if  posicionNueva == 1{
                let multiplicador = arrayPosicionesX.randomElement()!
                posicionXguardada = 2 * Float.pi * multiplicador
                
                multiplicadorY = arrayPosicionesY.randomElement()!
                posicionYguardada = 2 * Float.pi * multiplicadorY!
                
                //multiplicadorZ = arrayPosicionesZ.randomElement()!
                //posicionZguardada = multiplicadorZ//2.0 * Float.pi * multiplicadorZ!
                
                rotateX = simd_float4x4(SCNMatrix4MakeRotation(posicionXguardada!, 1, 0, 0))
                let indiceXABorrar = quitarPosicion(posicion: multiplicador, array: arrayPosicionesX)
                arrayPosicionesX.remove(at: indiceXABorrar)
                
                rotateY = simd_float4x4(SCNMatrix4MakeRotation(posicionYguardada! , 0, 1, 0))
                let indiceYABorrar = quitarPosicion(posicion: multiplicadorY!, array: arrayPosicionesY)
                arrayPosicionesY.remove(at: indiceYABorrar)
                
                /*
                rotateZ = simd_float4x4(SCNMatrix4MakeRotation( posicionZguardada!, 0, 0, 1))
                //rotateZ.columns.3.z = multiplicadorZ!
                let indiceZABorrar = quitarPosicion(posicion: multiplicadorZ!, array: arrayPosicionesZ)
                arrayPosicionesZ.remove(at: indiceZABorrar)
                */
                let indiceArrayDistancia = random.nextInt(upperBound: arrayPosiblesDistancias.count)
                let distancia = arrayPosiblesDistancias[indiceArrayDistancia]
                posicionZguardada = Float(distancia) * -1
                
                translation.columns.3.z = posicionZguardada!
                translation.columns.3.x = 0.0
                
                }
            else if posicionNueva == 2{
                translation.columns.3.x += 0.3
                
                
            }
            else if posicionNueva == 3{
                silaba = arraySilabas[inidiceArraySilabas]
                conteoLetrasSilaba = silaba.count - 1

            }
                 
             //el eje de rotacion z es el que atraviesa la pantalla.


            // combinar las dos rotaciones con un producto de matrices.
            let rotation = simd_mul(rotateX!, rotateY!)
            //let rotationTotal = simd_mul(rotation, rotateZ)
                           
            //crear una translacion de 1.5 metros den la direccion de la pantalla.
            //var translation = matrix_identity_float4x4
                           
                           

                           
            //combinar la matriz de rotacion con la matriz de translacion. primero se rota y despues se translada.
            var finalTransform = simd_mul(rotation, translation)
            if finalTransform.columns.0.x < 0{
                finalTransform.columns.0.x = finalTransform.columns.3.x * -1.0
            }
            if finalTransform.columns.2.y < 0{
                finalTransform.columns.2.y = finalTransform.columns.3.x * -1.0
            }
            //creamos el punto de anclaje.
            let anchor = ARAnchor(transform: finalTransform)

                           
            //añadir esa ancla a la escena.
            sceneView.session.add(anchor: anchor)
                           
            conteoReparto += 1

           
        }

    }
    
    func quitarPosicion(posicion: Float, array: Array<Float>) -> Int{
        var indice = 0
        for pos in array{
            if pos == posicion{
                return indice
            }
            else{
                indice += 1
            }
        }
        return indice
    }
    
    func posicionEnXNueva() ->Int{
        if arraySilabas.count > 0 {
           // print("silabas conteo = \(conteoLetrasSilaba)")

                if conteoLetrasSilaba == silaba.count{
                    conteoLetrasSilaba -= 1
                    return 1
                }
                else{
                    conteoLetrasSilaba -= 1
                    return 2
                }
        }
        else{
            print("array vacio")
            return 5
        }
        
        
    }
    
}
