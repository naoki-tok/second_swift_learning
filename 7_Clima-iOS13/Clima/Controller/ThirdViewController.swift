import UIKit

class ThirdViewController: UIViewController, WeatherManagerDelegate {  // ✅ Delegateを追加

    var cityName: String?
    var weatherManager = WeatherDataManager()

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        weatherManager.delegate = self  // ✅ WeatherManagerのDelegateをセット

        if let cityName = cityName {
            cityLabel.text = cityName
            fetchWeather(for: cityName)
        }
    }

    // ✅ APIを使って天気を取得
    func fetchWeather(for city: String) {
        weatherManager.fetchWeather(city)
    }

    // ✅ 天気情報をUIに表示（WeatherManagerDelegateのメソッド）
    func updateWeather(weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherModel.temperatureString
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        }
    }

    func failedWithError(error: Error) {
        print("❌ APIエラー:", error.localizedDescription)
    }
}
