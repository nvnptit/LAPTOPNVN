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
    public var listHang: [HangSX]?
    
    public var infoProfile: LoginResponse?
    public var infoNV: ModelNVResponse?
    public var cmnd: String = ""
    public var maNV: String = ""
    public var listGH: [GioHangL] = []
    public var list: [LoaiSanPhamKM?] = []
}

struct GioHangL : Decodable{
    let id: String
    let malsp: String?
    let tenlsp: String?
    let soluong: Int?
    let anhlsp: String?
    let mota: String?
    let cpu: String?
    let ram: String?
    let harddrive: String?
    let cardscreen: String?
    let os: String?
    let mahang: Int?
    let isnew: Bool?
    let isgood: Bool?
    let giamoi: Int?
    let ptgg: Int?
    let giagiam: Int?
}

extension UserService{
    //Danh sach gio hang
    
     func addOrder(with data: LoaiSanPhamKM?){
         guard let item = data else {return}
         listGH.append(GioHangL(id: UUID().uuidString, malsp: item.malsp, tenlsp: item.tenlsp, soluong: item.soluong, anhlsp: item.anhlsp, mota: item.mota, cpu: item.cpu, ram: item.ram, harddrive: item.harddrive, cardscreen: item.cardscreen, os: item.os, mahang: item.mahang, isnew: item.isnew, isgood: item.isgood, giamoi: item.giamoi, ptgg: item.ptgg, giagiam: item.giagiam))
     }
    func removeOrder(with data: GioHangL){
        self.listGH = self.listGH.filter { $0.id != data.id }
    }
    func getlistGH1() -> [LoaiSanPhamKM?]{
        list.removeAll()
            for item in listGH{
                list.append(LoaiSanPhamKM(malsp: item.malsp, tenlsp: item.tenlsp, soluong: item.soluong, anhlsp: item.anhlsp, mota: item.mota, cpu: item.cpu, ram: item.ram, harddrive: item.harddrive, cardscreen: item.cardscreen, os: item.os, mahang: item.mahang, isnew: item.isnew, isgood: item.isgood, giamoi: item.giamoi, ptgg: item.ptgg, giagiam: item.giagiam))
            }
            return list
        return []
    }
    func getlistGH() -> [GioHangL]{
        return self.listGH
    }
    func removeAllGH() {
        self.listGH.removeAll()
    }
}

extension UserService{
    //Khach Hang
   
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
    //Quyen
    
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
//
//extension UserService{
//    //Hangsx
//    
//    func setListHang(with data: [HangSX]?){
//        guard let data = data else {return}
//        self.listHang = data
//    }
//    func getListHang() -> [HangSX]?{
//        return self.listHang
//    }
//    func removeAllHang() {
//        self.listQuyen = nil
//    }
//}
