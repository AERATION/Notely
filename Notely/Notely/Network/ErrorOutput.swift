public class ErrorOutput {
    static let shared = ErrorOutput()
    public func errorOutput(error: Error) {
        print(error.localizedDescription)
    }
}
