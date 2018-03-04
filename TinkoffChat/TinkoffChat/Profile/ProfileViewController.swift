//
//  ProfileScreen.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/4/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var profileButton : UIButton!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var detailLabel : UILabel!
    @IBOutlet weak var editProfileButton : UIButton!
    
    let imagePickerController : UIImagePickerController = UIImagePickerController()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // В данном случае кнопка еще не проинициализирована
        self.logButtonFrame(button: self.editProfileButton, function: #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = false
        
        // В этом методе загружается разметка и то что указано в разметке = <rect key="frame" x="16" y="507" width="288" height="45"/> (свойства кнопки -> View, где указан Frame Rectangle) будет отображено в консоли
        // Таким образом кнопка будет показывать размер (16, 507, 288, 45)
        self.logButtonFrame(button: self.editProfileButton, function: #function)
        let profileButtonRadius = self.profileButton.bounds.width / 2;
        self.profileImageView.applyCornerRadius(radius: profileButtonRadius)
        self.profileButton.applyCornerRadius(radius: profileButtonRadius)
        self.editProfileButton.applyButtonStyle()
        
        // установил scaleAspectFill, тк считаю что фотография может быть слишком узкая или слишком широкая, поэтому эффект закругленных углов должен быть даже в таких случаях
        self.profileImageView.contentMode = .scaleAspectFill
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Здесь вьюшки уже имеют корректные размеры
        // frame отличается, потому что произошло применение constraints'ов и вьюшки растянулись
        self.logButtonFrame(button: self.editProfileButton, function: #function)
    }
    
    @IBAction func profileButtonTouch(sender : UIButton) {
        print("Выбери изображение профиля")
        let alertController = UIAlertController(title: "Выбрать изображение профиля", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Установить из галлереи", style: .default, handler: self.chooseFromGallery))
        alertController.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: self.makePhoto))
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func chooseFromGallery(action : UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Нет доступа к галереи")
        }
    }
    
    private func makePhoto(action : UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Нет доступа к камере")
        }
    }
    
    private func logButtonFrame(button : UIButton?, function : String) {
        guard let buttonUnwrapped = button else {
            print("\n\nКнопка не проинициализирована в \(function)")
            return
        }
        
        print("\n\nРазмер кнопки = \(buttonUnwrapped.frame) в \(function) ")
    }
    
    // MARK implementation UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = image
        } else {
            print("Не удалось выбрать изображение")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
