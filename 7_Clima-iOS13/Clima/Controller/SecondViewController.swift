import UIKit

// ✅ 路線データモデル
struct Rail {
    var isShown: Bool
    var railName: String
    var stationArray: [String]
}

// ✅ 路線データの定義
private let headerArray: [String] = ["EU", "アジア", "オセアニア", "アフリカ"]
private let yamanoteArray: [String] = ["ベルリン", "アムステルダム", "ロンドン"]
private let toyokoArray: [String] = ["東京", "バンコク"]
private let dentoArray: [String] = ["シドニー", "メルボルン"]
private let jobanArray: [String] = ["ケープタウン"]

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    private var courseArray: [Rail] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // ✅ データを初期化
        courseArray = [
            Rail(isShown: true, railName: headerArray[0], stationArray: yamanoteArray),
            Rail(isShown: false, railName: headerArray[1], stationArray: toyokoArray),
            Rail(isShown: false, railName: headerArray[2], stationArray: dentoArray),
            Rail(isShown: false, railName: headerArray[3], stationArray: jobanArray)
        ]

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // ✅ セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return courseArray.count
    }

    // ✅ 各セクションの行数（開閉状態に応じて変更）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseArray[section].isShown ? courseArray[section].stationArray.count : 0
    }

    // ✅ セルの内容（駅名）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = courseArray[indexPath.section].stationArray[indexPath.row]
        return cell
    }

    // ✅ セクションタイトル（路線名）
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return courseArray[section].railName
    }

    // ✅ ヘッダーをタップで開閉切り替え
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.textLabel?.text = courseArray[section].railName
        headerView.tag = section

        let gesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
        headerView.addGestureRecognizer(gesture)

        return headerView
    }

    // ✅ タップ時の開閉処理
    @objc func headerTapped(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }
        courseArray[section].isShown.toggle()

        tableView.beginUpdates()
        tableView.reloadSections([section], with: .automatic)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = courseArray[indexPath.section].stationArray[indexPath.row]  // ✅ タップした都市名を取得

        let thirdVC = ThirdViewController()  // ✅ `ThirdViewController` のインスタンスを作成
        thirdVC.cityName = cityName  // ✅ 都市名をセット

        navigationController?.pushViewController(thirdVC, animated: true)  // ✅ 画面遷移
    }



}


