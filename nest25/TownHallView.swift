import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct TownHallView: View {
    @State private var transcribedText: String = "Listening..."
    private let fetchInterval: TimeInterval = 5.0
    private let serverURL = URL(string: "http://192.168.137.161:5020/text")! // Replace with your server endpoint

    var body: some View {
        VStack {
            WebView(url: URL(string: "http://192.168.137.161:5010")!)
                .edgesIgnoringSafeArea(.all)
            Text(transcribedText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()
        }
        .onAppear(perform: startFetchingText)
    }

    private func startFetchingText() {
        Timer.scheduledTimer(withTimeInterval: fetchInterval, repeats: true) { _ in
            fetchTranscribedText()
        }
    }

    private func fetchTranscribedText() {
        let task = URLSession.shared.dataTask(with: serverURL) { data, _, error in
            guard let data = data, error == nil else { return }
            if let fetchedText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    transcribedText = fetchedText
                }
            }
        }
        task.resume()
    }
}
