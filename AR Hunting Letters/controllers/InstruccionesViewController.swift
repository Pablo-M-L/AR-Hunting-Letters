//
//  InstruccionesViewController.swift
//  AR Hunting Letters
//
//  Created by admin on 13/12/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class InstruccionesViewController: UIViewController {

    @IBOutlet weak var textLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      self.textLabel.text = NSLocalizedString("5q5-gO-ODC", comment: "texto traducido en los main.storyboard")  // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
