//
//  NotasViewController.swift
//  Notas
//
//  Created by Jose Carlos Corona Bautista on 06/03/23.
//

import UIKit

class NotasViewController: UIViewController {

    
    @IBOutlet weak var tituloSegundaPantalla: UILabel!
    @IBOutlet weak var notaSegundaPantalla: UILabel!
    
    var recibirTitulo: String?
    var recibirNota: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tituloSegundaPantalla.text = recibirTitulo ?? ""
        notaSegundaPantalla.text = recibirNota ?? ""
        
    }
    
    
}
