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
    @State var parentId : Int64
    @State var parentTitle : String
    @State private var searchText = ""
    @State var isSearchBarVisible = false
    @State var isAddViewVisible = false
    @State var isSearchViewVisible = false
    @State var isSearchEnable = false
    @State var result = TodoList.shared.todos
    @State var selectedStatus:SearchFilter.Status = SearchFilter.Status.ALL
    @State var fontSize : CGFloat = ApplicationTheme.shared.fontSize.rawValue
    @State var fontFamily : String = ApplicationTheme.shared.fontFamily.rawValue
    @State var isAddView = false
    @State var selectedLimit : SearchFilter.Limit = SearchFilter.Limit.FIVE
    @State var currentIndex = 0
    @State var currentViewState = 1
    @State var themeColor : Color = ApplicationTheme.shared.getDefaultColor()
    let filter:Filter = Filter()
    let searchFilter : SearchFilter = SearchFilter()

    
    var searchResults: [Todo] {
        get {
            if isSearchEnable {
                searchFilter.setAttribute(attribute: searchText)
                searchFilter.setSelectedStatus(status: selectedStatus)
                searchFilter.setParentId(parentId: parentId)
                searchFilter.setLimit(limit: selectedLimit)
                searchFilter.setSkip(skip: 0)
                filter.setSearchFilter(searchItem: searchFilter)
                
                return Filter().getSearchFilter()
            }
            return TodoList.shared.getTodos(status: selectedStatus, parentId: parentId)
        }
        set(newSearchResults) {
            self.searchResults = newSearchResults
        }
    }
    
    var paginatedTodo: [Todo] {
        get {
            let startIndex = max(currentIndex, 0)
            let endIndex = min(startIndex + selectedLimit.rawValue, searchResults.count)
            
            if startIndex <= endIndex {
                return Array(searchResults[startIndex..<endIndex])
            }
            
            return searchResults
        }
        set(newPaginatedTodo) {
            let startIndex = max(currentIndex, 0)
            let endIndex = startIndex + newPaginatedTodo.count
            let clampedEndIndex = min(endIndex, searchResults.count)
            let newSearchResults = Array(searchResults[startIndex..<clampedEndIndex])
            searchResults = newSearchResults
        }
    }
    
    
    init( project:Project) {
        self.project = project
        parentId = project.id
        parentTitle = project.getTitle()
        result = TodoList.shared.getTodos(status: selectedStatus, parentId: parentId)
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
                            .foregroundColor(themeColor)
                        Image(systemName: "line.3.horizontal")
                            .onTapGesture {
                                isSearchViewVisible.toggle()
                            }
                            .frame(width: 30, height: 40)
                            .imageScale(.large)
                            .foregroundColor(themeColor)
                    }
                    if isSearchViewVisible {
                        HStack {
                            Spacer()
                            if isSearchBarVisible {
                                SearchBar(text: $searchText)
                                    .frame(maxWidth: .infinity)
                                    .font(Font.custom(fontFamily, size : fontSize))
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
                                .foregroundColor(themeColor)
                            }
                            Picker(selection: $selectedStatus) {
                                Text("status").tag(SearchFilter.Status.ALL)
                                Text("completed").tag(SearchFilter.Status.COMPLETED)
                                Text("uncompleted").tag(SearchFilter.Status.UNCOMPLETED)
                            } label: {
                                HStack{
                                    Text("picker")
                                    Text("selectedStatus")
                                        .font(Font.custom(fontFamily, size : fontSize))
                                        .foregroundColor(.white)
                                }
                            }
                            .pickerStyle(MenuPickerStyle()).accentColor(ApplicationTheme.shared.defaultColor.color)
                            .padding(.horizontal)
                            .foregroundColor(themeColor)
                            
                            Picker(selection: $selectedLimit) {
                                Text("5").tag(SearchFilter.Limit.FIVE)
                                Text("10").tag(SearchFilter.Limit.TEN)
                                Text("15").tag(SearchFilter.Limit.FIFTEEN)
                            } label: {
                                HStack{
                                    Text("limit")
                                    Text("selectedLimit")
                                        .font(Font.custom(fontFamily, size: 18))
                                        .foregroundColor(.white)
                                }
                            }
                            .pickerStyle(MenuPickerStyle()).accentColor(ApplicationTheme.shared.defaultColor.color)
                            .padding(.horizontal)
                            .foregroundColor(themeColor)
                            
                            .onChange(of: selectedLimit) { newValue in
                                currentIndex = 0
                            }
                            
                        }
                    }
                    if isAddViewVisible {
                        AddTodoView(parentId: parentId)
                    }
                    
                    List {
                        ForEach(paginatedTodo) { todo in
                            TodoRowView(todo: todo)
                        }
                        .onMove(perform: { indices, newOffset in
                            moveItem(from: indices.first!, to: newOffset)
                        })
                    }
                    .navigationBarBackButtonHidden(false).foregroundColor(ApplicationTheme.shared.defaultColor.color)
                    .padding()
                    
                    HStack {
                        
                        if currentPages > 1 {
                            Button("Previous") {
                                if currentIndex > 0 {
                                    currentIndex -= selectedLimit.rawValue
                                }
                            }
                            .padding(.horizontal)
                            .font(Font.custom(fontFamily, size : fontSize))
                        }
                        
                        if totalPages > 0 {
                            Text("\(currentPages)/\(totalPages)")
                                .font(.headline)
                                .padding(.horizontal)
                                .font(Font.custom(fontFamily, size : fontSize))
                                .onChange(of: currentPages > totalPages || currentIndex >= currentPages * selectedLimit.rawValue ) { conditionMet in
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
                            .font(Font.custom(fontFamily, size : fontSize))
                        }
                    }
                    .foregroundColor(themeColor)
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
        }
    }

    func moveItem(from source:Int, to destination:Int ) {
        
        todoView.todos = TodoTable.shared.get(parentId: parentId)
        let moveItem = todoView.todos.remove(at: source)
        todoView.todos.insert(moveItem, at: destination)

        TodoTable.shared.updateTodoTable()
        todoView.todos = TodoTable.shared.get(parentId: parentId)
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
    @State var fontFamily : String = ApplicationTheme.shared.fontFamily.rawValue
    @State var fontSize : CGFloat = ApplicationTheme.shared.fontSize.rawValue
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle()).frame(maxWidth: .infinity)
                .font(Font.custom(fontFamily, size : fontSize))
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var fontFamily : String = ApplicationTheme.shared.fontFamily.rawValue
    @State var fontSize : CGFloat = ApplicationTheme.shared.fontSize.rawValue
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Menu")
                        .font(Font.custom(fontFamily, size : fontSize))
                    
                }
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    var parentId:String
    static var previews: some View {
        AppView()
            .environmentObject(TodoList.shared)
    }
}


