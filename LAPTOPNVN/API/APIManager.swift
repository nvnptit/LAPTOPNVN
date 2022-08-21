//
//  APIManager.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation
import Alamofire

enum APIManager {
    case login
    case register
    case resetPass
    
    case addGioHang1
    case getDetailHistory
    case getTyGia
    
    case getQuyen
    case getMaSoNV
    case getMaSoLSP
    case putQuyenKichHoat
    
    case addUserKH
    case updateUserKH
    
    case getHangSX
    case postHangSX
    case putHangSX
    case delHangSX
    
    case getNV
    case postNV
    case putNV
    case delNV
    
    case getSP
    case postSP
    case putSP
    case delSP
    
    case postLSP
    case putLSP
    case delLSP
    
    case getLoaiSanPhamFull
    case getLoaiSanPhamNew
    case getLoaiSanPhamKM
    case getLoaiSanPhamGood
    case getLoaiSanPhamHang
    case searchLSP
    case delTK
    
    case getNVDuyet
    case getNVGiao
    
    case addGioHang
    case getGioHang
    case updateGioHang
    case updateGioHangAdmin
    case deleteGioHang
    
    case getHistoryOrder
    case getDoanhThu
    case uploadAvatar
    case getOrderShipper
    case putOrderShipper
    
}

extension APIManager {
    var baseURL: String  { return "\(APIService.baseUrl)/api"}
    //MARK: - URL
    var url: String {
        var path = ""
        //        let version = "/v1"
        switch self {
            case .login: path = "/tai-khoan/login"
            case .register: path = "/tai-khoan"
            case .resetPass: path = "/tai-khoan/thay-matkhau"
                
            case .addGioHang1: path = "/gio-hang/them-gh"
            case .getDetailHistory: path = "/gio-hang/history-detail-order"
            case .getTyGia: path = "/ty-gia"
                
            case .getQuyen: path = "/quyen"
            case .getMaSoNV: path = "/nhan-vien/MANV"
            case .getMaSoLSP: path = "/loai-san-pham/MALSP"
            case .putQuyenKichHoat: path = "/tai-khoan/Quyen"
                
            case .getHangSX:
                path = "/hang-sx"
            case .postHangSX:
                path = "/hang-sx"
            case .putHangSX:
                path = "/hang-sx"
            case .delHangSX:
                path = "/hang-sx"
                
                
            case .getNV:
                path = "/nhan-vien"
            case .postNV:
                path = "/nhan-vien"
            case .putNV:
                path = "/nhan-vien"
            case .delNV:
                path = "/nhan-vien"
                
            case .getSP:
                path = "/san-pham"
            case .postSP:
                path = "/san-pham"
            case .putSP:
                path = "/san-pham"
            case .delSP:
                path = "/san-pham"
                
                
            case .postLSP:
                path = "/loai-san-pham"
            case .putLSP:
                path = "/loai-san-pham"
            case .delLSP:
                path = "/loai-san-pham"
                
             
                
                
            case .getLoaiSanPhamFull:
                path = "/loai-san-pham"
            case .getLoaiSanPhamNew:
                path = "/loai-san-pham/get-new-lsp"
            case .getLoaiSanPhamKM:
                path = "/loai-san-pham/get-km-lsp"
            case .getLoaiSanPhamGood:
                path = "/loai-san-pham/get-good-lsp"
            case .getLoaiSanPhamHang:
                path = "/loai-san-pham/get-good-lsp-hang"
                
            case .searchLSP:
                path = "/loai-san-pham/search"
                
            case .getGioHang: path = "/gio-hang/gio-hang-byKH"
            case .addGioHang: path = "/gio-hang"
            case .updateGioHang: path = "/gio-hang"
            case .deleteGioHang: path = "/gio-hang"
            case .updateGioHangAdmin: path = "/gio-hang/admin"
                
            case .addUserKH: path = "/khach-hang"
            case .updateUserKH: path = "/khach-hang"
                
            
            
            case .getHistoryOrder: path = "/gio-hang/history-order"
            case .delTK: path = "/tai-khoan"
                
            case .getNVDuyet:
                path = "/nhan-vien/NV-Duyet"
            case .getNVGiao:
                path = "/nhan-vien/NV-Giaohang"
                
            case .getDoanhThu:
                path = "/gio-hang/doanh-thu"
            case .uploadAvatar:
                path = "/loai-san-pham/uploadPicture"
            case .getOrderShipper:
                path = "/gio-hang/order-shipper"
            case .putOrderShipper:
                path = "/gio-hang/shipper"
        }
        return baseURL + path
    }
    
    //MARK: - METHOD
    var method: HTTPMethod {
        switch self {
            case   .getLoaiSanPhamFull, .getLoaiSanPhamNew,
                    .getGioHang, .getLoaiSanPhamKM, .getLoaiSanPhamGood, .getLoaiSanPhamHang, .searchLSP,
                    .getHistoryOrder, .getNVGiao, .getNVDuyet , .getDoanhThu, .getOrderShipper,
                    .getHangSX, .getNV, .getSP,
                    .getMaSoNV, .getMaSoLSP, .getQuyen, .getTyGia,
                    .getDetailHistory
                :
                return .get
            case .login, .register, .resetPass, .addGioHang, .addUserKH, .uploadAvatar,
                    .postHangSX, .postNV, .postLSP, .postSP,
                    .addGioHang1
                :
                return .post
            case .updateGioHang, .updateUserKH,.updateGioHangAdmin, .putOrderShipper,
                    .putHangSX, .putNV, .putLSP, .putSP,
                    .putQuyenKichHoat
                :
                return .put
            case .deleteGioHang, .delTK,
                    .delHangSX, .delNV, .delLSP, .delSP:
                return .delete
                
        }
    }
    
    //MARK: - HEADER
    var header: HTTPHeader? {
        switch self {
            default:
                return nil
        }
    }
    
    //MARK: - ENCODING
    
    var encoding: ParameterEncoding {
        switch self.method {
            case .post, .put:
                return JSONEncoding.default
            case .get:
                return URLEncoding.default
            default:
                return URLEncoding.default
        }
    }
}
struct Header {
    static let authorization            = "Authorization"
    static let contentType              = "Content-Type"
    static let contentTypeValue         = "application/json"
}

