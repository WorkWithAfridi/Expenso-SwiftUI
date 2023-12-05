import SwiftUI

struct OnboardingView: View {
  var onCompletion: () -> Void
  
  @Namespace private var animation
  @State private var selectedPage = 0
  
  let onboardingScreens = [
    OnboardingScreen(
      title: "Welcome to Expenso",
      isColoredTitle: true,
      description: "Wisdom in every cent.",
      image: Image("Screenshot")
    ),
    OnboardingScreen(
      title: "Track Expenses",
      isColoredTitle: false,
      description: "Keep track of your spending easily.",
      image: Image(systemName: "dollarsign.circle.fill")
    ),
  ]
  
  var body: some View {
    VStack {
      Spacer()
      TabView(selection: $selectedPage) {
        ForEach(0..<onboardingScreens.count, id: \.self) { index in
          let screen = onboardingScreens[index]
          VStack {
            screen.image
              .resizable()
              .scaledToFit()
              .frame(width: UIScreen.main.bounds.width * 0.50)
            if screen.isColoredTitle {
              ColoredTitleView()
            } else {
              Text(screen.title)
                .font(.largeTitle)
                .bold()
            }
            Text(screen.description)
              .multilineTextAlignment(.center)
              .padding()
          }
          .tag(index)
        }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      
      DotsIndicator(numberOfPages: onboardingScreens.count, currentPage: selectedPage)
        .padding(.bottom)
        .opacity(selectedPage == onboardingScreens.count - 1 ? 0 : 1)
      
      if selectedPage == onboardingScreens.count - 1 {
        Button("Get Started", action: onCompletion)
          .padding()
          .background(Capsule().fill(Color("ExpensoPink")))
          .foregroundColor(.white)
          .padding()
          .transition(.slide)
          .matchedGeometryEffect(id: "getStartedButton", in: animation)
      }
      
      Spacer()
    }
    .padding()
    .background(Color(UIColor.systemBackground).ignoresSafeArea())
  }
}

#Preview {
  OnboardingView {
    print("Login action performed.")
  }
  .preferredColorScheme(.dark)
}
