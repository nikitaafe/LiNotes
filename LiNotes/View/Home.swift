//
//  Home.swift
//  LiNotes
//
//  Created by Nikita Felicia on 21/07/22.
//

import SwiftUI

extension Color {
    static let color1 = Color("color1")
    static let color2 = Color("color2")
    static let color3 = Color("color3")
}

struct Home: View {
    @StateObject var linkModel: LinkViewModel = .init()
    
    @Namespace var animation
    
    @FetchRequest(entity: Link.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Link.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var links: FetchedResults<Link>
    
    @Environment(\.self) var env
    
    private let pasteboard = UIPasteboard.general
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hi! Welcome to LiNotes")
                        .font(.callout)
                    Text("Here's your daily notes")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.vertical)
                
                CustomSegmentedBar()
                    .padding(.top,5)
                
                LinkView()
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
        
            Button {
                linkModel.openEditLink.toggle()
            } label: {
                Label {
                    Text("Add New Link")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(Color("color1"),in: Capsule())
            }
            
            .padding(.top,10)
            .frame(maxWidth: .infinity)
            .background{
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7),
                    .white
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $linkModel.openEditLink) {
            linkModel.resetLinkData()
        } content: {
            AddNewLink()
                .environmentObject(linkModel)
        }
    }
    
    @ViewBuilder
    func LinkView()->some View{
        LazyVStack(spacing: 20){
            DynamicFilteredView(currentTab: linkModel.currentTab) { (link: Link) in
                LinkRowView(link: link)
            }
        }
        .padding(.top,20)
    }
    
    @ViewBuilder
    func LinkRowView(link: Link)->some View{
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text(link.type ?? "")
                    .font(.callout)
                    .padding(.vertical,5)
                    .padding(.horizontal)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.5))
                            //.fill(.white.opacity(0.7))
                    }
                
                Spacer()
                
//                if !link.isCompleted && linkModel.currentTab != "Failed"{
                    Button {
                        linkModel.editLink = link
                        linkModel.openEditLink = true
                        linkModel.setupLink()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
//                }
            }
    
            Text(link.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical,10)
            

            HStack{
                Text(link.detail ?? "")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.vertical,10)

            Spacer()
                
                Button {
                    pasteboard.string = link.detail
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    }

                } label: {
                    Image(systemName: "doc.on.doc.fill")
                        .foregroundColor(.black)
                }
            }

            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((link.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    
                    Label {
                        Text((link.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                
                if !link.isCompleted && linkModel.currentTab != "Failed"{
                    Button {
                    
                        link.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    } label: {
                        Circle()
                            .strokeBorder(.black,lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }
                }
            }
        }
        
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(link.color ?? "Yellow"))
        }
    }
    
    @ViewBuilder
    func CustomSegmentedBar()->some View{
        
        let tabs = ["Today","Upcoming","Link Done","Failed"]
        HStack(spacing: 0){
            ForEach(tabs,id: \.self){tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(linkModel.currentTab == tab ? .white : .color2)
                    .padding(.vertical,6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if linkModel.currentTab == tab{
                            Capsule()
                                .fill(Color("color1"))
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{linkModel.currentTab = tab}
                    }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
