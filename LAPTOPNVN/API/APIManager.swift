//
//  APIManager.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation
import Alamofire

enum APIManager {
    case findImageText
    case login
    case register
    case resetPass
    
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
    
    case getDotGG
    case postDotGG
    case putDotGG
    case delDotGG
    case getMaSoDGG
    
    case getDetailSale(String)
    case postDetailSale
    case putDetailSale
    case delDetailSale(String,String)
    
    
    case getNV
    case postNV
    case putNV
    case delNV
    
    case getSP
    case postSP
    case putSP
    case delSP
    
    case getSLSeri
    case getPhieuNhap
    
    case postLSP
    case putLSP
    case delLSP
    
    case getSoLuongLSP(String)
    case getLoaiSanPhamFull
    case getLoaiSanPhamNew
    case getLoaiSanPhamKM
    case getLoaiSanPhamGoodHang
    case getLoaiSanPhamHang
    case searchLSP
    case delTK
    case delTK1(String)
    
    case getNVDuyet
    case getNVGiao
    
    case getAllStatusOrder
    case getAllStatusOrderByDate
    case importExportLSP
    
    case addGioHang1
    case getGioHang
    case updateGioHang
    case updateGioHangAdmin
    case deleteGioHang
    
    case getHistoryOrder
    case getHistoryOrderCMND
    case getDoanhThu
    case uploadAvatar
    case getOrderShipper
    case putOrderShipper
    
    case getRate
    case getRateBySeri(String)
    case getListRate(String)
    case postRate
    case putRate
    
    case postForgotPassword
    case getProvince
    case getDistrict(Int)
    case getWard(Int)
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
            case .postForgotPassword: path = "/tai-khoan/forgot-pass"
                
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
                
            case .getSLSeri:
                path = "/san-pham/SL-SERI"
            case .getPhieuNhap:
                path = "/phieu-nhap"
                
                
            case .postLSP:
                path = "/loai-san-pham"
            case .putLSP:
                path = "/loai-san-pham"
            case .delLSP:
                path = "/loai-san-pham"
                
                
                
            case .getSoLuongLSP(let maLSP):
                path = "/loai-san-pham/LSP?maLSP=\(maLSP)"
            case .getLoaiSanPhamFull:
                path = "/loai-san-pham"
            case .getLoaiSanPhamNew:
                path = "/loai-san-pham/get-new-lsp"
            case .getLoaiSanPhamKM:
                path = "/loai-san-pham/get-km-lsp"
            case .getLoaiSanPhamGoodHang:
                path = "/loai-san-pham/get-good-lsp-hang"
            case .getLoaiSanPhamHang:
                path = "/loai-san-pham/get-lsp-hang"
                
            case .searchLSP:
                path = "/loai-san-pham/search"
                
            case .getGioHang: path = "/gio-hang/gio-hang-byKH"
//            case .addGioHang: path = "/gio-hang"
            case .updateGioHang: path = "/gio-hang"
            case .deleteGioHang: path = "/gio-hang"
            case .updateGioHangAdmin: path = "/gio-hang/admin"
                
            case .addUserKH: path = "/khach-hang"
            case .updateUserKH: path = "/khach-hang"
                
                //MARK: - DOTGIAMGIA
            case .getDotGG:
                path = "/dot-gg"
            case .postDotGG:
                path = "/dot-gg"
            case .putDotGG:
                path = "/dot-gg"
            case .delDotGG:
                path = "/dot-gg"
            case .getMaSoDGG: path = "/dot-gg/MADGG"
                
            case .getDetailSale(let maDot): path = "/dot-gg/CHI-TIET?maDot=\(maDot)"
            case .postDetailSale: path = "/dot-gg/CHI-TIET"
            case .putDetailSale: path = "/dot-gg/CHI-TIET"
            case .delDetailSale(let maLSP,let maDot): path = "/dot-gg/CHI-TIET?malsp=\(maLSP)&madotgg=\(maDot)"
                
            case .getHistoryOrder: path = "/gio-hang/history-order"
            case .getHistoryOrderCMND: path = "/gio-hang/history-order-cmnd"
            case .delTK: path = "/tai-khoan"
            case .delTK1(let tenDangNhap): path = "/tai-khoan?tenDangNhap=\(tenDangNhap)"
                
            case .getNVDuyet:
                path = "/nhan-vien/NV-Duyet"
            case .getNVGiao:
                path = "/nhan-vien/NV-Giaohang"
                
            case .getAllStatusOrder:
                path = "/gio-hang/allStatusDH"
            case .getAllStatusOrderByDate:
                path = "/gio-hang/allStatusDHByDate"
            case .importExportLSP:
                path = "/gio-hang/importExportLSP"
                
            case .getDoanhThu:
                path = "/gio-hang/doanh-thu"
            case .uploadAvatar:
                path = "/loai-san-pham/uploadPicture"
            case .getOrderShipper:
                path = "/gio-hang/order-shipper"
            case .putOrderShipper:
                path = "/gio-hang/shipper"
                
                //MARK: - DOTGIAMGIA
            case .getRate:
                path = "/binh-luan"
            case .getRateBySeri(let seri):
                path = "/binh-luan?seri=\(seri)"
            case .postRate:
                path = "/binh-luan"
            case .putRate:
                path = "/binh-luan"
            case .getListRate(let maLSP):
                path = "/binh-luan/SANPHAM?maLSP=\(maLSP)"
            case .getProvince:
                do {
                    path = "https://provinces.open-api.vn/api/p?depth=2"
                    return path
                }
            case .getDistrict(let code):
                do {
                    path = "https://provinces.open-api.vn/api/p/\(code)?depth=2"
                    return path
                }
            case .getWard(let code):
                do {
                    path = "https://provinces.open-api.vn/api/d/\(code)?depth=2"
                    return path
                }
            case .findImageText :
                do {
                    path = "https://api.apilayer.com/image_to_text/url?url="
                    return path
                }
        }
        return baseURL + path
    }
    
    //MARK: - METHOD
    var method: HTTPMethod {
        switch self {
            case   .getLoaiSanPhamFull, .getLoaiSanPhamNew,
                    .getGioHang, .getLoaiSanPhamKM, .getLoaiSanPhamGoodHang, .getLoaiSanPhamHang, .searchLSP,
                    .getHistoryOrder, .getNVGiao, .getNVDuyet , .getDoanhThu, .getOrderShipper,
                    .getHangSX, .getNV, .getSP,
                    .getMaSoNV, .getMaSoLSP, .getQuyen, .getTyGia,
                    .getDetailHistory, .getSoLuongLSP,
                    .getSLSeri, .getPhieuNhap,
                    .getDotGG, .getMaSoDGG, .getDetailSale, .getRate, .getRateBySeri, .getListRate,
                    .getProvince, .getWard, .getDistrict,
                    .getHistoryOrderCMND, .findImageText,
                    .getAllStatusOrder, .getAllStatusOrderByDate, .importExportLSP
                :
                return .get
            case .login, .register, .resetPass, .addUserKH, .uploadAvatar,
                    .postHangSX, .postNV, .postLSP, .postSP,
                    .addGioHang1,
                    .postDotGG, .postDetailSale, .postRate,
                    .postForgotPassword
                :
                return .post
            case .updateGioHang, .updateUserKH,.updateGioHangAdmin, .putOrderShipper,
                    .putHangSX, .putNV, .putLSP, .putSP,
                    .putQuyenKichHoat,
                    .putDotGG, .putDetailSale, .putRate
                :
                return .put
            case .deleteGioHang, .delTK, .delTK1,
                    .delHangSX, .delNV, .delLSP, .delSP,
                    .delDotGG, .delDetailSale
                :
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

