//
//  CalorieCounterView.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 18/09/2023.
//

import UIKit
import DGCharts
import Combine

enum NutrientType {
    case protein, carbohydrate, fat, calories
}

protocol CalorieCounterViewProtocol: UIViewController, AnyObject {
    var presenter: CalorieCounterPresenterProtocol? { get set }
}

enum ServingConstants {
    static let calories = "Calories: "
    static let calcium = "Calcium: "
    static let fat = "Fat: "
    static let fiber = "Fiber: "
    static let carbohydrate = "Carbohydrate: "
    static let lineBreak = "\n"
}

final class CalorieCounterView: UIViewController, CalorieCounterViewProtocol {
    private enum Constants {
        static let itemWidthMargin: CGFloat = 40.0
        static let fontSize: CGFloat = 16.0
        static let greatestFiniteMagnitude: CGFloat = .greatestFiniteMagnitude
    }
    
    var presenter: CalorieCounterPresenterProtocol?
    private var cancellables = Set<AnyCancellable>()
    private var ingredients: [FirebaseFoodResponse] { return presenter?.ingredients ?? [] }
    
    private lazy var overallCaloriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Calorie Counter"
        return label
    }()
    
    private lazy var pieChartView: PieChartView = {
        let chart = PieChartView()
        chart.holeRadiusPercent = 0.7
        chart.drawEntryLabelsEnabled = false
        chart.drawHoleEnabled = false
        return chart
    }()
    
    private lazy var addedProductsTableView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        Home.Layout.apply(layout)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchIngredients()
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GeneralStyle.mainBackgroundColor
        setupSubview()
        setupAutoLayout()
        setupDelegates()
        addBindings()
    }
}

private extension CalorieCounterView {
    func addBindings() {
        presenter?.ingredientsPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                self?.addedProductsTableView.reloadData()
                self?.updatePieChart()
            }).store(in: &cancellables)
    }
    
    func setupDelegates() {
        addedProductsTableView.register(CalorieCounterCell.self, forCellWithReuseIdentifier: CalorieCounterCell.identifier)
        addedProductsTableView.dataSource = self
        addedProductsTableView.delegate = self
    }
    
    func updatePieChart() {
        let entry1 = PieChartDataEntry(value: calculateTotal(for: .protein), label: "Proteins")
        let entry2 = PieChartDataEntry(value: calculateTotal(for: .carbohydrate), label: "Carbohydrates")
        let entry3 = PieChartDataEntry(value: calculateTotal(for: .fat), label: "Fats")
        let entry4 = PieChartDataEntry(value: calculateTotal(for: .calories), label: "Calories")
        let dataSet = PieChartDataSet(entries: [entry1, entry2, entry3, entry4], label: "")
        dataSet.colors = ChartColorTemplates.colorful()
        
        pieChartView.data = PieChartData(dataSet: dataSet)
    }
    
    func setupSubview() {
        view.addSubviewAndDisableAutoresizing(pieChartView)
        view.addSubviewAndDisableAutoresizing(overallCaloriesLabel)
        view.addSubviewAndDisableAutoresizing(addedProductsTableView)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            overallCaloriesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overallCaloriesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pieChartView.topAnchor.constraint(equalTo: overallCaloriesLabel.bottomAnchor),
            pieChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pieChartView.heightAnchor.constraint(equalToConstant: 300),
            
            addedProductsTableView.topAnchor.constraint(equalTo: pieChartView.bottomAnchor),
            addedProductsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addedProductsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addedProductsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func calculateTotal(for nutrient: NutrientType) -> Double {
        var totalSum = 0.0

        ingredients.forEach { response in
            for serving in response.servings {
                let value: String?
                switch nutrient {
                case .protein:
                    value = serving.protein
                case .carbohydrate:
                    value = serving.carbohydrate
                case .fat:
                    value = serving.fat
                case .calories:
                    value = serving.calories
                }
                totalSum += Double(value ?? "0") ?? 0.0
            }
        }

        return totalSum
    }
    
    func buildText(from serving: Serving) -> String {
        var text = ""
        if let calories = serving.calories { text += "\(ServingConstants.calories)\(calories)\(ServingConstants.lineBreak)" }
        if let calcium = serving.calcium { text += "\(ServingConstants.calcium)\(calcium)\(ServingConstants.lineBreak)" }
        if let fat = serving.fat { text += "\(ServingConstants.fat)\(fat)\(ServingConstants.lineBreak)" }
        if let fiber = serving.fiber { text += "\(ServingConstants.fiber)\(fiber)\(ServingConstants.lineBreak)" }
        if let carbohydrate = serving.carbohydrate { text += "\(ServingConstants.carbohydrate)\(carbohydrate)\(ServingConstants.lineBreak)" }
        return text
    }

    func calculateCellSize(from text: String, collectionViewWidth: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let maxWidth = collectionViewWidth - Constants.itemWidthMargin
        let maxHeight: CGFloat = .greatestFiniteMagnitude
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        
        let textRect = NSString(string: text).boundingRect(
            with: CGSize(width: maxWidth, height: maxHeight),
            options: options,
            attributes: attributes,
            context: nil
        )
        
        return CGSize(width: maxWidth, height: textRect.height)
    }
}

extension CalorieCounterView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalorieCounterCell.identifier, for: indexPath) as? CalorieCounterCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: ingredients[indexPath.row])
        cell.configure(with: ingredients[indexPath.row].servings.first!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let serving = ingredients[indexPath.row].servings.first else {
            return CGSize(width: 0, height: 0)
        }
        
        let text = buildText(from: serving)
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: Constants.fontSize)]
        
        return calculateCellSize(from: text, collectionViewWidth: collectionView.frame.width, attributes: attributes)
    }
}



