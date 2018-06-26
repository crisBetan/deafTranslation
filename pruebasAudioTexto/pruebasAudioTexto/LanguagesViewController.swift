//  LanguagesViewController.swift
//  pruebasAudioTexto
//
//  Created by Cristina Servicio Social on 16/04/18.
//  Copyright © 2018 Cristina Servicio Social. All rights reserved.
//

import UIKit

protocol LanguagesViewDelegate : class {
    func didSelectLanguage(lanCode : String) //Ya seleccionó el nombre
}

class LanguagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate { //Llenar la tabla, el otro sus interacciones MÉTODOS OBLIGATORIOS: Número y acción de celdas
    
    @IBOutlet weak var tableView: UITableView!
    
    //mandamos a llamar métodos por objeto
    weak var delegate: LanguagesViewDelegate?
    
    
    let lanArray = ["🇲🇽 Español","🇺🇸 Inglés","🇩🇪 Alemán","🇫🇷 Francés","🇯🇵 Japonés","🇮🇱 Hebreo"]
    let codesArray = ["es-MX","en-US","de-DE","fr-FR","ja-JP","he-IL"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(dismissView))
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.title = "Languages"
        
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    //MARK: Table View DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lanArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = lanArray[indexPath.row]
        cell.detailTextLabel?.text =  codesArray[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor.darkGray
        return cell
    }
    
    //MARK: Table View Delegate - Este recibe todas las interacciones con el table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let code = codesArray[indexPath.row]
        delegate?.didSelectLanguage(lanCode: code)
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismissView()
    } //Se manda lo que hace el usuario y se quita
    
    
    
    @objc func dismissView(){ //asociado al botón de cancelar
        self.dismiss(animated: true, completion: nil)
    }

}
