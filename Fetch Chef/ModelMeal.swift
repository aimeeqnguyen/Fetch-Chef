//
//  ModelMeal.swift
//  Fetch Chef
//
//  Created by Aimee Nguyen on 6/18/23.
//

import Foundation
import Combine
import SwiftUI

//Type hashable to iterate over the array
struct Meals: Hashable, Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

struct MealsResponse: Codable {
    let meals: [Meals]
}

struct MealImage: View {
    let urlString: String
    //State annotated property
    //Once this changes, the view will update itself
    @State var data: Data?
    var body: some View {
        if let data = data, let uiimage = UIImage(data:data) {
            Image(uiImage:uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .background(Color.pink)
        }
        else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .background(Color.pink)
                .onAppear{
                    fetchData()
                }
        }
        
    }
    private func fetchData() {
        guard let url = URL(string: urlString) else {
            return
        }
        let response = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        response.resume()
    }
}

//Redirect the user to the detailed view of the recipe
struct IngredientView: View {
    let meal: Meals
    //Each view will have the name of the recipe the user is looking at
    var body: some View {
        navigationTitle(meal.strMeal)
        Text(meal.idMeal)
        Text("Ingredients")
            .bold()
        Text("Instruction")
        
    }
}
    

class ViewModel: ObservableObject {
    //To have the array update as needed
    @Published var meals: [Meals] = []
    //Fetching data
    func fetchData () {
        guard let url = URL(string:"https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            return
        }
        //Weak self = prevent memeory leakage
        let response = URLSession.shared.dataTask(with: url) {[weak self]data,_,error in
            guard let data = data, error == nil else {
                return
            }
            do {
                //Parse through the JSON data
                let data = try JSONDecoder().decode(MealsResponse.self, from: data)
                DispatchQueue.main.async {
                    //Access the JSON object by looking at meals property
                    self?.meals = data.meals
                }
            }
            catch {
                print(error)
            }
        }
        response.resume()
    }
}

//Caching layer -for when users scroll through recipes
//Scrolling feature with indication on
//struct SrcollFeature: View {
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: true, content: {
//            VStack {
//                ForEach(0..<50) { index in
//                    Rectangle()
//                        .fill(Color.orange)
//                        .frame(height: 200)
//                }
//            }
//        })
//
//    }
//}
