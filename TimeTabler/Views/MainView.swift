//
//  MainView.swift
//  TimeTabler
//
//  Created by Hariz Shirazi on 2023-08-31.
//


// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI

// TODO: Widgets
// ca.bomberfish.TimeTabler.SuperCoolWidget

struct Course: Equatable, Identifiable, Codable {
    var id = UUID()
    var time: String
    var code: String
    var room: String
}


struct MainView: View {
    @State var time: Date = Date.now
    @AppStorage("courses") var courses: [Course] = []
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "HH:mm"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section("Courses") {
                        ForEach($courses) {course in
                            
                            let timeBinding: Binding<Date> = Binding(
                                get: { dateFormatter.date(from: course.time.wrappedValue) ?? Date.now },
                                set: { new in
                                    course.time.wrappedValue = dateFormatter.string(from: new)
                                })
                            
                            HStack {
                                DatePicker(selection: timeBinding, displayedComponents: .hourAndMinute, label: {EmptyView()})
                                    .labelsHidden()
                                    .padding(.trailing, 5)
                                Spacer()
                                Group {
                                    Spacer()
                                    TextField("Course", text: course.code)
                                    TextField("Room", text: course.room)
                                        .keyboardType(.numbersAndPunctuation)
                                }
                                .submitLabel(.done)
                            }
                        }
                        .onMove { indexSet, offset in
                            Haptic.shared.play(.light)
                            courses.move(fromOffsets: indexSet, toOffset: offset)
                        }
                        .onDelete { indexSet in
                            courses.remove(atOffsets: indexSet)
                        }
                    }
                }
                
                
                if courses.isEmpty {
                    VStack {
                        Image(systemName: "app.dashed")
                            .font(.largeTitle.weight(.medium))
                            .imageScale(.large)
                        
                            .foregroundColor(.secondary)
                        Text("No courses")
                            .font(.title.weight(.bold))
                            .foregroundColor(.secondary)
                        HStack {
                            Text("Click the")
                            Image(systemName: "plus")
                            Text("to add one!")
                        }
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("TimeTabler")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        courses.append(.init(time: "", code: "", room: ""))
                    }, label: {
                        Image(systemName: "plus")
                    })
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    NavigationLink(destination: AboutView(), label: {
                        Image(systemName: "info.circle")
                    })
                })
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
