//
//  ViewController.swift
//  AR Hunting Letters
//
//  Created by admin on 29/11/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import GameplayKit //se usa para numeros aleatorios.

class ViewController: UIViewController, ARSKViewDelegate {
    
    var modoJuego = "lista"
    var indiceUltimaPalabraJugada = 5
    var indiceArrayLetra = 0
    var palabraAjugar = "HELLO"
    var arrayListaPalabras = [String]()
    var arrayCaracteresPalabraAjugar = [Character]()
    var configuradoEnSilabas = true
    
    @IBOutlet var sceneView: ARSKView!
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //notificacion que se llama desde el scene.swift para ir a la pantalla fin partida.
        NotificationCenter.default.addObserver(self, selector: #selector(irFinPartida), name: NSNotification.Name(rawValue: "irFinPartida"), object: nil)
        
        crearArrayListaPalabras()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = false
        sceneView.showsNodeCount = false
        
        
        
        //detectar modo juego (lista o simple)
        modoJuego = UserDefaults.standard.string(forKey: "modoJuego") ?? "lista"
        
        //se juega con la lista de palabras.
        print("modo juego \(modoJuego)")
        if modoJuego == "listaNueva" || indiceUltimaPalabraJugada >= 11{
            palabraAjugar = arrayListaPalabras[0]
            if palabraAjugar.isEmpty || palabraAjugar == ""{
                palabraAjugar = "HELLO"
                UserDefaults.standard.set(palabraAjugar, forKey: "palabraAjugar")
                UserDefaults.standard.set(0, forKey: "indiceUltimaPalabraJugada")
                UserDefaults.standard.synchronize()
            }
            else{
                UserDefaults.standard.set(palabraAjugar, forKey: "palabraAjugar")
                UserDefaults.standard.set(0, forKey: "indiceUltimaPalabraJugada")
                UserDefaults.standard.synchronize()
            }
            print("primera palabra a jugar \(palabraAjugar)")
            
        }
        else if modoJuego == "listaEmpezada"{
                indiceUltimaPalabraJugada = UserDefaults.standard.integer(forKey: "indiceUltimaPalabraJugada")

                    //si ya ha empezado a usarse la lista, se le pasa la siguiente palabra de la lista.
                    palabraAjugar = arrayListaPalabras[indiceUltimaPalabraJugada + 1]
                    if palabraAjugar.isEmpty || palabraAjugar == ""{
                        palabraAjugar = "HELLO"
                    }
                    UserDefaults.standard.set(palabraAjugar, forKey: "palabraAjugar")
                    let indiceSiguiente = indiceUltimaPalabraJugada + 1
                    UserDefaults.standard.set(indiceSiguiente, forKey: "indiceUltimaPalabraJugada")
                    UserDefaults.standard.synchronize()
        }
        //se juega con una sola palabra.
        else {
            palabraAjugar = UserDefaults.standard.string(forKey: "palabraAjugar") ?? "HELLO"
            UserDefaults.standard.synchronize()
        }
        
        UserDefaults.standard.set(palabraAjugar.count, forKey: "largoPalabraAjugar")
        UserDefaults.standard.synchronize()
        
        crearArrayPalabraAjugar()
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        // Load the SKScene from 'Scene.sks'
        self.loadView()
        print("didrotate")
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    @objc func irFinPartida(){
        UserDefaults.standard.set(true,forKey: "vuelveDefinPartida")
        self.performSegue(withIdentifier: "segueIrJuegoAfin", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("willappear")
        
        //bloquear autogiro
        if UIDevice.current.orientation.isPortrait{
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                 delegate.orientationLock = .portrait
             }
        }
        else if UIDevice.current.orientation.isLandscape{
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                 delegate.orientationLock = .landscape
             }
        }
        
        
        if UserDefaults.standard.bool(forKey: "vuelveDefinPartida"){
            UserDefaults.standard.set(false,forKey: "vuelveDefinPartida")
            self.dismiss(animated: true, completion: nil)
        }
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("willdisappear")
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - funciones partida
    
    func crearArrayListaPalabras(){
        for i in 0...11{
            let key = "guardadoWord" + String(i+1)
            let palabra = UserDefaults.standard.string(forKey: key) ?? ""
            arrayListaPalabras.append(palabra)
        }
    }
    
    func crearArrayPalabraAjugar(){
        for letra in palabraAjugar{
            arrayCaracteresPalabraAjugar.append(letra)
        }
    }
    

    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        var spriteLetra = SKSpriteNode()
        if configuradoEnSilabas == false{
            // Create and configure a node for the anchor added to the view's session.
            let random = GKRandomSource.sharedRandom()
            let indiceAleatorio = random.nextInt(upperBound: (arrayCaracteresPalabraAjugar.count))
            let nombreTextura = "HL-" + String(arrayCaracteresPalabraAjugar[indiceAleatorio])
            let textura = SKTexture(imageNamed: nombreTextura)
            arrayCaracteresPalabraAjugar.remove(at: indiceAleatorio)
            
            spriteLetra = SKSpriteNode(texture: textura)
            spriteLetra.name = nombreTextura
            
            
        }
        else if configuradoEnSilabas == true{
            let nombreTextura = "HL-" + String(arrayCaracteresPalabraAjugar[indiceArrayLetra])
            let textura = SKTexture(imageNamed: nombreTextura)
            
            spriteLetra = SKSpriteNode(texture: textura)
            spriteLetra.name = nombreTextura
            indiceArrayLetra += 1
            
        }
        
        return spriteLetra
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
