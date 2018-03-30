//
//  UserManager.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/28/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class UserManager {
    
    private let imageFilename = "avatar.png"
    private let usernameFilename = "username.txt"
    private let descriptionFilename = "description.txt"
    
    // Сохранение пользователя
    // если есть ошибка вернет true
    func save(user : User) -> Bool {
        do {
            let filePath = self.getDocumentsDirectory()
            
            if user.usernameWasEdited, let usernameUnwrapped = user.username {
                try usernameUnwrapped.write(to: filePath.appendingPathComponent(self.usernameFilename), atomically: false, encoding: String.Encoding.utf8)
            }
            
            if user.descriptionWasEdited, let descriptionUnwrapped = user.description {
                try descriptionUnwrapped.write(to: filePath.appendingPathComponent(self.descriptionFilename), atomically: false, encoding: String.Encoding.utf8)
            }
            
            if user.avatarWasEdited, let avatarUnwrapped = user.avatar {
                let imageData = UIImagePNGRepresentation(avatarUnwrapped);
                try imageData?.write(to: filePath.appendingPathComponent(self.imageFilename), options: .atomic);
            }
            
            return false
        } catch {
            return true
        }
    }
    
    // Получение загруженного пользователя
    func get() -> User? {
        do {
            let user : User = User()
            let filePath = getDocumentsDirectory()
            
            user.username = try String(contentsOf: filePath.appendingPathComponent(self.usernameFilename))
            user.description = try String(contentsOf: filePath.appendingPathComponent(self.descriptionFilename))
            user.avatar = UIImage(contentsOfFile: filePath.appendingPathComponent(self.imageFilename).path)
            
            return user
        } catch {
            return nil
        }
    }
    
    // Получение директории хранения файлов
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
