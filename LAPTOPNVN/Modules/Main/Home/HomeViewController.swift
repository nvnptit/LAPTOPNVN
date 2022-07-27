//
//  HomeViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit
import Alamofire
import SDWebImage

typealias Laptop = (id: String, name: String)
typealias Laptops = [Laptop]
let Host = "http://192.168.1.74"

enum HomeData<T> {
    case success([T])
    case fail
}

enum HomDataType {
    case banner(img: [String])
    case newItems(HomeData<LoaiSanPhamKM>)
    case hotItems(HomeData<LoaiSanPhamKM>)
    case brands(HomeData<HangSX>)
    
    case hotItemsByBrand(HomeData<LoaiSanPhamKM>)
    case empty
}

class HomeViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    fileprivate var homeData: [HomDataType] = [.empty, .empty, .empty, .empty, .empty]
    
    var maHang = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.collectionViewLayout = layout
        registerCell()
    }
    
    func registerCell(){
        homeCollectionView.register(
            UINib(nibName: "\(HomeHeaderReusableView.self)", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: UICollectionView.elementKindSectionHeader
        )
        homeCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: "Empty", withReuseIdentifier: "Empty")
        homeCollectionView.register(UINib(nibName: "SanPhamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SanPhamCollectionViewCell")
        homeCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        
        homeCollectionView.register(UINib(nibName: "HangCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HangCollectionViewCell")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.init(label: "HomeVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            self.homeData [0] = .banner(
                img: ["acer_ads","dell_ads","hp_ads","msi_ads","lenovo_ads" ]
            )
            
            APIService.getLoaiSanPhamNew(with: .getLoaiSanPhamNew, params: nil, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    self.homeData[1] = .newItems(.success(base.data ?? []))
                } else {
                    self.homeData[1] = .newItems(.fail)
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.homeCollectionView.reloadData()
                }
            })
            APIService.getLoaiSanPhamKM(with: .getLoaiSanPhamKM, params: nil, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    self.homeData[2] = .hotItems(.success(base.data ?? []))
                } else {
                    self.homeData[2] = .hotItems(.fail)
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.homeCollectionView.reloadData()
                }
            })
            //DATA HANGSX
            APIService.getHangSX(with: .getHangSX, params: nil, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    self.homeData[3] = .brands(.success(base.data ?? []))
                } else {
                    self.homeData[3] = .brands(.fail)
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.homeCollectionView.reloadData()
                }
            })
            
            let params = HangModel(maHang: self.maHang).convertToDictionary()
            APIService.getLoaiSanPhamHang(with: .getLoaiSanPhamHang, params: params, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    self.homeData[4] = .hotItemsByBrand(.success(base.data ?? []))
                } else {
                    self.homeData[4] = .hotItemsByBrand(.fail)
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.homeCollectionView.reloadData()
                }
            })
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.homeCollectionView.reloadData()
            }
        }
    }
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] (numberOfSection, env) in
            guard let self = self, self.homeData.count != 0 else { return nil }
            switch self.homeData[numberOfSection] {
                case .banner(img: let img):
                    let section = self.bannerSection
                    return section
                    
                case .newItems(laptops: let laptops):
                    let section = self.laptopSection
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(20)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .topLeading
                    )
                    header.contentInsets.leading = 16
                    header.contentInsets.trailing = 16
                    section.boundarySupplementaryItems = [
                        header
                    ]
                    return section
                    
                    
                case .hotItems(laptops: let laptops):
                    let section = self.laptopSection
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(75)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .topLeading
                    )
                    header.contentInsets.leading = 16
                    header.contentInsets.trailing = 16
                    section.boundarySupplementaryItems = [
                        header
                    ]
                    return section
                case .brands(brands: let brands):
                    let section = self.brandSection
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(30)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .topLeading
                    )
                    header.contentInsets.leading = 16
                    header.contentInsets.trailing = 16
                    section.boundarySupplementaryItems = [
                        header
                    ]
                    
                    return section
                case .hotItemsByBrand(laptops: let laptops):
                    let section = self.laptopSection
                    return section
                    
                case .empty:
                    let section = self.laptopSection
                    return section
            }
        }
    }()
    
    // Loại bỏ bất kỳ tài nguyên nào có thể được tạo lại.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var laptopSection: NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(170),
                heightDimension: .absolute(300)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets.top = 16
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private var brandSection: NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(180),
                heightDimension: .absolute(100)
            ),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    private var bannerSection: NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .absolute(370),
                heightDimension: .absolute(200)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(500),
                heightDimension: .absolute(200)
            ),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 10
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 0
        return section
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        homeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if homeData.count == 0 {
            return 0
        }
        switch homeData[section] {
            case .banner(img: let img):
                return img.count
            case .newItems(let loaiSPData):
                switch loaiSPData {
                    case .success(let loaiSP):
                        return loaiSP.count
                    case .fail:
                        return 1
                }
            case .hotItems(laptops: let laptops):
                switch laptops {
                    case .success(let loaiSP):
                        return loaiSP.count
                    case .fail:
                        return 1
                }
            case .brands(brands: let brandType):
                switch brandType {
                    case .success(let brands):
                        return brands.count
                    case .fail:
                        return 1
                }
            case .hotItemsByBrand(laptops: let itemBrandType):
                switch itemBrandType {
                    case .success(let brands):
                        return brands.count
                    case .fail:
                        return 1
                }
            case .empty:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch homeData[indexPath.section] {
                
            case .banner(img: let img):
                //BannerCollectionViewCell
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as? BannerCollectionViewCell else {fatalError()}
                let e = img[indexPath.item]
                cell.image.image = UIImage(named: e)
                return cell
                
            case .newItems(laptops: let loaiSPType):
                switch loaiSPType {
                    case .success(let loaiSP):
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SanPhamCollectionViewCell", for: indexPath) as? SanPhamCollectionViewCell else {fatalError()}
                        let e = loaiSP[indexPath.item]
                        
                        if let ten = e.tenlsp, let price = e.giamoi, let newPrice = e.giagiam , let anh = e.anhlsp, let gg = e.ptgg{
                            cell.name.text = ten
                            if (gg > 0 ){
                                cell.oldPrice.text = "\(Currency.toVND(price))"
                                cell.oldPrice.textColor = .red
                                cell.oldPrice.strikeThrough(true)
                                cell.newPrice.text = "\(Currency.toVND(newPrice))"
                            }else {
                                cell.oldPrice.text = ""
                                cell.newPrice.text =  "\(Currency.toVND(price))"
                            }
                            cell.image.loadFrom(URLAddress: Host + anh)
                        }
                        return cell
                        
                        
                    case .fail:
                        return  laptopCell(collectionView, cellForItemAt: indexPath)
                }
                
            case .hotItems(laptops: let laptops):
                switch laptops {
                    case .success(let loaiSP):
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SanPhamCollectionViewCell", for: indexPath) as? SanPhamCollectionViewCell else {fatalError()}
                        let e = loaiSP[indexPath.item]
                        if let ten = e.tenlsp, let price = e.giamoi, let newPrice = e.giagiam , let anh = e.anhlsp, let gg = e.ptgg{
                            cell.name.text = ten
                            if (gg > 0 ){
                                cell.oldPrice.text = "\(Currency.toVND(price))"
                                cell.oldPrice.textColor = .red
                                cell.oldPrice.strikeThrough(true)
                                cell.newPrice.text = "\(Currency.toVND(newPrice))"
                            }else {
                                cell.oldPrice.text = ""
                                cell.newPrice.text =  "\(Currency.toVND(price))"
                            }
                            cell.image.loadFrom(URLAddress: Host + anh)
                        }
                        return cell
                        
                        
                    case .fail:
                        return  laptopCell(collectionView, cellForItemAt: indexPath)
                }
                
            case .brands(brands: let brandType):
                switch brandType {
                    case .success(let brands):
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HangCollectionViewCell", for: indexPath) as? HangCollectionViewCell else {fatalError()}
                        let e = brands[indexPath.item]
                        cell.logo.sd_setImage(with: URL(string: e.logo ?? ""), placeholderImage: UIImage(named: "noimage"))
                        return cell
                    case .fail:
                        return  brandCell(collectionView, cellForItemAt: indexPath)
                }
                
            case .hotItemsByBrand(laptops: let laptops):
                switch laptops {
                    case .success(let loaiSP):
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SanPhamCollectionViewCell", for: indexPath) as? SanPhamCollectionViewCell else {fatalError()}
                        let e = loaiSP[indexPath.item]
                        if let ten = e.tenlsp, let price = e.giamoi, let newPrice = e.giagiam , let anh = e.anhlsp, let gg = e.ptgg{
                            cell.name.text = ten
                            if (gg > 0 ){
                                cell.oldPrice.text = "\(Currency.toVND(price))"
                                cell.oldPrice.textColor = .red
                                cell.oldPrice.strikeThrough(true)
                                cell.newPrice.text = "\(Currency.toVND(newPrice))"
                            }else {
                                cell.oldPrice.text = ""
                                cell.newPrice.text =  "\(Currency.toVND(price))"
                            }
                            cell.image.loadFrom(URLAddress: Host + anh)
                        }
                        return cell
                        
                        
                    case .fail:
                        return  laptopCell(collectionView, cellForItemAt: indexPath)
                }
                
            case .empty:
                let collectionViewCell = UICollectionViewCell()
                collectionViewCell.backgroundColor = .gray
                return collectionViewCell
        }
    }
    private func laptopCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Laptop", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    private func brandCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Brand", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionView.elementKindSectionHeader, for: indexPath) as? HomeHeaderReusableView else { return UICollectionReusableView() }
        header.delegate = self
        header.indexPath = indexPath
        switch indexPath.section {
            case 0:
                break
            case 1:
                header.title.text = "Sản phẩm mới nhất"
            case 2:
                header.title.text = "Khuyến mãi khủng"
            case 3:
                header.title.text = "Sản phẩm deal tốt"
                header.btnSeemore.setTitle("", for: .normal)
            default:
                return UICollectionReusableView()
        }
        return header
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch homeData[indexPath.section] {
            case .banner(img: let img):
                break 
            case .newItems(let loaispWrap):
                switch loaispWrap {
                    case .success(let loaiSp):
                        let item = loaiSp[indexPath.item]
                        let detailSPViewController = DetailSanPhamViewController()
                        detailSPViewController.loaiSp = item
                        self.navigationController?.pushViewController(detailSPViewController, animated: true)
                    case .fail:
                        break
                }
            case .hotItems(laptops: let laptops):
                switch laptops {
                    case .success(let loaiSp):
                        let item = loaiSp[indexPath.item]
                        let detailSPViewController = DetailSanPhamViewController()
                        detailSPViewController.loaiSp = item
                        self.navigationController?.pushViewController(detailSPViewController, animated: true)
                    case .fail:
                        break
                }
            case .brands(brands : let brandSwrap):
                switch brandSwrap {
                    case .success(let brand):
                        let item = brand[indexPath.item]
                        if let maHang = item.mahang {
                            self.maHang = maHang
                        }
                        
                        let params = HangModel(maHang: self.maHang).convertToDictionary()
                        APIService.getLoaiSanPhamHang(with: .getLoaiSanPhamHang, params: params, headers: nil, completion: { [weak self] base, error in
                            guard let self = self, let base = base else { return }
                            if base.success == true {
                                self.homeData[4] = .hotItemsByBrand(.success(base.data ?? []))
                            } else {
                                self.homeData[4] = .hotItemsByBrand(.fail)
                            }
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                self.homeCollectionView.reloadData()
                            }
                        })
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.homeCollectionView.reloadData()
                        }
                    case .fail:
                        break
                }
            case .hotItemsByBrand(laptops: let laptops):
                switch laptops {
                    case .success(let loaiSp):
                        let item = loaiSp[indexPath.item]
                        let detailSPViewController = DetailSanPhamViewController()
                        detailSPViewController.loaiSp = item
                        self.navigationController?.pushViewController(detailSPViewController, animated: true)
                    case .fail:
                        break
                        
                }
            case .empty:
                break
        }
    }
}

extension HomeViewController: HomeHeaderResuableViewDelegate {
    func homeHeader(_ homeHeader: HomeHeaderReusableView, seeMore sender: UIButton, indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                break
            case 1:
                let listLaptopViewController = ListLaptopViewController()
                listLaptopViewController.typeHome = "Full"
                self.navigationController?.pushViewController(listLaptopViewController, animated: true)
            case 2:
                let listLaptopViewController = ListLaptopViewController()
                listLaptopViewController.typeHome = "KM"
                self.navigationController?.pushViewController(listLaptopViewController, animated: true)
            case 3:
                let listLaptopViewController = ListLaptopViewController()
                listLaptopViewController.typeHome = "Full"
                self.navigationController?.pushViewController(listLaptopViewController, animated: true)
            default:
                break;
        }
    }
}
extension HomeViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}
