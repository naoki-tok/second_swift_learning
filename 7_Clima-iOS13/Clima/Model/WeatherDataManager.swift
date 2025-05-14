import Foundation

protocol WeatherManagerDelegate {
    func updateWeather(weatherModel: WeatherModel)
    func failedWithError(error: Error)
}

class WeatherDataManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=4e415e4ab2aaed09e04d8419beedee19&units=metric"
    
    var delegate: WeatherManagerDelegate?

    // ✅ 都市名で天気を取得
    func fetchWeather(_ city: String) {
        let completeURL = "\(baseURL)&q=\(city)"
        requestWeatherData(url: completeURL)
    }

    // ✅ 緯度・経度で天気を取得
    func fetchWeather(_ latitude: Double, _ longitude: Double) {
        let completeURL = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        requestWeatherData(url: completeURL)
    }

    // ✅ APIClient を使ってデータ取得
    private func requestWeatherData(url: String) {
        APIClient.shared.fetchData(urlString: url) { (result: Result<WeatherData, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let decodedData):
                    print("✅ APIデータ取得成功！: \(decodedData.name)")

                    let weather = WeatherModel(
                        cityName: decodedData.name,
                        conditionId: decodedData.weather[0].id,
                        temperature: decodedData.main.temp
                    )

                    self.delegate?.updateWeather(weatherModel: weather)  // ✅ UI更新
                case .failure(let error):
                    print("❌ APIエラー: \(error.localizedDescription)")
                    self.delegate?.failedWithError(error: error)  // ✅ エラー通知
                }
            }
        }
    }
}
