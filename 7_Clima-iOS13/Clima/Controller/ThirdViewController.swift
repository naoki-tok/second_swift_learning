import UIKit

class ThirdViewController: UIViewController, WeatherManagerDelegate {  // ✅ Delegateを追加

    var cityName: String?  // ✅ 都市名を受け取る変数
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
            fetchWeather(for: cityName)  // ✅ 天気データを取得
        }
    }

    // ✅ 天気データを取得する関数
    func fetchWeather(for city: String) {
        weatherManager.fetchWeather(city)
    }

    // ✅ 天気情報を更新する（WeatherManagerDelegateのメソッド）
    func updateWeather(weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherModel.temperatureString  // ✅ 天気情報をUIにセット
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        }
    }

    func failedWithError(error: Error) {
        print("Error fetching weather:", error)
    }
}
