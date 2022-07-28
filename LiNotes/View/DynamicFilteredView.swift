//
//  DynamicFilteredView.swift
//  LiNotes
//
//  Created by Nikita Felicia on 21/07/22.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View,T>: View where T: NSManagedObject {
    //buat request core data
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    //bikin costum ForEach untuk object coredata buat bikin view nya
    init(currentTab: String,@ViewBuilder content: @escaping (T)->Content){
    
        //buat predicate filter current date links
        let calendar = Calendar.current
        var predicate: NSPredicate!
        if currentTab == "Today"{
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            let filterKey = "deadline"
            
            //buat fetch data hari ini sama besok (24 jam)
            //0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today,tomorrow,0])
        }else if currentTab == "Upcoming"{
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tomorrow = Date.distantFuture
            
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today,tomorrow,0])
        }else if currentTab == "Failed"{
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past,today,0])
        }
        else{
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }
    
        //buat nge sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Link.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        
        Group{
            if request.isEmpty{
                Text("No data found")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            }
            else{
                
                ForEach(request,id: \.objectID){object in
                    self.content(object)
                }
            }
        }
    }
}
