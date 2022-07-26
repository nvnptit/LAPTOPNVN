//
//  CartViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit
import NVActivityIndicatorView

class CartViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    let Host = "http://192.168.1.74"
    @IBOutlet weak var btnDatHang: UIButton!
    var data : [GioHangData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLayout()
        collectionView.register(UINib(nibName: "CartItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CartItemCollectionViewCell")
        setupAnimation()
        loadData()
    }
    override func viewDidAppear(_ animated: Bool = false) {
        loadData()
    }
    func configLayout(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
    }
    
    private func setupAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 20),
            loading.heightAnchor.constraint(equalToConstant: 20),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15)
        ])
    }
    
    
    func loadData(){
        loading.startAnimating()
        DispatchQueue.init(label: "CartVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let params = GioHangRequest(cmnd: "300123456").convertToDictionary()
            
            APIService.getGioHang(with: .getGioHang, params: params, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let dataGioHang = base.data {
                        self.data = dataGioHang
                    }
                } else {
                    fatalError()
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.collectionView.reloadData()
                    
                    self.loading.stopAnimating()
                }
            })
        }
        
    }
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] (numberOfSection, env) in
            guard let self = self else { return nil }
            let section = self.cartSection
            return section
            
        }
    }()
    
    private var cartSection: NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(140)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension CartViewController: UICollectionViewDelegate{
    
}
extension CartViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartItemCollectionViewCell", for: indexPath) as? CartItemCollectionViewCell else {fatalError()}
        let item = data[indexPath.item]
        if let anhlsp = item.anhlsp, let ten=item.tenlsp, let serial = item.serial, let gia = item.giamoi {
            cell.imageLSP.loadFrom(URLAddress: Host+anhlsp)
            cell.nameLSP.text = ten + "\n"+serial
            cell.priceLSP.text = "\(gia)"
        }
        return cell
    }
    
}
