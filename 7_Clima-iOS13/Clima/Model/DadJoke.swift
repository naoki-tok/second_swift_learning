import Foundation

class DadJokeManager {

    func fetchDadJoke(completion: @escaping (Result<DadJoke, Error>) -> Void) {
        let urlString = "https://icanhazdadjoke.com/"
        print("🌍 Dad Joke APIにリクエスト送信中...") 
        
        // ✅ APIリクエストを統一管理！
        APIClient.shared.fetchData(urlString: urlString) { (result: Result<DadJoke, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let jokeData):
                    print("😂 ジョーク取得成功！: \(jokeData.joke)")
                    completion(.success(jokeData))  // ✅ 呼び出し元にジョークを返す
                case .failure(let error):
                    print("❌ APIエラー: \(error.localizedDescription)")
                    completion(.failure(error))  // ✅ エラー通知
                }
            }
        }
    }
}
