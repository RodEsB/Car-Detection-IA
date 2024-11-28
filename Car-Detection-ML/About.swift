//
//  About.swift
//  Car-Detection-ML
//
//  Created by Rod Espiritu Berra on 25/11/24.
//

import SwiftUI

struct SecondView: View {
    var body: some View {
        ScrollView{
            ZStack {
                Rectangle()
                    .foregroundColor(Color(hex: "CF0505"))
                    .ignoresSafeArea()
                
                VStack{
                    Text("What's this app about?")
                        .font(.system(size: 31))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.top, 10)
                        .padding(.bottom, 50)
                    
                    DisclosureGroup{
                        Text(
                            "This app aims to help users detect cars quickly and efficiently using image recognition technology powered by machine learning models."
                        )
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(hex: "0A3981").opacity(0.8))
                        .cornerRadius(10)
                    } label: {
                        Text("Purpose")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .accentColor(.white)
                    .padding(.bottom, 20)
                        
                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(
                                "Real-time car detection using image recognition"
                            )
                            .foregroundColor(.white)
                            Text("Supports multiple camera inputs")
                                .foregroundColor(.white)
                            Text(
                                "Integration with machine learning models for accurate analysis"
                            )
                            .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(hex: "0A3981").opacity(0.8))
                        .cornerRadius(10)
                    } label:{
                        Text("Key Features")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .accentColor(.white)
                    .padding(.bottom, 20)
                                        
                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(
                                "The app takes images from your device's camera and processes them using deep learning algorithms to identify cars."
                            )
                            .foregroundColor(.white)
                            Text(
                                "It displays the results in real-time, with a summary and analysis available for each detection."
                            )
                            .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(hex: "0A3981").opacity(0.8))
                        .cornerRadius(10)
                    } label:{
                        Text("How it Works")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .accentColor(.white)
                    .padding(.bottom, 20)
                                        
                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Built using Swift and Core ML.")
                                .foregroundColor(.white)
                            Text(
                                "Deploys machine learning models for car detection."
                            )
                            .foregroundColor(.white)
                            Text("Optimized for both performance and accuracy.")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(hex: "0A3981").opacity(0.8))
                        .cornerRadius(10)
                    } label:{
                        Text("Technical Info")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .accentColor(.white)
                    .padding(.bottom, 20)
                                        
                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(
                                "Developed by Rodrigo Espiritu Berra and Andrés Cabral Reyes"
                            )
                            .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(hex: "0A3981").opacity(0.8))
                        .cornerRadius(10)
                    } label:{
                        Text("Credits")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .accentColor(.white)
                                        
                    Spacer()
                }
                .padding()
            }
        }
        .background(Color(hex: "CF0505"))
    }
}
#Preview {
    ContentView()
}
