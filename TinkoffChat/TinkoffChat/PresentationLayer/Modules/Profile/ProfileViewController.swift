//
//  ProfileScreen.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/4/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: BaseViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var profileButton : UIButton!
    @IBOutlet weak var usernameField : UITextField!
    @IBOutlet weak var detailTextView : UITextView!
    @IBOutlet weak var editProfileButton : UIButton!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var coreDataButton: UIButton!
    
    let imagePickerController : UIImagePickerController = UIImagePickerController()
    
    private var userStorageFacade : IUserStorageFacade
    private var assembly: IPresentationAssembly
    
    var editingMode : Bool = false {
        didSet {
            self.setEditingMode(isEditing: editingMode)
        }
    }
    
    private var user : ProfileUser?
    private var repeatSaveBlock : (() -> Void)?
    
    private var profileWasEdited : Bool {
        get {
            return self.user?.usernameWasEdited ?? false || self.user?.descriptionWasEdited ?? false || self.user?.avatarWasEdited ?? false
        }
    }
    
    init(userStorageFacade: IUserStorageFacade, assembly: IPresentationAssembly) {
        self.userStorageFacade = userStorageFacade
        self.assembly = assembly
        super.init(nibName: "ProfileViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        
        self.detailTextView.delegate = self
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = false
        
        // В этом методе загружается разметка и то что указано в разметке = <rect key="frame" x="16" y="507" width="288" height="45"/> (свойства кнопки -> View, где указан Frame Rectangle) будет отображено в консоли
        // Таким образом кнопка будет показывать размер (16, 507, 288, 45)
        self.logButtonFrame(button: self.editProfileButton, function: #function)
        let profileButtonRadius = self.profileButton.bounds.width / 2;
        self.profileImageView.applyCornerRadius(radius: profileButtonRadius)
        self.profileButton.applyCornerRadius(radius: profileButtonRadius)
        self.editProfileButton.applyButtonStyle()
        self.operationButton.applyButtonStyle()
        self.gcdButton.applyButtonStyle()
        self.coreDataButton.applyButtonStyle()
        
        // установил scaleAspectFill, тк считаю что фотография может быть слишком узкая или слишком широкая, поэтому эффект закругленных углов должен быть даже в таких случаях
        self.profileImageView.contentMode = .scaleAspectFill
        self.editingMode = false
        self.loadUser()
        
        self.detailTextView.text = "Нет данных"
        self.detailTextView.textColor = UIColor.lightGray
        self.user = ProfileUser(username: self.usernameField.text, description: self.detailTextView.text, avatar: self.profileImageView.image)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Здесь вьюшки уже имеют корректные размеры
        // frame отличается, потому что произошло применение constraints'ов и вьюшки растянулись
        self.logButtonFrame(button: self.editProfileButton, function: #function)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func usernameEditingChanged(_ sender: UITextField) {
        if let usernameText = sender.text {
            self.user!.usernameWasEdited = usernameText != self.user!.username ?? ""
            self.setEnabledButton(isEnabled: self.profileWasEdited)
        }
    }
    
    @IBAction func editProfile(sender : UIButton) {
        self.editingMode = true
        self.setEnabledButton(isEnabled: false)
    }
    
    @IBAction func saveButtonTouch(_ sender: UIButton) {
        self.usernameField.resignFirstResponder()
        self.detailTextView.resignFirstResponder()
        
        self.repeatSaveBlock = {
            self.activityIndicator.startAnimating()
            self.setEnabledButton(isEnabled: false)
            self.user!.username = self.usernameField.text
            self.user!.description = self.detailTextView.text
            self.user!.avatar = self.profileImageView.image
            
            if sender.tag == 0 {
                self.userStorageFacade.selectStrategy(userStorageService: .operation)
            } else if sender.tag == 1 {
                self.userStorageFacade.selectStrategy(userStorageService: .gcdStorage)
            } else {
                self.userStorageFacade.selectStrategy(userStorageService: .coreDataStorage)
            }
            
            self.userStorageFacade.updateUser(user: self.user!, completionClosure: { (withError : Bool) in
                self.activityIndicator.stopAnimating()
                if withError {
                    self.presentErrorAlertController()
                } else {
                    self.loadUser()
                    self.presentSuccessAlertController()
                }
                
                self.setEnabledButton(isEnabled: true)
                self.editingMode = withError
            })
        }
        
        self.repeatSaveBlock?();
    }
    
    @IBAction func profileButtonTouch(sender : UIButton) {
        if !self.editingMode {
            return;
        }
        
        print("Выбери изображение профиля")
        let alertController = UIAlertController(title: "Выбрать изображение профиля", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Установить из галлереи", style: .default, handler: self.chooseFromGallery))
        alertController.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: self.makePhoto))
        alertController.addAction(UIAlertAction(title: "Загрузить", style: .default, handler: self.loadPhotos))
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let scrollInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            self.scrollView.scrollIndicatorInsets = scrollInsets
            self.scrollView.contentInset = scrollInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = UIEdgeInsets.zero
    }
    
    private func loadUser() {
        self.userStorageFacade.getUser(completionClosure: {(user) in
            if let userUnwrapped = user {
                self.user = userUnwrapped
                // из за плейсхолдера пришлось это сделать
                self.detailTextView.text = userUnwrapped.description                
                self.detailTextView.textColor = UIColor.black
            }
            
            self.profileImageView.image = user?.avatar ?? UIImage.init(named: "im_user_placeholder")
            self.usernameField.text = user?.username ?? ""
        })
    }
    
    private func setEditingMode(isEditing : Bool) {
        self.usernameField.borderStyle = isEditing ? .roundedRect : .none
        self.editProfileButton.isHidden = isEditing
        self.usernameField.isEnabled = isEditing
        self.detailTextView.isEditable = isEditing
        self.operationButton.isHidden = !isEditing
        self.gcdButton.isHidden = !isEditing
        self.coreDataButton.isHidden = !isEditing
    }
    
    private func setEnabledButton(isEnabled : Bool) {
        self.operationButton.isEnabled = isEnabled
        self.gcdButton.isEnabled = isEnabled
        self.coreDataButton.isEnabled = isEnabled
    }
    
    private func logButtonFrame(button : UIButton?, function : String) {
        guard let buttonUnwrapped = button else {
            print("\n\nКнопка не проинициализирована в \(function)")
            return
        }
        
        print("\n\nРазмер кнопки = \(buttonUnwrapped.frame) в \(function) ")
    }
}

// MARK: - UIAlerController
extension ProfileViewController {
    
    private func loadPhotos(action : UIAlertAction) {
        let photosViewController = self.assembly.photosViewController()
        photosViewController.collectionPickerDelegate = self
        
        self.present(UINavigationController(rootViewController: photosViewController), animated: true, completion: nil)
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
    
    private func presentSuccessAlertController() {
        let alertController = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentErrorAlertController() {
        let alertController = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { action in
            self.repeatSaveBlock?();
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Image Picker Delegate
extension ProfileViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = image
            
            if let previousImage = self.user!.avatar {
                let newImage = UIImagePNGRepresentation(image)!
                let oldImage = UIImagePNGRepresentation(previousImage)!
                self.user!.avatarWasEdited = !newImage.elementsEqual(oldImage)
            } else {
                self.user!.avatarWasEdited = true
            }
            
            self.setEnabledButton(isEnabled: self.profileWasEdited)
        } else {
            print("Не удалось выбрать изображение")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Text View Delegate
extension ProfileViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let detailText = textView.text {
            self.user!.descriptionWasEdited = detailText != self.user!.description ?? ""
            self.setEnabledButton(isEnabled: self.profileWasEdited)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Нет данных"
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: - IPhotosViewControllerDelegate
extension ProfileViewController : IPhotosViewControllerDelegate {
    
    func collectionPickerController(_ picker: PhotosViewController, didFinishPickingImage image: UIImage) {
        
        self.profileImageView.image = image
        
        if let previousImage = self.user!.avatar {
            let newImage = UIImagePNGRepresentation(image)!
            let oldImage = UIImagePNGRepresentation(previousImage)!
            self.user!.avatarWasEdited = !newImage.elementsEqual(oldImage)
        } else {
            self.user!.avatarWasEdited = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
