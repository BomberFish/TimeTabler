//
//  AboutView.swift
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

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
