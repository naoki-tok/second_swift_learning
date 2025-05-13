//
//  ViewController.swift
//  Clima//
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var goToSecondView: UIButton!
    @IBOutlet weak var dadJokeButton: UIButton!
    @IBOutlet weak var jokeLabel: UILabel!
    
    //MARK: Properties
    var weatherManager = WeatherDataManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        weatherManager.delegate = self
        searchField.delegate = self
        goToSecondView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dadJokeButton.translatesAutoresizingMaskIntoConstraints = false
        dadJokeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
    }
    
    @IBAction func goToSecondView(_ sender: UIButton) {
        let secondVC = SecondViewController(nibName: "SecondView", bundle: nil)
           navigationController?.pushViewController(secondVC, animated: true)
    }
    
    
    @IBAction func fetchDadJoke(_ sender: UIButton) {
        getDadJoke()
    }
    
    func getDadJoke(){
        let url = URL(string: "https://icanhazdadjoke.com/")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept") // JSON形式で取得

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20  // タイムアウトを20秒に変更
        sessionConfig.timeoutIntervalForResource = 40
        sessionConfig.waitsForConnectivity = true // 接続待機を有効化

        let session = URLSession(configuration: sessionConfig)

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }

            if let data = data, let jokeResponse = try? JSONDecoder().decode(DadJoke.self, from: data) {
                DispatchQueue.main.async {
                    self.jokeLabel.text = jokeResponse.joke
                }
            }
        }.resume()

    }



}

struct DadJoke: Decodable {
    let joke: String
}

 
//MARK:- TextField extension
extension WeatherViewController: UITextFieldDelegate {
    
        @IBAction func searchBtnClicked(_ sender: UIButton) {
            searchField.endEditing(true)    // キーボードを閉じる
                searchWeather()

                // コンソールに検索アクションと都市名を出力
                if let city = searchField.text {
                    print("action: search, city: \(city)")
                    
                    if city == "Tokyo" {
                        updateBackgroundForTokyo()
                    } else {
                        updateBackgroundDefault()
                    }
                }
            
        }
    
        func searchWeather(){
            if let cityName = searchField.text{
                weatherManager.fetchWeather(cityName)
            }
        }
        
        // when keyboard return clicked
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchField.endEditing(true)    //dismiss keyboard
            print(searchField.text!)
            
            searchWeather()
            return true
        }
        
        // when textfield deselected
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            // by using "textField" (not "searchField") this applied to any textField in this Controller(cuz of delegate = self)
            if textField.text != "" {
                return true
            }else{
                textField.placeholder = "Type something here"
                return false            // check if city name is valid
            }
        }
        
        // when textfield stop editing (keyboard dismissed)
        func textFieldDidEndEditing(_ textField: UITextField) {
    //        searchField.text = ""   // clear textField
        }
    
        func updateBackgroundForTokyo(){
        backgroundImageView.image = UIImage(named: "tokyo_background")
        }
    
    func updateBackgroundDefault(){
        backgroundImageView.image = UIImage(named: "background")
    }
}

//MARK:- View update extension
extension WeatherViewController: WeatherManagerDelegate {
    
    func updateWeather(weatherModel: WeatherModel){
        DispatchQueue.main.sync {
            temperatureLabel.text = weatherModel.temperatureString
            cityLabel.text = weatherModel.cityName
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        }
    }
    
    func failedWithError(error: Error){
        print(error)
    }
}

// MARK:- CLLocation
extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        // Get permission
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat, lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
