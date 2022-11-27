//
//  PieChartViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 26/11/2022.
//

import UIKit
import Charts

class PieChartViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    var dataPie: [DataPieResponse] = []
    override func viewDidLoad() {
      super.viewDidLoad()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.getDataPie()
        }
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      
      // 1. Set ChartDataEntry
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry)
      }
//        pieChartView.centerText = "SỐ LIỆU ĐƠN HÀNG"
      
      // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
      pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
      
      // 3. Set ChartData
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      let format = NumberFormatter()
        format.numberStyle = .none
      let formatter = DefaultValueFormatter(formatter: format)
      pieChartData.setValueFormatter(formatter)
      
      // 4. Assign it to the chart's data
      pieChartView.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }

}
extension PieChartViewController{
        private func getDataPie(){
            APIService.fetchAllStatusOrder(with: .getAllStatusOrder, params: nil, headers: nil, completion: {
                base, error in
                guard let base = base else { return }
                if base.success == true {
                    self.dataPie = base.data ?? []
                    var  sum = 0
                        for it in self.dataPie {
                            sum = sum + (it.soluong ?? 0)
                    }
                    var dataChart: [String] = []
                    var valueChart: [Double] = []
                    for item in self.dataPie {
                        dataChart.append(item.tentrangthai ?? "")
                        valueChart.append(Float64(item.soluong ?? 0)/Double(sum)*100) //
                    }
                    self.customizeChart(dataPoints: dataChart, values: valueChart.map{ Double($0) })
                } else {
                    let alert = UIAlertController(title:"Lỗi get data pie", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                }
            })
        }
}
