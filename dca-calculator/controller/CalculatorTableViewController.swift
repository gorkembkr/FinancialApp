//
//  CalculatorTableViewController.swift
//  dca-calculator
//
//  Created by Gorkem BekAr on 4.03.2022.
//

import UIKit
import Combine

class CalculatorTableViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    @IBOutlet weak var  dateSlider: UISlider!
    
    var asset: Asset?
    
    @Published private var initialDateOfInvestmentIndex: Int?
    @Published private var initialInvestmentAmount: Int?
    @Published private var monthlyDollarCostAveragingAmount: Int?
    private var subsribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
        setupDateSlider()
        observeForm()
    }
    private func setupViews(){
        symbolLabel.text = asset?.searchResult.symbol
        nameLabel.text = asset?.searchResult.name
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency.addBreackets()
            investmentAmountCurrencyLabel.text = asset?.searchResult.currency
        }
    }
    private func setupTextFields(){
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
        initialDateOfInvestmentTextField.delegate = self
    }
    private func setupDateSlider(){
        if let count = asset?.timeSeriesMontlyAdjusted.getMonthInfos().count{
            let dateSliderCount = count - 1
            dateSlider.maximumValue = dateSliderCount.floatValue
        }
    }
    private func observeForm(){
        $initialDateOfInvestmentIndex.sink { [weak self] index in
            guard let index = index else{return}
            self?.dateSlider.value = index.floatValue
            if let dateString = self?.asset?.timeSeriesMontlyAdjusted.getMonthInfos()[index].date.MMYYFormat{
                self?.initialDateOfInvestmentTextField.text = dateString
            }
        }.store(in: &subsribers)
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink{ [weak self] (text) in
            self?.initialInvestmentAmount = Int(text) ?? 0
        }.store(in: &subsribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDollarCostAveragingTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink{ [weak self] (text) in
            self?.monthlyDollarCostAveragingAmount = Int(text) ?? 0
        }.store(in: &subsribers)
        
        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDollarCostAveragingAmount, $initialDateOfInvestmentIndex).sink { (initialInvestmentAmount , monthlyDollarCostAveragingAmount , initialDateOfInvestmentIndex) in
            print("\(initialInvestmentAmount), \(monthlyDollarCostAveragingAmount) ,\(initialDateOfInvestmentIndex)")
        }.store(in: &subsribers)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDateSelection",
           let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
           let TimeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            dateSelectionTableViewController.timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted
            dateSelectionTableViewController.selectedIndex = initialDateOfInvestmentIndex
            dateSelectionTableViewController.didSelectDate = { [weak self] index in
                self?.handleDateSelection(at: index)
            }
        }
    }
    private func handleDateSelection(at index: Int){
        guard navigationController?.visibleViewController is DateSelectionTableViewController else{ return}
        navigationController?.popViewController(animated: true)
        if let monthInfos = asset?.timeSeriesMontlyAdjusted.getMonthInfos(){
            initialDateOfInvestmentIndex = index
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            initialDateOfInvestmentTextField.text = dateString
        }
    }
    @IBAction func dateSliderDidChange(_ sender: UISlider){
        initialDateOfInvestmentIndex = Int(sender.value)
        
    }
}

extension CalculatorTableViewController: UITextViewDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestmentTextField {
            performSegue(withIdentifier: "showDateSelection", sender: asset?.timeSeriesMontlyAdjusted)
            return false
        }
       return true
        }
    }
