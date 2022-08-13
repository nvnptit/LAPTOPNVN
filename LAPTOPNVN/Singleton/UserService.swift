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
    public var listQuyen: [QuyenResponse]?
    public var infoProfile: LoginResponse?
    public var infoNV: ModelNVResponse?
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
    
    func setInfoNV(with data: ModelNVResponse?){
        guard let info = data else {return}
        self.infoNV = info
        if let maNV = info.manv {
            self.maNV = maNV
        }
    }
    func getInfoNV() -> ModelNVResponse?{
        return self.infoNV
    }
    func removeAllNV() {
        self.infoNV = nil
        self.maNV = ""
    }
}

extension UserService{
    //Nhan vien
    
    func setListQuyen(with data: [QuyenResponse]?){
        guard let data = data else {return}
        self.listQuyen = data
    }
    func getListQuyen() -> [QuyenResponse]?{
        return self.listQuyen
    }
    func removeAllQuyen() {
        self.listQuyen = nil
    }
}
