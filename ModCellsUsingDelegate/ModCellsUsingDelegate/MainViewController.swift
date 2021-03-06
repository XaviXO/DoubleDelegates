//
//  ViewController.swift
//  ModCellsUsingDelegate
//
//  Created by Javier Calderon Jr. on 12/30/19.
//  Copyright © 2019 RockefellerFiles. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var sliderValue : Float  = 0.0
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Receive the data from PopUpViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToHeight" {
            let vc: PopUpViewController = segue.destination as! PopUpViewController
            vc.delegate = self
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heightCell", for: indexPath) as! HeightTableViewCell
        cell.configVehicleHeightCell(sliderValue)
        cell.delegate = self
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 150
        default:
            return 150
        }
    }
}

// Receive data from the Cell to MainVC
extension MainViewController: HeightCellDelegate {
    
    func heightSliderValueChanged(_ slider: UISlider, _ feetsLabel: UILabel, _ metersLabel: UILabel) {
        
        let currentValue = Int(slider.value)
        let meters = currentValue / 100
        let centimeters = currentValue % 100
        let inches = currentValue < 3 ? 0 : round(Double(currentValue) / 2.54)
        let feet = round(inches / 12)
        let inch = round(inches.truncatingRemainder(dividingBy: 12))
        
        feetsLabel.text = "\(feet) ft" + " \(inch)\""
        metersLabel.text = "\(meters) m" + " \(centimeters) cm"
    }
}

// Receive data (centimeters) from the PopUp to MainVC
extension MainViewController: HeightPopUpDelegate {
    
    func receiveHeightMetric(centimeters: Int?) {
        print("\n\nMetric Data received")
        print("Centimeters: \(centimeters ?? 0)")
        
        sliderValue = Float(centimeters ?? 0)
        tableView.reloadData()
    }
    
    func receiveHeightImperial(feet: Int?, inches: Int?) {
        
        print("\n\nImperial Data received")
        print("Feet: \(feet ?? 0)")
        print("Inches: \(inches ?? 0)")
        
        let feet = Measurement(value: Double(feet ?? 0), unit: UnitLength.feet)
        let inches = Measurement(value: Double(inches ?? 0), unit: UnitLength.inches)
        
        let feetToCm = feet.converted(to: UnitLength.centimeters)
        let inchesToCm = inches.converted(to: UnitLength.centimeters)
        
        print("\nFeet to cm: \(feetToCm)")
        print("Inches to cm: \(inchesToCm)")
        
        let sumOfCm = feetToCm + inchesToCm
        print("Sum: \(sumOfCm)")
        
        sliderValue = Float(sumOfCm.value)

        tableView.reloadData()
    }
    
}

extension UIAlertController {
    
    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }
}


