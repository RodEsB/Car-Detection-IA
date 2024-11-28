import SwiftUI

struct ContentView: View {
    @State var presentSheet: Bool = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                // Background image with opacity and blur
                ZStack {
                    Image("F1TrackBackground")
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 4) // Increase the blur radius for better effect
                        .ignoresSafeArea()
                        .opacity(0.6) // Adjusting the opacity
                }
                
                VStack {
                    Spacer()
                    Text("Car Detection")
                        .font(.system(size: 44))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(20)
                    Spacer()
                    
                    Button {
                        presentSheet = true
                    } label: {
                        VStack {
                            
                            ZStack{
                                Image(systemName: "viewfinder")
                        
                                Image(systemName: "car.fill")
                                    .scaleEffect(0.5)
                            }
                            .scaleEffect(3)
                            .padding()
                            Text("Launch scan")
                        }
                    }
                    .padding()
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                    .frame(width: 300)
                    .background(Color(hex:"CF0505"))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    
                    NavigationLink(destination: SecondView()) {
                        Text("What's this app?")
                            .padding()
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .frame(width: 300, height: 40)
                            .background(Color(hex:"CF0505"))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            ModelView(presentSheet: $presentSheet)
        }
    }
}

#Preview {
    ContentView()
}
