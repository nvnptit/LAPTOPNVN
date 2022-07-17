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
typealias Brand = (id: String, name: String)
typealias Brands = [Brand]

enum HomeData<T> {
    case success([T])
    case fail
}

enum HomDataType {
    case newItems(HomeData<LoaiSanPham>)
    case hotItems(laptops: Laptops)
    case brands(brands: Brands)
    case hotItemsByBrand(laptops: Laptops)
    case empty
}

class HomeViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    fileprivate var homeData: [HomDataType] = [.empty, .empty, .empty, .empty]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        homeCollectionView.dataSource = self
        homeCollectionView.collectionViewLayout = layout
        homeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Laptop")
        homeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Brand")
        homeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Empty")
        homeCollectionView.register(
            UINib(nibName: "\(HomeHeaderReusableView.self)", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: UICollectionView.elementKindSectionHeader
        )
        homeCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: "Empty", withReuseIdentifier: "Empty")
        homeCollectionView.register(UINib(nibName: "SanPhamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SanPhamCollectionViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.init(label: "HomeVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            APIService.getLoaiSanPham(with: .getLoaiSanPham, params: nil, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    self.homeData[0] = .newItems(.success(base.data ?? []))
                } else {
                    self.homeData[0] = .newItems(.fail)
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.homeCollectionView.reloadData()
                }
            })
            self.homeData [1] = .hotItems(
                laptops: [
                    (id: "Laptop1", name: "laptop1"),
                    (id: "Laptop2", name: "laptop2"),
                    (id: "Laptop3", name: "laptop3")
                ]
            )
            self.homeData[2] =  .brands(
                brands: [
                    (id: "Brand1", name: "Brand1"),
                    (id: "Brand2", name: "Brand2"),
                    (id: "Brand3", name: "Brand3")
                ])
            self.homeData[3] =   .hotItemsByBrand(
                laptops: [
                    (id: "Laptop1", name: "laptop1"),
                    (id: "Laptop2", name: "laptop2"),
                    (id: "Laptop3", name: "laptop3")
                ]
            )
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
                case .newItems(laptops: let laptops):
                    let section = self.laptopSection
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(70)
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
                case .hotItemsByBrand(laptops: let laptops):
                    let section = self.laptopSection
                    return section
                case .empty:
                    let section = self.laptopSection
//                    let header = NSCollectionLayoutBoundarySupplementaryItem(
//                        layoutSize: .init(
//                            widthDimension: .fractionalWidth(1),
//                            heightDimension: .absolute(75)
//                        ),
//                        elementKind: UICollectionView.elementKindSectionHeader,
//                        alignment: .topLeading
//                    )
//                    header.contentInsets.leading = 16
//                    header.contentInsets.trailing = 16
//                    section.boundarySupplementaryItems = [
//                        header
//                    ]
                    return section
            }
        }
    }()
    
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
//        section.interGroupSpacing = 16
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
                widthDimension: .absolute(75),
                heightDimension: .absolute(75)
            ),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .continuous
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
            case .newItems(let loaiSPData):
                switch loaiSPData {
                    case .success(let loaiSP):
                        return loaiSP.count
                    case .fail:
                        return 1
                }
            case .hotItems(laptops: let laptops):
                return  laptops.count
            case .brands(brands: let brands):
                return  brands.count
            case .hotItemsByBrand(laptops: let laptops):
                return laptops.count
            case .empty:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch homeData[indexPath.section] {
            case .newItems(laptops: let loaiSPType):
                switch loaiSPType {
                    case .success(let loaiSP):
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SanPhamCollectionViewCell", for: indexPath) as? SanPhamCollectionViewCell else {fatalError()}
                        let e = loaiSP[indexPath.item]
//                        cell.backgroundColor = .green
                        cell.oldPrice.text = "Gia cu"
                        cell.newPrice.text = "Gia moi"
                        cell.name.text = e.tenlsp
                        cell.image.sd_setImage(with: URL(string: e.anhlsp ?? ""), placeholderImage: UIImage(named: "user"))
                        return cell
                        
                        
                        
                    case .fail:
                        return  laptopCell(collectionView, cellForItemAt: indexPath)
                }
            case .hotItems(laptops: let laptops):
                return  laptopCell(collectionView, cellForItemAt: indexPath)
            case .brands(brands: let brands):
                return  brandCell(collectionView, cellForItemAt: indexPath)
            case .hotItemsByBrand(laptops: let laptops):
                return  laptopCell(collectionView, cellForItemAt: indexPath)
            case .empty:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Empty", for: indexPath)
//                cell.backgroundColor = .gray
//                return cell
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
                header.title.text = "Sản phẩm mới nhất"
            case 1:
                header.title.text = "Khuyến mãi khủng"
            case 2:
                header.title.text = "Sản phẩm deal tốt"
            default:
                return UICollectionReusableView()
        }
        return header
    }
}

extension HomeViewController: HomeHeaderResuableViewDelegate {
    func homeHeader(_ homeHeader: HomeHeaderReusableView, seeMore sender: UIButton, indexPath: IndexPath) {
        
    }
}
