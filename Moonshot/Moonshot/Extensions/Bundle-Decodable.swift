import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data from \(file) in bundle.")
        }
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode data from \(file) in bundle due to mussing key \(key.stringValue) - \(context.debugDescription).")
        } catch DecodingError.typeMismatch(let type, let context) {
            fatalError("Failed to decode data from \(file) in bundle due to \(type) type mismatch - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode data from \(file) in bundle due to missing \(type) value - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode data from \(file) in bundle because it appears to be invalid JSON.")
        } catch {
            fatalError("Failed to decode data from \(file) in bundle: \(error.localizedDescription)")
        }
    }
}
