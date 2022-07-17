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
//    
//    public var infoProfile: ProfileResponse?
//    public var shift: ShiftResponse?
//    public var workspace: WorkspaceResponse?
//    private var tokenLogin: String?
//    private var currentPassword: String?
//    private var latitude: Double?
//    private var longitude: Double?
//
//    func setWorkspace(with data: WorkspaceResponse?){
//        guard let workspace = data else {return}
//        self.workspace = workspace
//    }
//    func getWorkspace() -> WorkspaceResponse?{
//        return self.workspace
//    }
//    
//    func setLocationWorkspace(lat: Double?, long: Double?) {
//        self.latitude = lat
//        self.longitude = long
//    }
//    
//    func getLongtitudeWorkspace() -> Double? {
//        return self.longitude
//    }
//    
//    func getLatitudeWorkspace() -> Double? {
//        return self.latitude
//    }
//    
//    func setInfoProfile(with data: ProfileResponse?) {
//        guard let infoProfile = data else { return }
//        self.infoProfile = infoProfile
//    }
//    
//    func setPhoneProfile(with phone: String?) {
//        guard let data = phone else { return }
//        self.infoProfile?.phone = data
//    }
//    
//    func setTokenLogin(with data: String?) {
//        guard let token = data else { return }
//        UserDefaults.standard.setValue(token, for: .tokenLogin)
//        self.tokenLogin = token
//    }
//    
//    func setCurrentPassword(with password: String?) {
//        guard let password = password else { return }
//        UserDefaults.standard.setValue(password, for: .currentPassword)
//        self.currentPassword = password
//    }
//    
//    func getTokenLogin() -> String? {
//        return self.tokenLogin
//    }
//    
//    func getInfoProfile() -> ProfileResponse? {
//        guard let infoProfile = infoProfile else {
//            return nil
//        }
//        return infoProfile
//    }
//    
//    func getCurrentPassword() -> String? {
//        guard let currentPassword = currentPassword else {
//            return nil
//        }
//        return currentPassword
//    }
//    
//    func removeData() {
//        tokenLogin = nil
//        currentPassword = nil
//        infoProfile = nil
//        shift = nil
//        longitude = nil
//        latitude = nil
//        UserDefaults.standard.removeValue(for: .tokenLogin)
//        UserDefaults.standard.removeValue(for: .currentPassword)
//    }
//    
//    func setShift(with data: ShiftResponse?) {
//        guard let dataShift = data else { return }
//        self.shift = dataShift
//    }
//    
//    func getShift() -> ShiftResponse? {
//        guard let dataShift = shift else {
//            return nil }
//        return dataShift
//    }
}
