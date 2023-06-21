//
//  ContentView.swift
//  Fetch Chef
//
//  Created by Aimee Nguyen on 6/18/23.
//

import SwiftUI


struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var selectedMeal: Meals?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.meals, id: \.self) {meals in
                    HStack{
                        MealImage(urlString: meals.strMealThumb)
                        Text(meals.strMeal)
                            .bold()
                        NavigationLink(destination: IngredientView(meal: meals)) { //, tag: meals, selection: $selectedMeal
                            EmptyView()
                        }
                    }
                    .padding(5)
                    .onTapGesture {
                        selectedMeal = meals // Set the selected meal when a recipe is tapped
                        
                    }
                }
            }
            .navigationTitle("Fetch Foodie")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

