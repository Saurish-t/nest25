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
    @State private var claimResult: String = "No claims detected yet."
    @State private var messageText: String = "" // State for the message bar
    private let fetchInterval: TimeInterval = 5.0
    private let serverURL = URL(string: "http://192.168.137.161:5020/text")! // Replace with your server endpoint
    private let messageServerURL = URL(string: "http://192.168.137.161:5005/message")! // Endpoint for messages

    var body: some View {
        VStack {
            WebView(url: URL(string: "http://192.168.137.161:5010")!)
                .edgesIgnoringSafeArea(.all)
            Text(transcribedText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()
            Text(claimResult)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                .padding()
            Spacer()
            HStack {
                TextField("Type your message...", text: $messageText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                Button(action: sendMessage) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
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
                    fetchClaimResult(for: fetchedText)
                }
            }
        }
        task.resume()
    }

    private func fetchClaimResult(for text: String) {
        guard let claimURL = URL(string: "http://192.168.137.161:5004/claim") else { return }
        var request = URLRequest(url: claimURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["claim": text, "claimant": "TownHallView"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let results = json["results"] as? String {
                DispatchQueue.main.async {
                    claimResult = results
                }
            }
        }
        task.resume()
    }

    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        var request = URLRequest(url: messageServerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["message": messageText]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if error == nil {
                DispatchQueue.main.async {
                    messageText = "" // Clear the message bar after sending
                }
            }
        }
        task.resume()
    }
}
