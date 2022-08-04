//
//  SearchViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 24/07/2022.
//

import UIKit
import DropDown
import SDWebImage
import NVActivityIndicatorView

class SearchViewController: UIViewController{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tfGiaMin: UITextField!
    @IBOutlet weak var tfGiaMax: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lbBrand: UILabel!
    
    @IBOutlet weak var dropdownBrand: UIView!
    var maHang: Int?
    var data: [LoaiSanPhamKM] = []
    
    var brand = DropDown()
    var dataBrand: [HangSX] = []
    var brandValues: [String] = ["All"]
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDown()
        setupKeyboard()
        
        searchBar.delegate = self
        tfGiaMin.delegate = self
        tfGiaMax.delegate = self
        getDataBrands()
        configLayout()
        
        collectionView.register(UINib(nibName: "SanPhamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SanPhamCollectionViewCell")
        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
//        self.view.addGestureRecognizer(gesture)
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
    
    private func setupBrand() {
        brand.anchorView = dropdownBrand
        brand.dataSource = brandValues
        brand.bottomOffset = CGPoint(x: 0, y:(brand.anchorView?.plainView.bounds.height)! + 5)
        brand.direction = .bottom
        brand.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbBrand.text = item
            for i in dataBrand{
                if let name = i.tenhang, let ma = i.mahang {
                    if (name == item){
                        self.maHang = ma
                    }
                }
            }
            if (item == "All") {
                self.maHang = nil
            }
            getDataSearch()
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapBrand))
        dropdownBrand.addGestureRecognizer(gestureClock)
        dropdownBrand.layer.borderWidth = 1
        dropdownBrand.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @objc func didTapBrand() {
        brand.show()
    }
    
    private func getDataBrands(){
        APIService.getHangSX(with: .getHangSX, params: nil, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.dataBrand = base.data ?? []
                for item in self.dataBrand{
                    self.brandValues.append(item.tenhang ?? "")                }
            }
            self.setupBrand()
        })
    }
    
    
    
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.cyan
        DropDown.appearance().cornerRadius = 8
    }
    
    func configLayout(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
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
                widthDimension: .absolute(320),
                heightDimension: .absolute(300)
            ),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return section
    }
    
}
extension SearchViewController: UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getDataSearch()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        getDataSearch()
    }
}


extension SearchViewController: UICollectionViewDataSource{
    
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

extension SearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        let detailSPViewController = DetailSanPhamViewController()
        detailSPViewController.loaiSp = item
        self.navigationController?.pushViewController(detailSPViewController, animated: true)
        
    }
}

extension SearchViewController {
    private func getDataSearch(){
        print("SEARCHNAME: \(searchBar.text)")
        let min = tfGiaMin.text?.count == 0 ? nil : Int(tfGiaMin.text!)
        let max = tfGiaMax.text?.count == 0 ? nil : Int(tfGiaMax.text!)
        let params = SearchModel(tenLSP: searchBar.text, priceMin: min, priceMax: max, maHang: self.maHang).convertToDictionary()
        print(params)
        APIService.searchLoaiSanPham(with: .searchLSP, params: params, headers: nil, completion: {
            [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true , let data = base.data{
                self.data = data
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
        })
    }
    
}

extension SearchViewController{
    //MARK: - Setup keyboard, user
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func didTapOnView() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        //        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        //        contentInset.bottom = keyboardFrame.size.height + 70
        //        scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        //        scrollView.contentInset = contentInset
    }
    //MARK: - End Setup keyboard
}
