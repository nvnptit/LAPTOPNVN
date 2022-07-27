//
//  UserService.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation

class UserService {
    
    static let shared = UserService()
     
    private init() { }
    
    public var infoProfile: LoginResponse?
    public var cmnd: String = ""

    func setInfo(with data: LoginResponse?){
        guard let info = data else {return}
        self.infoProfile = info
        if let cmnd = info.cmnd {
            self.cmnd = cmnd
        }
    }
    func getInfo() -> LoginResponse?{
        return self.infoProfile
    }
    func removeAll() {
        self.infoProfile = nil
        self.cmnd = ""
    }
}
