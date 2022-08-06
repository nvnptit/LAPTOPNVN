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
    public var infoNV: ModelNV?
    public var cmnd: String = ""
    public var maNV: String = ""

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
extension UserService{
    //Nhan vien
    
    func setInfoNV(with data: ModelNV?){
        guard let info = data else {return}
        self.infoNV = info
        if let maNV = info.manv {
            self.maNV = maNV
        }
    }
    func getInfoNV() -> ModelNV?{
        return self.infoNV
    }
    func removeAllNV() {
        self.infoNV = nil
        self.maNV = ""
    }
}
