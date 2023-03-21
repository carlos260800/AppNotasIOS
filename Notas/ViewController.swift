//
//  ViewController.swift
//  Notas
//
//  Created by Jose Carlos Corona Bautista on 03/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    var tituloEnviar:String?
    var notaEnviar:String?
        
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    
    private var misNotas:[Notas]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NotasTableViewCell", bundle: nil), forCellReuseIdentifier: "celda")
        
        recuperarDatos()
    }

    @IBAction func botonAgregarAction(_ sender: Any) {
        let alerta = UIAlertController(title: "Nueva Nota", message: "Agrega una nueva nota", preferredStyle: .alert)
        
        alerta.addTextField { (textField) in
            textField.placeholder = "Titulo"
        }
        
        alerta.addTextField {(textField) in
            textField.placeholder = "Nota"
        }
        
        
        let botonGuardar = UIAlertAction(title: "Aceptar", style: .default){(action) in
            let titulo = alerta.textFields![0]
            let infoNota = alerta.textFields![1]
            
            let nuevaNota = Notas(context: self.context)
            nuevaNota.titulo = titulo.text
            nuevaNota.info = infoNota.text
            
            try! self.context.save()
            
            self.recuperarDatos()
        }
        
        let botonCancelar = UIAlertAction(title: "Cancelar", style: .destructive)
        
        alerta.addAction(botonCancelar)
        alerta.addAction(botonGuardar)
        
        self.present(alerta, animated: true, completion: nil)
    }
    
    func recuperarDatos(){
        do{
            self.misNotas = try context.fetch(Notas.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            print("No se pudieron recuperar los datos")
            
            let alertaError = UIAlertController(title: "Error", message: "Fallo al recuperar datos", preferredStyle: .alert)
            
            let botonAceptarError = UIAlertAction(title: "Aceptar", style: .destructive)
            
            alertaError.addAction(botonAceptarError)
            
            self.present(alertaError, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueNotas"{
            let destino = segue.destination as!NotasViewController
            destino.recibirTitulo = tituloEnviar
            destino.recibirNota = notaEnviar
        }
    }
}

// MARK: -UITableViewDataSource
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return misNotas!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as?NotasTableViewCell
        
        if celda == nil{
            celda = NotasTableViewCell(style: .default, reuseIdentifier: "celda")
            celda?.textLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold, width: .standard)
        }
        
        celda?.tituloLabel?.text = misNotas![indexPath.row].titulo
        celda?.notaLabel?.text = misNotas![indexPath.row].info
        
        return celda!

    }
}

// MARK: -UITableViewDelegate

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Asigana valor a variables globales de titulo e info
        let notaEditar = self.misNotas![indexPath.row]
        tituloEnviar = notaEditar.titulo
        notaEnviar = notaEditar.info
        
        // Editar Notas
//        let notaEditar = self.misNotas![indexPath.row]
        let alertaEditar = UIAlertController(title: "Editar", message: "Edita la informacion", preferredStyle: .alert)
        alertaEditar.addTextField{ (textField) in
            textField.placeholder = "Titulo"
        }
        
        alertaEditar.addTextField{ (textField) in
            textField.placeholder = "Nota"
        }

        let botonModificar = UIAlertAction(title: "Editar", style: .default){(action) in

            let editarTitulo = alertaEditar.textFields![0]
            let editarInfo = alertaEditar.textFields![1]

            notaEditar.titulo = editarTitulo.text
            notaEditar.info = editarInfo.text

            try! self.context.save()

            self.recuperarDatos()
            
            //Se actualizan los valores del titulo y nota
            self.tituloEnviar = notaEditar.titulo
            self.notaEnviar = notaEditar.info
            
            
            
            // Mandar a llamar la segunda pantalla
            self.performSegue(withIdentifier: "segueNotas", sender: nil)
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
        let botonCancelar = UIAlertAction(title: "Abrir Nota", style: .default){(action) in
            self.recuperarDatos()
            
            // Mandar a llamar la segunda pantalla
            self.performSegue(withIdentifier: "segueNotas", sender: nil)
        }

        alertaEditar.addAction(botonModificar)
        alertaEditar.addAction(botonCancelar)

        present(alertaEditar, animated: true, completion: nil)
        
    }


    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .destructive, title: "Eliminar"){(action, view, MTLNewLibraryCompletionHandler) in

            let notaEliminar = self.misNotas![indexPath.row]

            self.context.delete(notaEliminar)

            try! self.context.save()

            self.recuperarDatos()
        }
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
}

