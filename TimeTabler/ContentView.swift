//
//  ContentView.swift
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

struct ContentView: View {
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
                            HStack {
                                
                                let timeBinding: Binding<Date> = Binding(
                                    get: {
                                        dateFormatter.date(from: course.time.wrappedValue) ?? Date.now
                                    },
                                    set: { new in
                                        course.time.wrappedValue = dateFormatter.string(from: new)
                                    })
                                
                                DatePicker(selection: timeBinding, displayedComponents: .hourAndMinute, label: {})
                                TextField("Course", text: course.code)
                                TextField("Room", text: course.room)
                                Spacer()
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

struct AboutView: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack {
            Image("Icon")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(24)
            Text("TimeTabler")
                .font(.largeTitle.weight(.bold))
            Text("by BomberFish")
                .font(.title3.weight(.regular))
                .foregroundColor(.secondary)
            List {
                Section {
                    Button(action: {
                        openURL(.init(string: "https://github.com/BomberFish/TimeTabler")!)
                    }, label: {
                        Label("TimeTabler on Github", systemImage: "arrow.up.right.square")
                            .foregroundColor(.accentColor)
                    })
                }
                
                Section("Socials") {
                    Button(action: {
                        openURL(.init(string: "https://github.com/BomberFish")!)
                    }, label: {
                        Label("GitHub", systemImage: "arrow.up.right.square")
                            .foregroundColor(.accentColor)
                    })
                    Button(action: {
                        openURL(.init(string: "https://twitter.com/bomberfish77")!)
                    }, label: {
                        Label("Twitter", systemImage: "arrow.up.right.square")
                            .foregroundColor(.accentColor)
                    })
                    Button(action: {
                        openURL(.init(string: "https://bomberfish.ca")!)
                    }, label: {
                        Label("Website", systemImage: "arrow.up.right.square")
                            .foregroundColor(.accentColor)
                    })
                }
                
                Section("My other projects") {
                    Button(action: {
                        openURL(.init(string: "https://repo.sourceloc.net/packages/picasso")!)
                    }, label: {
                        Label {
                            Text("Picasso")
                        } icon: {
                            Image("Picasso")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(6)
                        }
                            .foregroundColor(.accentColor)
                    })
                    
                    Button(action: {
                        openURL(.init(string: "https://github.com/BomberFish/AppCommander")!)
                    }, label: {
                        Label {
                            Text("AppCommander")
                        } icon: {
                            Image("AppCommander")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(6)
                        }
                            .foregroundColor(.accentColor)
                    })
                }
            }
        }
        .navigationTitle("About")
    }
}

struct Course: Equatable, Identifiable, Codable {
    var id = UUID()
    
    var time: String
    var code: String
    var room: String
    
}

struct preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

class Haptic {
    static let shared = Haptic()
    
    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}
