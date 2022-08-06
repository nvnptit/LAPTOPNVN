//
//  BrandViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 06/08/2022.
//

import UIKit

class BrandViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var data : [HangSX] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLayout()
        collectionView.register(UINib(nibName: "HangCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HangCollectionViewCell")
        loadData()
        title = "Quản lý hãng sản xuất"
    }
    func configLayout(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
    }
    func loadData(){
        DispatchQueue.init(label: "HangVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            APIService.getHangSX(with: .getHangSX, params: nil, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    self.data = (base.data ?? [])
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.collectionView.reloadData()
                }
            })
        }
        
    }
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] (numberOfSection, env) in
            guard let self = self else { return nil }
            let section = self.brandSection
            return section
            
        }
    }()
    
    private var brandSection: NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .absolute(250),
                heightDimension: .absolute(100)
            ),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 40
        section.interGroupSpacing = 10
        return section
    }
    
}

extension BrandViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        let vc = DetailBrandViewController()
        vc.brand = item
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension BrandViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HangCollectionViewCell", for: indexPath) as? HangCollectionViewCell else {fatalError()}
        let e = data[indexPath.item]
        cell.logo.sd_setImage(with: URL(string: e.logo ?? ""), placeholderImage: UIImage(named: "noimage"))
        return cell
    }
    
}
