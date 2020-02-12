//
//  MenuPrincipalViewController.swift
//  AR Hunting Letters
//
//  Created by admin on 29/11/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MenuPrincipalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false,forKey: "vuelveDefinPartida")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
             delegate.orientationLock = .all
         }
    }
    
    @IBAction func btnContinueList(_ sender: UIButton) {
        UserDefaults.standard.set("listaEmpezada",forKey: "modoJuego")
        self.performSegue(withIdentifier: "segueIrMenuJuego", sender: nil)
    }
    
    @IBAction func btnPlayList(_ sender: UIButton) {
        UserDefaults.standard.set("listaNueva",forKey: "modoJuego")
        self.performSegue(withIdentifier: "segueIrMenuJuego", sender: nil)
    }
    
    @IBAction func btnPlaySingle(_ sender: UIButton) {
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
                    return
                }
                palabraAjugar = (texto.toNoSmartQuotes()).uppercased()
                UserDefaults.standard.set(palabraAjugar,forKey: "palabraAjugar")
                self.performSegue(withIdentifier: "segueIrMenuJuego", sender: nil)

                
            }
            let btnCancel = UIAlertAction(title: "CANCEL", style: .default) { (action) in
                return
            }
            
            alert.addAction(btnOK)
            alert.addAction(btnCancel)
            present(alert,animated: true)
        
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
