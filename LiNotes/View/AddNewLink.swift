//
//  AddNewLink.swift
//  LiNotes
//
//  Created by Nikita Felicia on 21/07/22.
//

import SwiftUI

struct AddNewLink: View {
    @EnvironmentObject var linkModel: LinkViewModel
 
    @Environment(\.self) var env
    @Namespace var animation
    var body: some View {
        VStack(spacing: 12){
            Text("Edit Link")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        env.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
                .overlay(alignment: .trailing) {
                    Button {
                        if let editTast = linkModel.editLink{
                            env.managedObjectContext.delete(editTast)
                            try? env.managedObjectContext.save()
                            env.dismiss()
                        }
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                    .opacity(linkModel.editLink == nil ? 0 : 1)
                }
            
                .padding(.vertical,10)
            
            Group {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Link Title")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("", text: $linkModel.linkTitle)
                        .frame(maxWidth: .infinity)
                        .padding(.top,8)
                     }
                     .padding(.top,10)
                     
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Link Detail")
                        .font(.caption)
                        .foregroundColor(.gray)
                         
                    TextField("", text: $linkModel.linkDetail)
                        .frame(maxWidth: .infinity)
                        .padding(.top,8)
                     }
                     .padding(.top,10)
                    
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Link Deadline")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(linkModel.linkDeadline.formatted(date: .abbreviated, time: .omitted) + ", " + linkModel.linkDeadline.formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top,8)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    linkModel.showDatePicker.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(Color("color1"))
                }
            }
            
            Divider()
            
            let linkTypes: [String] = ["Design","Tech","Other"]
            VStack(alignment: .leading, spacing: 12) {
                Text("Category")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12){
                    ForEach(linkTypes,id: \.self){type in
                        Text(type)
                            .font(.callout)
                            .padding(.vertical,8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(linkModel.linkType == type ? .white : .color3)
                            .background{
                                if linkModel.linkType == type{
                                    Capsule()
                                        .fill(Color("color1"))
                                        .matchedGeometryEffect(id: "TYPE", in: animation)
                                }else{
                                    Capsule()
                                        .strokeBorder(Color("color1"))
                                }
                            }
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation{linkModel.linkType = type}
                            }
                    }
                }
                .padding(.top,8)
            }
            .padding(.vertical,10)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Link Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                let colors: [String] = ["colora","colorb","colorc"]
            
                HStack(spacing: 15){

                        if linkModel.linkType == "Design" {
                            Circle()
                                .fill(Color("colora"))
                                .frame(width: 25, height: 25)
                                .background{
                                    if linkModel.linkColor == "colora"{
                                        Circle()
                                            .strokeBorder(.gray, lineWidth: 1)
                                            .padding(-3)
                                    }
                                }
                                .contentShape(Circle())
                                .onTapGesture {
                                    linkModel.linkColor = "colora"
                                }
                        } else if linkModel.linkType == "Tech" {
                            Circle()
                                .fill(Color("colorb"))
                                .frame(width: 25, height: 25)
                                .background{
                                    if linkModel.linkColor == "colorb"{
                                        Circle()
                                            .strokeBorder(.gray, lineWidth: 1)
                                            .padding(-3)
                                    }
                                }
                                .contentShape(Circle())
                                .onTapGesture {
                                    linkModel.linkColor = "colorb"
                        }
                        } else {
                            Circle()
                                .fill(Color("colorc"))
                                .frame(width: 25, height: 25)
                                .background{
                                    if linkModel.linkColor == "colorc"{
                                        Circle()
                                            .strokeBorder(.gray, lineWidth: 1)
                                            .padding(-3)
                                    }
                                }
                                .contentShape(Circle())
                                .onTapGesture {
                                    linkModel.linkColor = "colorc"
                        }
                    }
                }  .padding(.top,8)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.top,10)
            
            Divider()
            
            Button {
                if linkModel.addLink(context: env.managedObjectContext){
                    env.dismiss()
                }
            } label: {
                Text("Save")
                    .font(.callout)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,12)
                    .foregroundColor(.white)
                    .background{
                        Capsule()
                            .fill(Color("color1"))
                    }
            }
            .frame(maxHeight: .infinity,alignment: .bottom)
            .padding(.bottom,10)
            .disabled(linkModel.linkTitle == "")
            .opacity(linkModel.linkTitle == "" ? 0.6 : 1)
        }
        .frame(maxHeight: .infinity,alignment: .top)
        .padding()
        .overlay {
            ZStack{
                if linkModel.showDatePicker{
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            linkModel.showDatePicker = false
                        }
                    
                    //buat nge disable tanggal2 yang lalu
                    DatePicker.init("", selection: $linkModel.linkDeadline,in: Date.now...Date.distantFuture)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        .background(.white,in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding()
                }
            }
            .animation(.easeInOut, value: linkModel.showDatePicker)
        }
    }
}

struct AddNewLink_Previews: PreviewProvider {
    static var previews: some View {
        AddNewLink()
            .environmentObject(LinkViewModel())
    }
}
