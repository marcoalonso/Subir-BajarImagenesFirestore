//
//  ViewController.swift
//  GuardarImagenFirebase
//
//  Created by marco rodriguez on 31/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imagenASubir: UIImageView!
    @IBOutlet weak var imagenADescargar: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:-Agregar gestura a la imagen
        
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
         //agregar la gestura a la imagen
        imagenASubir.addGestureRecognizer(gestura)
        imagenASubir.isUserInteractionEnabled = true
    }
    
    @objc func clickImagen(gestura: UITapGestureRecognizer) {
        print("Cambiar imagen")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }

    @IBAction func subirFotoBtn(_ sender: UIButton) {
    }
    @IBAction func DescargarFotoBtn(_ sender: UIButton) {
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagenASubir.image = imagenSeleccionada
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
