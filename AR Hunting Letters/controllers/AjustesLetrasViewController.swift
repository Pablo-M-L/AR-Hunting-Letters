//
//  AjustesLetrasViewController.swift
//  AR Hunting Letters
//
//  Created by admin on 29/11/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AjustesLetrasViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var segmentPlayground: UISegmentedControl!
    
    @IBOutlet weak var switchShowWord: UISwitch!
    
    @IBOutlet weak var switchSilabas: UISwitch!
    
    @IBOutlet weak var labelWord1: UITextField!
    
    @IBOutlet weak var labelWord2: UITextField!
    
    @IBOutlet weak var lavelWord3: UITextField!
    
    @IBOutlet weak var labelWord4: UITextField!
    
    @IBOutlet weak var labelWord5: UITextField!
    
    @IBOutlet weak var labelWord6: UITextField!
    
    @IBOutlet weak var labelWord7: UITextField!
    
    @IBOutlet weak var labelWord8: UITextField!
    
    @IBOutlet weak var laberWord9: UITextField!
    
    @IBOutlet weak var labelWord10: UITextField!
    
    @IBOutlet weak var labelWord11: UITextField!
    
    @IBOutlet weak var labelWord12: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegarTextsFields()
        cargarTextoEdit()
        
        segmentPlayground.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "perimetroSeleccionado")
        switchShowWord.isOn = UserDefaults.standard.bool(forKey: "mostrarPalabra")
        switchSilabas.isOn = UserDefaults.standard.bool(forKey: "dividirEnSilabas")
        // Do any additional setup after loading the view.
    }
    
    func cargarTextoEdit(){
        labelWord1.text = UserDefaults.standard.string(forKey: "guardadoWord1")
        labelWord2.text = UserDefaults.standard.string(forKey: "guardadoWord2")
        lavelWord3.text = UserDefaults.standard.string(forKey: "guardadoWord3")
        labelWord4.text = UserDefaults.standard.string(forKey: "guardadoWord4")
        labelWord5.text = UserDefaults.standard.string(forKey: "guardadoWord5")
        labelWord6.text = UserDefaults.standard.string(forKey: "guardadoWord6")
        labelWord7.text = UserDefaults.standard.string(forKey: "guardadoWord7")
        labelWord8.text = UserDefaults.standard.string(forKey: "guardadoWord8")
        laberWord9.text = UserDefaults.standard.string(forKey: "guardadoWord9")
        labelWord10.text = UserDefaults.standard.string(forKey: "guardadoWord10")
        labelWord11.text = UserDefaults.standard.string(forKey: "guardadoWord11")
        labelWord12.text = UserDefaults.standard.string(forKey: "guardadoWord12")


    }
    
    func delegarTextsFields(){
        //el delegado permite ocultar el teclado despues de pulsar intro.
        labelWord1.delegate = self
        labelWord2.delegate = self
        lavelWord3.delegate = self
        labelWord4.delegate = self
        labelWord5.delegate = self
        labelWord6.delegate = self
        labelWord7.delegate = self
        labelWord8.delegate = self
        laberWord9.delegate = self
        labelWord10.delegate = self
        labelWord11.delegate = self
        labelWord12.delegate = self
    }
    
    /**
     * Tecla return pulsada
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        //mostrarAlertVolver()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editWord(_ sender: UITextField) {
        let nombreClave = "guardadoWord" + String(sender.tag)
        let palabra = sender.text ?? "HELLO"
        let palabraAguardar = palabra.toNoSmartQuotes()
        UserDefaults.standard.set(palabraAguardar,forKey: nombreClave)
        UserDefaults.standard.synchronize()
        sender.text = palabraAguardar

    }
    
    @IBAction func btnPerimetroPlayground(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(segmentPlayground.selectedSegmentIndex, forKey: "perimetroSeleccionado")
        UserDefaults.standard.set(segmentPlayground.selectedSegmentIndex, forKey: "perimetroJuego")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func btnSwitchMostrarWord(_ sender: UISwitch) {
        if switchShowWord.isOn{
            UserDefaults.standard.set(true,forKey: "mostrarPalabra")
        }
        else{
            UserDefaults.standard.set(false,forKey: "mostrarPalabra")
            }
        UserDefaults.standard.synchronize()
        
    }
    
    @IBAction func btnSwitchSilabas(_ sender: UISwitch) {
        if switchSilabas.isOn{
            UserDefaults.standard.set(true, forKey: "dividirEnSilabas")
        }
        else{
            UserDefaults.standard.set(false, forKey: "dividirEnSilabas")
        }
        UserDefaults.standard.synchronize()
    }
    
    func mostrarAlertVolver(){
        let alert = UIAlertController(title: "SELECT", message: "SELECT AN OPTION", preferredStyle: .alert)
        
        let playList = UIAlertAction(title: "START THE LIST", style: .default) { (action) in
            UserDefaults.standard.set("lista",forKey: "modoJuego")
            UserDefaults.standard.set(false,forKey: "listaEmpezada")
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
        let backMenu = UIAlertAction(title: "HOME", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(playList)
        alert.addAction(playSingle)
        alert.addAction(backMenu)
        
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
