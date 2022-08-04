//
//  ListLaptopViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 25/07/2022.
//

import UIKit

class ListLaptopViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let Host = "http://192.168.1.74"
    var data : [LoaiSanPhamKM] = []
    var maHang = 1
    var typeHome = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configLayout()
        collectionView.register(UINib(nibName: "SanPhamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SanPhamCollectionViewCell")
        switch typeHome {
            case "New":
                loadDataNew()
            case "KM":
                loadDataKM()
            case "Brand":
                loadDataHang()
            default:
                break
                
        }
    }
    func configLayout(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
    }
    func loadDataNew(){
        
        
        DispatchQueue.init(label: "SanPhamVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            APIService.getLoaiSanPhamNew(with: .getLoaiSanPhamNew, params: nil, headers: nil, completion: { [weak self] base, error in
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
    
    func loadDataKM(){
        APIService.getLoaiSanPhamKM(with: .getLoaiSanPhamKM, params: nil, headers: nil, completion: { [weak self] base, error in
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
    func loadDataHang(){
        let params = HangModel(maHang: self.maHang).convertToDictionary()
        APIService.getLoaiSanPhamHang(with: .getLoaiSanPhamHang, params: params, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.data = (base.data ?? [])
                
                if (self.data.isEmpty){
                    let alert = UIAlertController(title: "Hiện tại danh mục chưa có sản phẩm", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true)
                }
                
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
        })
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    private lazy var layout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] (numberOfSection, env) in
            guard let self = self else { return nil }
            let section = self.sanPhamSection
            return section
            
        }
    }()
    
    private var sanPhamSection: NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .absolute(300),
                heightDimension: .absolute(300)
            ),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 30
        section.interGroupSpacing = -20
        return section
    }
    
}

extension ListLaptopViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        let detailSPViewController = DetailSanPhamViewController()
        detailSPViewController.loaiSp = item
        self.navigationController?.pushViewController(detailSPViewController, animated: true)
        
    }
}
extension ListLaptopViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SanPhamCollectionViewCell", for: indexPath) as? SanPhamCollectionViewCell else {fatalError()}
        let e = data[indexPath.item]
        if let ten = e.tenlsp, let price = e.giamoi, let newPrice = e.giagiam , let anh = e.anhlsp, let gg = e.ptgg{
            cell.name.text = ten
            if (gg > 0 ){
                cell.oldPrice.text = "\(CurrencyVN.toVND(price))"
                cell.oldPrice.textColor = .red
                cell.oldPrice.strikeThrough(true)
                cell.newPrice.text = "\(CurrencyVN.toVND(newPrice))"
            }else {
                cell.oldPrice.text = ""
                cell.newPrice.text =  "\(CurrencyVN.toVND(price))"
            }
            cell.image.loadFrom(URLAddress: Host + anh)
        }
        return cell
    }
}
