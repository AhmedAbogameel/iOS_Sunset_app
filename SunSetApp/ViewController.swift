//
//  ViewController.swift
//  SunSetApp
//
//  Created by Jemi on 14/11/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func onPressed(_ sender: Any) {
        if(textField.text != nil && textField.text?.isEmpty == false){
            loadURL()
        }
    }
        
    func loadURL() {
        loadingIndicator.startAnimating()
        button.isHidden = true
        self.resultLabel.textColor = UIColor.white;
        let api = "http://api.openweathermap.org/data/2.5/weather?q=\(textField.text!)&appid=be2acbcfe99b5fe0e4e59c3b35c3dd23"
        DispatchQueue.global().async {
            do {
                let url = URL(string: api)!
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let sys = json["sys"] as! [String:Any]
                let strDate = self.reformatDateFromTimeStamp(value: sys["sunset"] as! Double)
                self.updateUIOnFinish(result: strDate)
            } catch {
                self.updateUIOnFinish(result: nil)
            }
        }
    }
    
    private func updateUIOnFinish(result:String?) {
        DispatchQueue.main.sync {
            if(result != nil){
                self.resultLabel.text = "Sunset will be at " + result!
                self.resultLabel.textColor = UIColor.systemGreen;
            }else{
                self.resultLabel.text = "Error, Try Again!"
                self.resultLabel.textColor = UIColor.systemRed;
            }
            self.loadingIndicator.stopAnimating()
            self.button.isHidden = false
        }
    }
    
    private func reformatDateFromTimeStamp(value:Double) -> String {
        let date = Date(timeIntervalSince1970: value)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "hh:mm a"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
    }


}

