//
//  ViewController.swift
//  GuardarImagenFirebase
//
//  Created by marco rodriguez on 31/05/21.
//

import UIKit
import Firebase
import FirebaseStorage



class ViewController: UIViewController {

    var uidImagen: String?
    
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
        //Convertir la imagen en datos()
        guard let image = imagenASubir.image, let datosImagen = image.jpegData(compressionQuality: 1.0) else {
            print("Error")
            return
        }
        //asignar un id unico para esos datos
        let imageNombre = UUID().uuidString
        uidImagen = imageNombre
        
        let imageReferencia = Storage.storage()
            .reference()
            .child("imagenes")
            .child(imageNombre)
        
        //Poner los datos en Firestore
        imageReferencia.putData(datosImagen, metadata: nil) { (metaData, error) in
            if let err = error {
                print("Error al subir imagen \(err.localizedDescription)")
            }
            
            imageReferencia.downloadURL { (url, error) in
                if let err = error {
                    print("Error al subir imagen \(err.localizedDescription)")
                    return
                }
                
                guard let url = url else {
                    print("Error al crear url de la imagen")
                    return
                }
                
                let dataReferencia = Firestore.firestore().collection("imagenes").document()
                let documentoID = dataReferencia.documentID
                
                let urlString = url.absoluteString
                
                let datosEnviar = ["id": documentoID,
                            "url": urlString
                ]
                
                dataReferencia.setData(datosEnviar) { (error) in
                    if let err = error {
                        print("Error al mandar datos de imagen \(err.localizedDescription)")
                        return
                    } else {
                        //Se subio a Firestore
                        print("Se guardó correctamente en FS")
                        //Ahora que harás cuando se guarde ?
                    }
                    
                    
                }
            }
        }
        
        
        
    }
    
    @IBAction func DescargarFotoBtn(_ sender: UIButton) {
        let query = Firestore.firestore().collection("imagenes").whereField("id", isEqualTo: "qTMJpWTTZ2DA9nlXR9R0")
        query.getDocuments { (snapshot, error) in
            if let err = error {
                print("Error al descargar imagen: \(err.localizedDescription)")
            }
            guard let snapshot = snapshot,
                  let data = snapshot.documents.first?.data(),
                  let urlString = data["url"] as? String,
                  let url = URL(string: urlString)
            else { return }
            
            
                   DispatchQueue.global().async { [weak self] in
                       if let data = try? Data(contentsOf: url) {
                           if let image = UIImage(data: data) {
                               DispatchQueue.main.async {
                                self?.imagenADescargar.image = image
                               }
                           }
                       }
                   }
               
        
            print("url: \(url)")
            
            
        }
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
