//
//  WeatherViewController.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 19/5/2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionLabel: UILabel!

    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    private let weatherAPIKey = "a2232bc8a53a4f4c9fe41551231905"
    private let weatherAPIURL = "https://api.weatherapi.com/v1"
    private var location = "Melbourne"
    private let locationManager = CLLocationManager()
    private var isLocationUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
        if let url = URL(string: weather.current.condition.icon),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
               // Display the image in a UIImageView
               iconImage.image = image
        }
        
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
        
        
        enum CodingKeys: String, CodingKey {
            case temp_c
            case condition
           
        }
    }

    struct WeatherCondition: Codable {
        let text: String
        let icon: String
        
        enum CodingKeys: String, CodingKey {
            case text
            case icon
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

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        // Check if location is already updated
        guard !isLocationUpdated else {
            return
        }
        
        isLocationUpdated = true
       
        let geocoder = CLGeocoder()
                
        // Perform reverse geocoding to get the city name from the location coordinate
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                // Handle any errors that occur during reverse geocoding
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            
            // Retrieve the city name from the placemark
            if let city = placemarks?.first?.locality {
                // Use the city name as needed
                print("City: \(city)")
                
                // Update your UI or perform any other actions with the city name
                DispatchQueue.main.async {
                    // Update your UI elements with the city name
                    // For example, set a label's text property
                    self!.location = city
                }
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle any errors that occur during location retrieval
        print("Location retrieval error: \(error.localizedDescription)")
    }
}
