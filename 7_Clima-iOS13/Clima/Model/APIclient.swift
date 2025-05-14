import Foundation

class APIClient {

    static let shared = APIClient()

    func fetchData<T: Decodable>(urlString: String, retryCount: Int = 3, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("❌ URLが無効です！: \(urlString)")
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        print("🌍 APIリクエスト送信: \(urlString)")

        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ APIリクエスト失敗: \(error.localizedDescription)")

                if retryCount > 0 {
                    print("🔄 再試行中...（残り\(retryCount)回）")
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                        self.fetchData(urlString: urlString, retryCount: retryCount - 1, completion: completion)  // ✅ `retryCount` を正しく減らして再試行
                    }
                } else {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                print("❌ APIレスポンスが空！")
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                print("✅ APIレスポンス取得成功！")
                completion(.success(decodedData))
            } catch {
                print("❌ JSONデコード失敗:", error.localizedDescription)
                completion(.failure(error))
            }
        }.resume()
    }
}
