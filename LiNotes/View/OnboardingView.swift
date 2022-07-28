//
//  OnboardingView.swift
//  LiNotes
//
//  Created by Nikita Felicia on 20/07/22.
//

import SwiftUI

struct OnboardingView : View {
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        if currentPage > totalPages{
            HomeView()
        }else{
            WalkthroughScreen()
            
        }
    }
}
        
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

struct WalkthroughScreen: View {
    
    @AppStorage("currentPage") var currentPage = 1
    var body: some View{
        
        ZStack{
            
            if currentPage == 1{
                ScreenView(image: "Onboarding1", title: "Welcome to LiNotes", detail: "", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if currentPage == 2{
                ScreenView(image: "Onboarding2", title: "What is LiNotes?", detail: "A place for you to input your daily notes especially in links form.", bgColor: Color("color4"))
                .transition(.scale)
            }
            
            if currentPage == 3{
                ScreenView(image: "Onboarding3", title: "Stay Remember!", detail: "You can easily remember what links that you've seen previously with LiNotes.", bgColor: Color("color4"))
                .transition(.scale)
            }
        }
        .overlay(
            
            Button(action: {
                
                withAnimation(.easeInOut){
                    if currentPage <= totalPages{
                        currentPage += 1
                    }
                    else{
                        currentPage = 1
                    }
                }
            }, label: {
            
                Image(systemName: "chevron.right")
                    .font(.system(size:20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                
                    .overlay(
                        ZStack{
                            Circle()
                                .stroke(Color.black.opacity(0.04),lineWidth: 4)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                .stroke(Color("color5"),lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                        .padding(-15)
                    )
            })
            .padding(.bottom,20)
            
            ,alignment: .bottom
        )
    }
}
    
    
    struct ScreenView: View {
        
        var image: String
        var title: String
        var detail: String
        var bgColor: Color
        
        @AppStorage("currentPage") var currentPage = 1
        
        var body: some View {
            VStack(spacing: 20){
            
                HStack{
                    
                    if currentPage == 1{
                        Text("Hello!")
                            .font(.title)
                            .fontWeight(.semibold)
                            .kerning(1.0)
                    }
                    else{
                        Button(action: {
                            withAnimation(.easeInOut){
                                currentPage -= 1
                            }
                        }, label: {
                            
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .padding(.vertical,10)
                                .padding(.horizontal)
                                .background(Color.black.opacity(0.4))
                                .cornerRadius(10)
                        })
                    }
                 
                   
                    Spacer()
                   
                    Button(action: {
                        withAnimation(.easeInOut){
                            currentPage = 4
                        }
                    }, label: {
                        Text("Skip")
                            .fontWeight(.semibold)
                            .kerning(0.5)
                    })
                }
                .foregroundColor(.black)
                .padding()
                
                Spacer(minLength: 0)
               
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
               
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top)
               
                Text(detail)
                    .fontWeight(.semibold)
                    .kerning(0.9)
                    .multilineTextAlignment(.center)
               
                Spacer(minLength: 120)
            }
            .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}

var totalPages = 3
