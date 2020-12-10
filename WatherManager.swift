//
//  WatherManager.swift
//  Clima
//
//  Created by Artur Markov on 12/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=0ab7411b179b96139cbc862c146fcbf8&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1.Create URL
        if let url = URL(string: urlString) {
            //2. Create a URL Session
            let session = URLSession(configuration: .default)
            
            //3. Dive session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)
            print(weather.conditionName)
            print(weather.tempString)
        } catch {
            print(error)
        }
    }
    
    
}
