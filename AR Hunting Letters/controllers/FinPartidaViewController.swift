//
//  FinPartidaViewController.swift
//  AR Hunting Letters
//
//  Created by admin on 29/11/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation

class FinPartidaViewController: UIViewController {

    var sonidoFinPartida: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let soundURL = Bundle.main.url(forResource: "finPartida", withExtension: "wav"){
            
            do {
                sonidoFinPartida = try AVAudioPlayer(contentsOf: soundURL)
                
            } catch {
                print(error)
            }
            sonidoFinPartida.prepareToPlay()
            sonidoFinPartida.play()
            
            
        }
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
       // mostrarAlertVolver()
    }
    
    func mostrarAlertVolver(){
        let alert = UIAlertController(title: "SELECT", message: "SELECT AN OPTION", preferredStyle: .alert)
        
        let playList = UIAlertAction(title: "START THE LIST", style: .default) { (action) in
            UserDefaults.standard.set("lista",forKey: "modoJuego")
            UserDefaults.standard.set(false,forKey: "listaEmpezada")
            self.dismiss(animated: true, completion: nil)
        }
        
        let playNextList = UIAlertAction(title: "PLAY NEXT WORD ON THE LIST", style: .default) { (action) in
            UserDefaults.standard.set("lista",forKey: "modoJuego")
            self.dismiss(animated: true, completion: nil)
        }
        let playSingle = UIAlertAction(title: "PLAY SINGLE WORD", style: .default) { (action) in
            
            let alert = UIAlertController(title: "ENTER WORD", message: "ENTER WORD TO PLAY", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "ENTER WORD"
                textField.autocapitalizationType = .allCharacters
                textField.autocorrectionType = .no
                textField.spellCheckingType = .no
            }
            let btnOK = UIAlertAction(title: "OK", style: .default) { (action) in
                UserDefaults.standard.set("simple",forKey: "modoJuego")
                var palabraAjugar = ""
                let texto = (alert.textFields?.first)!.text ?? ""
                if texto.isEmpty || texto == ""{
                    palabraAjugar = "HELLO"
                }
                palabraAjugar = (texto.toNoSmartQuotes()).uppercased()
                UserDefaults.standard.set(palabraAjugar,forKey: "palabraAjugar")
                self.dismiss(animated: true, completion: nil)

                
            }
            let btnCancel = UIAlertAction(title: "CANCEL", style: .default) { (action) in
                return
            }
            
            alert.addAction(btnOK)
            alert.addAction(btnCancel)
            self.present(alert,animated: true)
        }
        
        alert.addAction(playList)
        alert.addAction(playNextList)
        alert.addAction(playSingle)
        
        present(alert, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
