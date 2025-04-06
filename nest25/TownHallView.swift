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
import SwiftUI

struct TownHallView: View {
    var body: some View {
        WebView(url: URL(string: "http://192.168.137.161:5010")!)
            .edgesIgnoringSafeArea(.all)
    }
}
