//
//  TodoView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject var todoView: TodoList
    @State var project: Project
    @State var parentId : String
    @State var parentTitle : String
    @State private var searchText = ""
    @State var isSearchBarVisible = false
    @State var isAddViewVisible = false
    @State var isSearchViewVisible = false
    @State var isSearchEnable = false
    @State var selectedStatus:SearchFilter.Status = SearchFilter.Status.ALL
    @State var isAddView = false
    @State var selectedLimit : SearchFilter.Limit = SearchFilter.Limit.FIVE
    @State var currentIndex = 0
    @State var currentViewState = 1
    @State var searchType: SearchFilter.OrderType
    let filter:Filter = Filter()
    let searchFilter : SearchFilter = SearchFilter()
    
    init( project:Project) {
        self.project = project
        self.parentId = project.id
        self.parentTitle = project.title
        self.searchType = project.order
    }
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    HStack {
                        Text(parentTitle)
                            .padding(.horizontal)
                            .foregroundColor(.cyan)
                        
                        Image(systemName: "plus.app")
                            .onTapGesture {
                                isAddViewVisible.toggle()
                            }
                            .imageScale(.large)
                        Image(systemName: "line.3.horizontal")
                            .onTapGesture {
                                isSearchViewVisible.toggle()
                            }
                            .frame(width: 30, height: 40)
                            .imageScale(.large)
                    }
                    if isSearchViewVisible {
                        HStack {
                            Spacer()
                            if isSearchBarVisible {
                                SearchBar(text: $searchText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        isSearchEnable.toggle()
                                    }
                            } else {
                                Button(action: {
                                    isSearchBarVisible.toggle()
                                }) {
                                    Image(systemName: "magnifyingglass")
                                }
                                .padding(.trailing, 10)
                                .frame(width: 90)
                            }
                            Picker(selection: $selectedStatus) {
                                Text("status").tag(SearchFilter.Status.ALL)
                                Text("completed").tag(SearchFilter.Status.COMPLETED)
                                Text("uncompleted").tag(SearchFilter.Status.UNCOMPLETED)
                            } label: {
                                HStack{
                                    Text("picker")
                                    Text("selectedStatus")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                            
                            Picker(selection: $selectedLimit) {
                                Text("5").tag(SearchFilter.Limit.FIVE)
                                Text("10").tag(SearchFilter.Limit.TEN)
                                Text("15").tag(SearchFilter.Limit.FIFTEEN)
                            } label: {
                                HStack{
                                    Text("limit")
                                    Text("selectedLimit")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                                    .onChange(of: selectedLimit) { newValue in
                                        currentIndex = 0
                                    }

                        }
                    }
                    if isAddViewVisible {
                        AddTodoView(parentId: parentId)
                    }
                    List {
                        ForEach(TodoDataBase.shared.get()) { todo in
                            TodoRowView(todo: todo)
                        }
                        
                    }
                    .navigationBarBackButtonHidden(true)
                    .padding()
                            .onChange(of: searchText) { newValue in
                                isSearchEnable = !newValue.isEmpty
                            }

                    HStack {
                        
                        if currentPages > 1 {
                            Button("Previous") {
                                if currentIndex > 0 {
                                    currentIndex -= selectedLimit.rawValue
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        if totalPages > 0 {
                            Text("\(currentPages)/\(totalPages)")
                                .font(.headline)
                                .padding(.horizontal)
                                .onChange(of: currentPages > totalPages) { conditionMet in
                                    if conditionMet {
                                        setCurrentPage()
                                    }
                                }
                        }
                        
                        if currentPages < totalPages {
                            Button ("Next") {
                                currentIndex += selectedLimit.rawValue
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            Spacer()
            
            var totalPages: Int {
                let totalCount = searchResults.count
                let pages = (totalCount + selectedLimit.rawValue - 1)  / selectedLimit.rawValue
                return max(pages, 1)
            }

            var currentPages:Int {
                var page = currentIndex/selectedLimit.rawValue + 1
                if page > totalPages  {
                    page = totalPages
                }
                 return max(page, 1)
            }
            
            var searchResults: [Todo] {

                searchFilter.setAttribute(attribute: searchText)
                searchFilter.setSelectedStatus(status: selectedStatus)
                searchFilter.setParentId(parentId: parentId)
                searchFilter.setLimit(limit: selectedLimit)
                searchFilter.setSkip(skip: 0)
                filter.setSearchFilter(searchItem: searchFilter, type: searchType)

                let todos = isSearchEnable ? Filter().getSearchFilter() : TodoList().getTodos(status: selectedStatus, parentId: parentId)

                return todos
            }
            
            var paginatedTodo: [Todo] {
                let startIndex = max(currentIndex, 0)
                let endIndex = min(startIndex + selectedLimit.rawValue, searchResults.count)
                
                if startIndex <= endIndex {
                    return Array(searchResults[startIndex..<endIndex])
                }
                
                return searchResults
            }
            
            var addedTodos : [Todo] {
                 todoView.getTodos(status: selectedStatus, parentId: parentId)
            }
        }
    }

    func setCurrentPage() {
        currentIndex -= selectedLimit.rawValue
    }

    func setSearchFalse(completion: (Bool) -> Void) {
        self.isSearchEnable.toggle()
    }
}

struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle()).frame(maxWidth: .infinity)
                
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Menu")
                }
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    var parentId:String
    static var previews: some View {
        AppView()
            .environmentObject(TodoList())
    }
}


