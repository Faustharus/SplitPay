//
//  RegistrationService.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

enum RegistrationKeys: String {
    case id
    case firstName
    case surName
    case nickName
    case extNickName
    case profilePicture
    case email
    case contacts
}

protocol RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                
                guard let imageSelected = details.picture else {
                    print("Avatar is nil")
                    return
                }
                // Set the compression quality of the image for storing
                guard let imageData = imageSelected.jpegData(compressionQuality: 0.2) else {
                    return
                }
                
                Auth.auth()
                    // Set the creation of a new user
                    .createUser(withEmail: details.email, password: details.password) { res, error in
                        if let err = error {
                            promise(.failure(err))
                            return
                        } else {
                            // Initialize a new uid
                            if let uid = res?.user.uid {
                                // Initialize the DB
                                let db = Firestore.firestore()
                                
                                // Add the data in the DB for the new user created
                                db.collection("users").document(uid).setData([
                                    RegistrationKeys.id.rawValue: uid,
                                    RegistrationKeys.firstName.rawValue: details.firstName,
                                    RegistrationKeys.surName.rawValue: details.surName,
                                    RegistrationKeys.nickName.rawValue: details.nickName,
                                    RegistrationKeys.extNickName.rawValue: "\(details.nickName)#\(Int.random(in: 1000..<10000))",
                                    //RegistrationKeys.profilePicture.rawValue: uploadImgURL,
                                    RegistrationKeys.email.rawValue: details.email,
                                    //RegistrationKeys.contacts.rawValue: details.contacts
                                ])
//                                { error in
//                                    if let err = error {
//                                        promise(.failure(err))
//                                    } else {
//                                        promise(.success(()))
//                                    }
//                                }
                                
                                /* TODO: Storage Ref must be inside with an update of the db.collection including the
                                 uploadingImgURL */
                                
                                let storageRef = Storage.storage().reference(forURL: "gs://splitpay-6dc17.appspot.com")
                                // Set up the file and the name for the profile image stored
                                let storageProfileRef = storageRef.child("profile").child("\(res?.user.uid ?? "N/A")")
                                
                                let metadata = StorageMetadata()
                                metadata.contentType = "image/jpeg"

                                storageProfileRef.putData(imageData, metadata: metadata, completion: {
                                    (storageMetaData, error) in
                                    if error != nil {
                                        print("\(String(describing: error?.localizedDescription))")
                                        return
                                    }

                                    // Set the url from where the image can be downloaded by converting it as a String
                                    storageProfileRef.downloadURL { (url, error) in
                                        if let uploadImgURL = url?.absoluteString {
                                            let profileRef = db.collection("users").document(uid)
                                            
                                            profileRef.updateData([
                                                RegistrationKeys.profilePicture.rawValue: uploadImgURL
                                            ]) { error in
                                                if let err = error {
                                                    promise(.failure(err))
                                                } else {
                                                    promise(.success(()))
                                                }
                                            }
                                        }
                                    }
                                })
                                
                                

                            } else {
                                promise(.failure(NSError(domain: "Invalid User ID", code: 0, userInfo: nil)))
                            }
                        }

                        

                        
                    }
                
                // MARK: - Previous Code Valide
                
                // Initialize the authentication
//                Auth.auth()
//                    // Set the creation of a new user
//                    .createUser(withEmail: details.email, password: details.password) { res, error in
//                        if let err = error {
//                            promise(.failure(err))
//                        } else {
//                            // Initialize a new uid
//                            if let uid = res?.user.uid {
//                                // Initialize the DB
//                                let db = Firestore.firestore()
//                                // Add the data in the DB for the new user created
//                                db.collection("users").document(uid).setData([
//                                    RegistrationKeys.id.rawValue: res?.user.uid ?? details.id,
//                                    RegistrationKeys.firstName.rawValue: details.firstName,
//                                    RegistrationKeys.surName.rawValue: details.surName,
//                                    RegistrationKeys.nickName.rawValue: details.nickName,
//                                    RegistrationKeys.extNickName.rawValue: "\(details.nickName)#\(Int.random(in: 0000..<10000))",
//                                    RegistrationKeys.profilePicture.rawValue: details.profilePicture,
//                                    RegistrationKeys.email.rawValue: details.email,
//                                    RegistrationKeys.withContact.rawValue: details.withContact
//                                ]) { error in
//                                    if let err = error {
//                                        promise(.failure(err))
//                                    } else {
//                                        promise(.success(()))
//                                    }
//                                }
//
//                            } else {
//                                promise(.failure(NSError(domain: "Invalid User ID", code: 0, userInfo: nil)))
//                            }
//                        }
//                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
