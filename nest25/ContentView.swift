import SwiftUI

struct ContentView: View {
    @AppStorage("isOnboarded") private var isOnboarded: Bool = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var isShowingSplash: Bool = true
    
    var body: some View {
        ZStack {
            if isShowingSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowingSplash = false
                            }
                        }
                    }
            } else if !isOnboarded {
                OnboardingView(isOnboarded: $isOnboarded)
            } else if !isLoggedIn {
                LoginView(isLoggedIn: $isLoggedIn)
            } else {
                MainTabView()
            }
        }
        .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

