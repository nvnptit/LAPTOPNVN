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
    
    public var listGH2: [Orders] = []
    public var list2: [LoaiSanPhamKM] = []
    
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
class Orders: Decodable{
    init( data: LoaiSanPhamKM?,sl: Int) {
        self.data = data
        self.sl = sl
    }
    var data: LoaiSanPhamKM?
    var sl: Int
}

extension UserService{
    //Danh sach gio hang 2
    func addOrder2(with data: LoaiSanPhamKM?){
        var k = true
        for item in listGH2{
            if (item.data?.malsp == data?.malsp){
                item.sl += 1
                k = false
            }
        }
        if (k) {
            listGH2.append(Orders(data: data, sl: 1))
        }
    }
    func putOrder2( order: Orders,k: Int){
        for item in listGH2{
            if (item.data?.malsp == order.data?.malsp){
                if (k == 0){
                    item.sl -= 1}
                else {
                    item.sl += 1
                }
            }
        }
    }
    func removeOrder2(with data:LoaiSanPhamKM?){
        self.listGH2 = self.listGH2.filter { $0.data?.malsp != data?.malsp }
    }
    func getlistGH2(){
        print("\n-------------")
        for item in listGH2{
            print(item.data)
            print(item.sl)
        }
        print("\n-------------")
    }
    func getlistGH() -> [Orders]{
        return self.listGH2
    }
    
    func removeAllGH2() {
        self.listGH2.removeAll()
    }
    func toListGH() -> [LoaiSanPhamKM]{
        list2.removeAll()
        for item in listGH2{
            if let data = item.data {
                for _ in 0 ..< item.sl{
                    list2.append(data)
                }
            }
        }
        return list2
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
