//
//  TodoView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct TodoView: View {

    @EnvironmentObject var todoView: TodoList
    @State var project: APIProject
    @State var parentId: String
    @State var parentTitle: String
    @State private var searchText = ""
    @State var isSearchBarVisible = false
    @State var isAddViewVisible = false
    @State var isSearchViewVisible = false
    @State var isSearchEnable = false
    @State var toastMessage = ""
    @State var isToastVisible = false
    @State var result = TodoList.shared.apiTodos
    @State var selectedStatus: SearchFilter.Status = SearchFilter.Status.ALL
    @State var fontSize: ApplicationTheme.FontSize = ApplicationTheme.shared.fontSize
    @State var fontFamily: ApplicationTheme.FontFamily = ApplicationTheme.shared.fontFamily
    @State var defaultColor: ApplicationTheme.DefaultColor = ApplicationTheme.shared.defaultColor
    @State var isAddView = false
    @State var selectedLimit: SearchFilter.Limit = SearchFilter.Limit.FIVE
    @State var currentIndex = 0
    @State var currentViewState = 1
    @State var token: String
    let filter: Filter = Filter()
    let searchFilter: SearchFilter = SearchFilter()
    @State var todos: [APITodo] = []

    var paginatedTodo: [APITodo] {
        get {
            let startIndex = max(currentIndex, 0)
            let endIndex = min(startIndex + selectedLimit.rawValue, reload().count)
            let result = reload()
            if startIndex <= endIndex {
                return Array(result[startIndex..<endIndex])
            }

            return result
        }
        set(newPaginatedTodo) {
            let startIndex = max(currentIndex, 0)
            let endIndex = startIndex + newPaginatedTodo.count
            var searchResults = reload()
            let clampedEndIndex = min(endIndex, searchResults.count)
            let newSearchResults = Array(searchResults[startIndex..<clampedEndIndex])
            searchResults = newSearchResults
        }
    }

    init(project: APIProject, token: String) {
        self.project = project
        parentId = project.getId()
        parentTitle = project.getTitle()
        self.token = token
    }

    var body: some View {
        ZStack {
            Color.white
                    .edgesIgnoringSafeArea(.all)
            NavigationView {
                VStack {
                    HStack {
                        Text(parentTitle)
                                .padding(.horizontal)
                                .padding()
                                .foregroundColor(.cyan)
                        Spacer()
                        Image(systemName: Properties.plusAppImage)
                                .onTapGesture {
                                    isAddViewVisible.toggle()
                                }
                                .imageScale(.large)
                                .foregroundColor(defaultColor.color)
                        Spacer()
                        Image(systemName: Properties.threeLineImage)
                                .onTapGesture {
                                    isSearchViewVisible.toggle()
                                }
                                .frame(width: 30, height: 40)
                                .imageScale(.large)
                                .foregroundColor(defaultColor.color)
                                .padding()
                                .onChange(of: searchText) { text in
                                    if text.isEmpty {
                                        isSearchEnable = false
                                    } else {
                                        isSearchEnable = true
                                    }
                                }
                    }
                    if isSearchViewVisible {
                        HStack {
                            Spacer()
                            if isSearchBarVisible {
                                SearchBar(text: $searchText)
                                        .frame(width: .infinity)
                                        .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            isSearchEnable.toggle()
                                        }
                            } else {
                                Button(action: {
                                    isSearchBarVisible.toggle()
                                }) {
                                    Image(systemName: Properties.searchImage)
                                }
                                        .padding(.trailing, 10)
                                        .frame(width: 90)
                                        .foregroundColor(defaultColor.color)
                            }
                            Picker(selection: $selectedStatus) {
                                Text(Properties.status).tag(SearchFilter.Status.ALL)
                                Text(Properties.complete).tag(SearchFilter.Status.COMPLETED)
                                Text(Properties.unCompleted).tag(SearchFilter.Status.UNCOMPLETED)
                            } label: {
                                HStack {
                                    Text(Properties.picker)
                                    Text(Properties.selectedStatus)
                                            .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                                            .foregroundColor(.white)
                                }
                            }
                                    .pickerStyle(MenuPickerStyle()).accentColor(defaultColor.color)
                                    .padding(.horizontal)
                                    .onChange(of: selectedStatus) { status in
                                        reload()
                                    }

                            Picker(selection: $selectedLimit) {
                                Text(Properties.five).tag(SearchFilter.Limit.FIVE)
                                Text(Properties.ten).tag(SearchFilter.Limit.TEN)
                                Text(Properties.fifteen).tag(SearchFilter.Limit.FIFTEEN)
                            } label: {
                                HStack {
                                    Text(Properties.limit)
                                    Text(Properties.selectedLimit)
                                            .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                                            .foregroundColor(.white)
                                }
                            }
                                    .pickerStyle(MenuPickerStyle()).accentColor(defaultColor.color)
                                    .padding(.horizontal)

                                    .onChange(of: selectedLimit) { newValue in
                                        currentIndex = 0
                                        reload()
                                    }

                        }
                    }
                    if isAddViewVisible {
                        AddTodoView(parentId: parentId, token: token)
                    }

                    List {
                        ForEach(paginatedTodo) { todo in
                            TodoRowView(todo: todo, token: token)
                        }
                                .onMove { sourceIndices, destination in
                                    let source = sourceIndices.map {
                                        $0 + (currentPage - 1) * selectedLimit.rawValue
                                    }
                                    let destinationIndex = destination + (currentPage - 1) * selectedLimit.rawValue
                                    let itemDestination = min(max(destinationIndex, 0), todoView.todos.count)

                                    todoView.todos.move(fromOffsets: IndexSet(source), toOffset: itemDestination)
                                }
                    }

                            .navigationBarBackButtonHidden(false).foregroundColor(defaultColor.color)
                            .padding()

                    HStack {

                        if currentPage > 1 {
                            Button(Properties.previous) {
                                if currentIndex > 0 {
                                    currentIndex -= selectedLimit.rawValue
                                }
                            }
                                    .padding(.horizontal)
                                    .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                        }

                        if totalPages > 0 && !paginatedTodo.isEmpty {
                            Text("\(currentPage)/\(totalPages)")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                                    .onChange(of: currentPage > totalPages || currentIndex >= currentPage * selectedLimit.rawValue) { conditionMet in
                                        if conditionMet {
                                            setCurrentPage()
                                        }
                                    }
                        }

                        if currentPage < totalPages {
                            Button(Properties.next) {
                                currentIndex += selectedLimit.rawValue
                            }
                                    .padding(.horizontal)
                                    .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                        }
                    }
                            .foregroundColor(defaultColor.color)
                }
            }
            Spacer()

            var totalPages: Int {
                let totalCount = reload().count
                let pages = (totalCount + selectedLimit.rawValue - 1) / selectedLimit.rawValue
                return max(pages, 1)
            }

            var currentPage: Int {
                var page = currentIndex / selectedLimit.rawValue + 1
                if page > totalPages {
                    page = totalPages
                }
                return max(page, 1)
            }
        }
                .toast(isPresented: $isToastVisible, message: $toastMessage)
    }

    func setCurrentPage() {
        currentIndex -= selectedLimit.rawValue
    }

    func setSearchFalse(completion: (Bool) -> Void) {
        self.isSearchEnable.toggle()
    }

    func reload() -> [APITodo]{
        if isSearchEnable {
            searchFilter.setAttribute(attribute: searchText)
            searchFilter.setSelectedStatus(status: selectedStatus)
            searchFilter.setParentId(parentId: parentId)
            searchFilter.setLimit(limit: selectedLimit)
            searchFilter.setSkip(skip: 0)
            do {
                try filter.setSearchFilter(searchItem: searchFilter)
            } catch {
                toastMessage = "\(error)"
                isToastVisible.toggle()
            }
            todos = Filter().getSearchFilter()
        }

        TodoList.shared.getAll(token: token) { apiTodo in
            todos = apiTodo
        }

        todos = todos.filter {
            $0.getParentId() == parentId
        }

        if selectedStatus == SearchFilter.Status.COMPLETED {
            todos = todos.filter {
                $0.getStatus() == true
            }
        } else if selectedStatus == SearchFilter.Status.UNCOMPLETED {
            todos = todos.filter {
                $0.getStatus() == false
            }
        }
        return todos
    }

}

struct SearchBar: View {
    @Binding var text: String
    @State var fontFamily: String = ApplicationTheme.shared.fontFamily.rawValue
    @State var fontSize: CGFloat = ApplicationTheme.shared.fontSize.rawValue

    var body: some View {
        HStack {
            Image(systemName: Properties.searchImage)
                    .foregroundColor(.secondary)

            TextField(Properties.search, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).frame(maxWidth: .infinity)
                    .font(Font.custom(fontFamily, size: fontSize))
            Spacer()
        }
                .padding(.horizontal)
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var fontFamily: String = ApplicationTheme.shared.fontFamily.rawValue
    @State var fontSize: CGFloat = ApplicationTheme.shared.fontSize.rawValue

    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: Properties.leftImage)
                    Text(Properties.menu)
                            .font(Font.custom(fontFamily, size: fontSize))
                }
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    var parentId: String
    static var previews: some View {
        LoginView()
                .environmentObject(TodoList.shared)
    }
}


