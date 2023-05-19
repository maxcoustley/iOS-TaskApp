//
//  WeatherViewController.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 19/5/2023.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionLabel: UILabel!

    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    private let weatherAPIKey = "a2232bc8a53a4f4c9fe41551231905"
    private let weatherAPIURL = "https://api.weatherapi.com/v1"
    private let location = "Melbourne"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchWeatherData()
    }
    
    private func fetchWeatherData() {
        guard let url = URL(string: "\(weatherAPIURL)/current.json?key=\(weatherAPIKey)&q=\(location)") else {
                print("Invalid API URL")
                return
            }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching weather data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    self?.updateUI(with: weather)
                }
            }
        }
        
        task.resume()
    }
    
    private func updateUI(with weather: WeatherData) {
        tempLabel.text = "\(weather.current.temp_c)°C"
        conditionLabel.text = weather.current.condition.text
//        if let iconURL = URL(string: weather.current.icon) {
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: iconURL),
//                   let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.iconImage.image = image
//                    }
//                }
//            }
//        }
    }
    
    struct WeatherData: Codable {
        let current: CurrentWeather
        
        enum CodingKeys: String, CodingKey {
            case current
        }
    }

    struct CurrentWeather: Codable {
        let temp_c: Double
        let condition: WeatherCondition
//        let icon: String
        
        enum CodingKeys: String, CodingKey {
            case temp_c
            case condition
//            case icon
        }
    }

    struct WeatherCondition: Codable {
        let text: String
        
        enum CodingKeys: String, CodingKey {
            case text
        }
    }
    








    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
