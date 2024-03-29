//
//  APIService.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation
import Alamofire


struct APIService {
//        static let baseUrl: String = "http://192.168.1.34"
//    static let baseUrl: String = "http://172.20.10.7"
    static let baseUrl: String = "http://dotnet.voz.ee"
    
    public static func fetchDataImportExportLSP(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[DataImportExport]>?, String?) -> ()) {
        APIController.request(ResponseBase<[DataImportExport]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }

    public static func fetchAllStatusOrder(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[DataPieResponse]>?, String?) -> ()) {
        APIController.request(ResponseBase<[DataPieResponse]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //Get Order By CMND
    //get -> fetch
    public static func getHistoryOrderCMND(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[HistoryOrderCMND]>?, String?) -> ()) {
        APIController.request(ResponseBase<[HistoryOrderCMND]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //Get Ward
    public static func getWards(with code: Int, _ completion: @escaping(Ward?, String?) -> ()) {  APIController.requestGET(Ward.self, .getWard(code) ) { error, data in
        if let data = data {
            completion(data,nil)
            return
        }
        completion(nil, error)
    }
    }
    //Get District
    public static func getDistricts(with code: Int, _ completion: @escaping(District?, String?) -> ()) {  APIController.requestGET(District.self, .getDistrict(code) ) { error, data in
        if let data = data {
            completion(data,nil)
            return
        }
        completion(nil, error)
    }
    }
    
    //Get Province
    public static func getProvince(_ completion: @escaping([ProvinceElement]?, String?) -> ()) {  APIController.requestGET([ProvinceElement].self, .getProvince ) { error, data in
        if let data = data {
            completion(data,nil)
            return
        }
        completion(nil, error)
    }
    }
    
    //Get rate by RateList
    public static func getRateList(with seri:String, _ completion: @escaping(ResponseBase<[RateListResponse]>?, String?) -> ()) {  APIController.requestGET(ResponseBase<[RateListResponse]>.self, .getListRate(seri) ) { error, data in
        if let data = data {
            completion(data,nil)
            return
        }
        completion(nil, error)
    }
    }
    
    //Get rate by serial
    public static func getRateBySerial(with seri:String, _ completion: @escaping(Response?, String?) -> ()) {  APIController.requestGET(Response.self, .getRateBySeri(seri) ) { error, data in
        if let data = data {
            completion(data,nil)
            return
        }
        completion(nil, error)
    }
    }
    // Delete CTGG
    public static func delCTGG(with maLSP:String ,maDot: String, _ completion: @escaping(Response?, String?) -> ()) {  APIController.requestGET(Response.self, .delDetailSale(maLSP, maDot) ) { error, data in
        if let data = data {
            completion(data,nil)
            return
        }
        completion(nil, error)
    }
    }
    
    //Get with Param Method
    static func getCTGG(with maDot: String, _ completion: @escaping(ResponseBase<[ResponseDetailSale]>?, String?) -> ()) {
        APIController.requestGET(ResponseBase<[ResponseDetailSale]>.self, .getDetailSale(maDot)) {  error,base in
            if let base = base {
                completion(base,nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    public static func postRequest(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    public static func getDotGG(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[Sale]>?, String?) -> ()) {
        APIController.request(ResponseBase<[Sale]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func getPhieuNhap(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[PhieuNhap]>?, String?) -> ()) {
        APIController.request(ResponseBase<[PhieuNhap]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func getSLSeri(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[SLSERI]>?, String?) -> ()) {
        APIController.request(ResponseBase<[SLSERI]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func delTK1(with tenDangNhap: String, _ completion: @escaping(Response?, String?) -> ()) {  APIController.requestGET(Response.self, .delTK1(tenDangNhap)) { error, data in
        if let data = data {
            completion(data,nil)
            return
        }
        completion(nil, error)
    }
    }
    
    //Get with Param Method
    static func getSLLSP(with maLSP: String, _ completion: @escaping(ResponseSL?, String?) -> ()) {
        APIController.requestGET(ResponseSL.self, .getSoLuongLSP(maLSP)) { error, data in
            if let data = data {
                completion(data,nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    public static func postLSP(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func getTyGia(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[TyGiaResponse]>?, String?) -> ()) {
        APIController.request(ResponseBase<[TyGiaResponse]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func getSanPham(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[SanPham]>?, String?) -> ()) {
        APIController.request(ResponseBase<[SanPham]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func updateQuyenKichHoat(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func getQuyen(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[QuyenResponse]>?, String?) -> ()) {
        APIController.request(ResponseBase<[QuyenResponse]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    public static func getMaSo(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[MaSoResponse]>?, String?) -> ()) {
        APIController.request(ResponseBase<[MaSoResponse]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func getNhanVien(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[ModelNVResponseAD]>?, String?) -> ()) {
        APIController.request(ResponseBase<[ModelNVResponseAD]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    public static func postNhanVien(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    public static func postHangSX(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    //get -> fetch
    public static func getOrderShipper(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[HistoryOrder1]>?, String?) -> ()) {
        APIController.request(ResponseBase<[HistoryOrder1]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func uploadAvatar(with manager: APIManager, image: UIImage?, completion: @escaping(Response?, String?) -> ()) {
        guard let image = image else {
            return
        }
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "fileUpload" , fileName: "file.jpeg", mimeType: "image/jpeg")
        },
                  to: manager.url, method: manager.method , headers: APIHeader.multipartFormData())
        .responseData { response in
            
            switch response.result {
                case .success(let data):
                    JSONDecoder.decode(Response.self, from: data) { error, reponse in
                        completion(reponse, nil)
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    //get -> fetch
    public static func getDoanhThu(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[DoanhThuResponse]>?, String?) -> ()) {
        APIController.request(ResponseBase<[DoanhThuResponse]>.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getNVDG(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[EmployeeModel]>?, String?) -> ()) {
        APIController.request(ResponseBase<[EmployeeModel]>.self, manager, params: params, headers: headers) { error, data in
            if let dataNV = data {
                completion(dataNV, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getHistoryOrder1(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[HistoryOrder1]>?, String?) -> ()) {
        APIController.request(ResponseBase<[HistoryOrder1]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getDetailHistoryOrder1(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[HistoryOrder1Detail]>?, String?) -> ()) {
        APIController.request(ResponseBase<[HistoryOrder1Detail]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    //get -> fetch
    public static func getHistoryOrder(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[HistoryOrder]>?, String?) -> ()) {
        APIController.request(ResponseBase<[HistoryOrder]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    public static func postRegisterKH(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func postUserKH(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func updateUserKH(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    //
    //    public static func delTK(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
    //        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
    //            if let data = data {
    //                completion(data, nil)
    //                return
    //            }
    //            completion(nil, error)
    //        }
    //    }
    
    public static func delTK2(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func postLogin(with manager: APIManager, _ params: [String: Any], _ headers: HTTPHeaders?, completion: @escaping(ResponseBase<LoginRes>?, String?) -> ()) {
        APIController.request(ResponseBase<LoginRes>.self, manager, params: params, headers: headers) { error, data in
            if let dataLogin = data {
                completion(dataLogin, nil)
                return
            }
            completion(nil, error)
        }
    }
    //get -> fetch
    public static func getLoaiSanPhamFull(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    //get -> fetch
    public static func getLoaiSanPhamNew(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getLoaiSanPhamKM(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getLoaiSanPhamGood(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func getLoaiSanPhamHang(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    //get -> fetch
    public static func searchLoaiSanPham(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[LoaiSanPhamKM]>?, String?) -> ()) {
        APIController.request(ResponseBase<[LoaiSanPhamKM]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    //get -> fetch
    public static func getGioHang(with manager: APIManager,  params: Parameters?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[GioHangData]>?, String?) -> ()) {
        APIController.request(ResponseBase<[GioHangData]>.self, manager, params: params, headers: headers) { error, data in
            if let dataLoaiSanPham = data {
                completion(dataLoaiSanPham, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
    public static func addGioHang1(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(Response?, String?) -> ()) {
        APIController.request(Response.self, manager, params: params, headers: headers) { error, data in
            if let dataGioHang = data {
                completion(dataGioHang, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    //get -> fetch
//    public static func addGioHangC(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(GioHangResponse?, String?) -> ()) {
//        APIController.request(GioHangResponse.self, manager, params: params, headers: headers) { error, data in
//            if let dataLoaiSanPham = data {
//                completion(dataLoaiSanPham, nil)
//                return
//            }
//            completion(nil, error)
//        }
//    }
    
    //get -> fetch
    public static func updateGioHang(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(GioHangResponse?, String?) -> ()) {
        APIController.request(GioHangResponse.self, manager, params: params, headers: headers) { error, data in
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    
    
    //get -> fetch
    public static func deleteGioHang(with manager: APIManager,  params: Parameters?,  headers: HTTPHeaders?, completion: @escaping(GioHangResponse?, String?) -> ()) {
        APIController.request(GioHangResponse.self, manager, params: params, headers: headers) { error, data in
            if let dataL = data {
                completion(dataL, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    public static func getHangSX(with manager: APIManager,  params: [String: Any]?,  headers: HTTPHeaders?, completion: @escaping(ResponseBase<[HangSX]>?, String?) -> ()) {
        APIController.request(ResponseBase<[HangSX]>.self, manager, params: params, headers: headers) { error, data in
            if let dataHangSX = data {
                completion(dataHangSX, nil)
                return
            }
            completion(nil, error)
        }
    }
    
}


