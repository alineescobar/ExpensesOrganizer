//
//  Templates.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 17/11/21.
//

import CoreData
import Foundation

func setPropertyTemplate(context: NSManagedObjectContext) {
    // Template
    let propertyTemplate = Template(context: context)
    propertyTemplate.name = NSLocalizedString("Property", comment: "")
    propertyTemplate.paymentMethod = nil
    propertyTemplate.templateID = UUID()
    propertyTemplate.templateIconName = "House"
    propertyTemplate.isExpense = true
    
    let mutableItems = propertyTemplate.items?.mutableCopy() as? NSMutableSet
    
    let rentItem = Item(context: context)
    rentItem.name = NSLocalizedString("Rent", comment: "")
    rentItem.value = 0.0
    rentItem.recurrenceType = "Monthly"
    rentItem.template = propertyTemplate
    rentItem.recurrenceDate = Date()
    rentItem.paymentMethod = nil
    mutableItems?.add(rentItem)
    
    let condoFeeItem = Item(context: context)
    condoFeeItem.name = NSLocalizedString("CondoFee", comment: "")
    condoFeeItem.value = 0.0
    condoFeeItem.recurrenceType = "Monthly"
    condoFeeItem.template = propertyTemplate
    condoFeeItem.recurrenceDate = Date()
    condoFeeItem.paymentMethod = nil
    mutableItems?.add(condoFeeItem)
    
    let internetItem = Item(context: context)
    internetItem.name = NSLocalizedString("Internet", comment: "")
    internetItem.value = 0.0
    internetItem.recurrenceType = "Monthly"
    internetItem.template = propertyTemplate
    internetItem.recurrenceDate = Date()
    internetItem.paymentMethod = nil
    mutableItems?.add(internetItem)
    
    let powerItem = Item(context: context)
    powerItem.name = NSLocalizedString("Power", comment: "")
    powerItem.value = 0.0
    powerItem.recurrenceType = "Monthly"
    powerItem.template = propertyTemplate
    powerItem.recurrenceDate = Date()
    powerItem.paymentMethod = nil
    mutableItems?.add(powerItem)
    
    let waterItem = Item(context: context)
    waterItem.name = NSLocalizedString("Water", comment: "")
    waterItem.value = 0.0
    waterItem.recurrenceType = "Monthly"
    waterItem.template = propertyTemplate
    waterItem.recurrenceDate = Date()
    waterItem.paymentMethod = nil
    mutableItems?.add(waterItem)
    
    let gasItem = Item(context: context)
    gasItem.name = NSLocalizedString("Gas", comment: "")
    gasItem.value = 0.0
    gasItem.recurrenceType = "Monthly"
    gasItem.template = propertyTemplate
    gasItem.recurrenceDate = Date()
    gasItem.paymentMethod = nil
    mutableItems?.add(gasItem)
    
    let phoneItem = Item(context: context)
    phoneItem.name = NSLocalizedString("Phone", comment: "")
    phoneItem.value = 0.0
    phoneItem.recurrenceType = "Monthly"
    phoneItem.template = propertyTemplate
    phoneItem.recurrenceDate = Date()
    phoneItem.paymentMethod = nil
    mutableItems?.add(phoneItem)
    
    let marketItem = Item(context: context)
    marketItem.name = NSLocalizedString("Market", comment: "")
    marketItem.value = 0.0
    marketItem.recurrenceType = "Monthly"
    marketItem.template = propertyTemplate
    marketItem.recurrenceDate = Date()
    marketItem.paymentMethod = nil
    mutableItems?.add(marketItem)

    let propertyTaxItem = Item(context: context)
    propertyTaxItem.name = NSLocalizedString("PropertyTax", comment: "")
    propertyTaxItem.value = 0.0
    propertyTaxItem.recurrenceType = "Anually"
    propertyTaxItem.template = propertyTemplate
    propertyTaxItem.recurrenceDate = Date()
    propertyTaxItem.paymentMethod = nil
    mutableItems?.add(propertyTaxItem)
    
    let propertyInsuranceItem = Item(context: context)
    propertyInsuranceItem.name = NSLocalizedString("PropertyInsurance", comment: "")
    propertyInsuranceItem.value = 0.0
    propertyInsuranceItem.recurrenceType = "Anually"
    propertyInsuranceItem.template = propertyTemplate
    propertyInsuranceItem.recurrenceDate = Date()
    propertyInsuranceItem.paymentMethod = nil
    mutableItems?.add(propertyInsuranceItem)
    
    propertyTemplate.items = mutableItems?.copy() as? NSSet
}

func setCarTemplate(context: NSManagedObjectContext) {
    // Template
    let carTemplate = Template(context: context)
    carTemplate.name = NSLocalizedString("Car", comment: "")
    carTemplate.paymentMethod = nil
    carTemplate.templateID = UUID()
    carTemplate.templateIconName = "Car"
    carTemplate.isExpense = true
    
    let mutableItems = carTemplate.items?.mutableCopy() as? NSMutableSet
    
    let insuranceItem = Item(context: context)
    insuranceItem.name = NSLocalizedString("Insurance", comment: "")
    insuranceItem.value = 0.0
    insuranceItem.recurrenceType = "Monthly"
    insuranceItem.template = carTemplate
    insuranceItem.recurrenceDate = Date()
    insuranceItem.paymentMethod = nil
    mutableItems?.add(insuranceItem)
    
    let vehiclePropertyTaxItem = Item(context: context)
    vehiclePropertyTaxItem.name = NSLocalizedString("VehiclePropertyTax", comment: "")
    vehiclePropertyTaxItem.value = 0.0
    vehiclePropertyTaxItem.recurrenceType = "Anually"
    vehiclePropertyTaxItem.template = carTemplate
    vehiclePropertyTaxItem.recurrenceDate = Date()
    vehiclePropertyTaxItem.paymentMethod = nil
    mutableItems?.add(vehiclePropertyTaxItem)
    
    let gasolineItem = Item(context: context)
    gasolineItem.name = NSLocalizedString("Gasoline", comment: "")
    gasolineItem.value = 0.0
    gasolineItem.recurrenceType = "Weekly"
    gasolineItem.template = carTemplate
    gasolineItem.recurrenceDate = Date()
    gasolineItem.paymentMethod = nil
    mutableItems?.add(gasolineItem)
    
    let tuneUpItem = Item(context: context)
    tuneUpItem.name = NSLocalizedString("TuneUp", comment: "")
    tuneUpItem.value = 0.0
    tuneUpItem.recurrenceType = "Monthly"
    tuneUpItem.template = carTemplate
    tuneUpItem.recurrenceDate = Date()
    tuneUpItem.paymentMethod = nil
    mutableItems?.add(tuneUpItem)
    
    let garageItem = Item(context: context)
    garageItem.name = NSLocalizedString("Garage", comment: "")
    garageItem.value = 0.0
    garageItem.recurrenceType = "Monthly"
    garageItem.template = carTemplate
    garageItem.recurrenceDate = Date()
    garageItem.paymentMethod = nil
    mutableItems?.add(garageItem)
    
    carTemplate.items = mutableItems?.copy() as? NSSet
}

func setLeisureTemplate(context: NSManagedObjectContext) {
    let leisureTemplate = Template(context: context)
    leisureTemplate.name = NSLocalizedString("Leisure", comment: "")
    leisureTemplate.paymentMethod = nil
    leisureTemplate.templateID = UUID()
    leisureTemplate.templateIconName = "Martini"
    leisureTemplate.isExpense = true
    
    let mutableItems = leisureTemplate.items?.mutableCopy() as? NSMutableSet
    
    let streamingServicesItem = Item(context: context)
    streamingServicesItem.name = NSLocalizedString("StreamingServices", comment: "")
    streamingServicesItem.value = 0.0
    streamingServicesItem.recurrenceType = "Monthly"
    streamingServicesItem.template = leisureTemplate
    streamingServicesItem.recurrenceDate = Date()
    streamingServicesItem.paymentMethod = nil
    mutableItems?.add(streamingServicesItem)
    
    let deliveryItem = Item(context: context)
    deliveryItem.name = NSLocalizedString("Delivery", comment: "")
    deliveryItem.value = 0.0
    deliveryItem.recurrenceType = "Monthly"
    deliveryItem.template = leisureTemplate
    deliveryItem.recurrenceDate = Date()
    deliveryItem.paymentMethod = nil
    mutableItems?.add(deliveryItem)
    
    let dinnerItem = Item(context: context)
    dinnerItem.name = NSLocalizedString("DinnerAndEvents", comment: "")
    dinnerItem.value = 0.0
    dinnerItem.recurrenceType = "Monthly"
    dinnerItem.template = leisureTemplate
    dinnerItem.recurrenceDate = Date()
    dinnerItem.paymentMethod = nil
    mutableItems?.add(dinnerItem)
    
    let gymItem = Item(context: context)
    gymItem.name = NSLocalizedString("Gym", comment: "")
    gymItem.value = 0.0
    gymItem.recurrenceType = "Monthly"
    gymItem.template = leisureTemplate
    gymItem.recurrenceDate = Date()
    gymItem.paymentMethod = nil
    mutableItems?.add(gymItem)
    
    leisureTemplate.items = mutableItems?.copy() as? NSSet
}

func setStudyTemplate(context: NSManagedObjectContext) {
    let studyTemplate = Template(context: context)
    studyTemplate.name = NSLocalizedString("Study", comment: "")
    studyTemplate.paymentMethod = nil
    studyTemplate.templateID = UUID()
    studyTemplate.templateIconName = "GraduationCap"
    studyTemplate.isExpense = true
    
    let mutableItems = studyTemplate.items?.mutableCopy() as? NSMutableSet
    
    let schoolItem = Item(context: context)
    schoolItem.name = NSLocalizedString("School", comment: "")
    schoolItem.value = 0.0
    schoolItem.recurrenceType = "Monthly"
    schoolItem.template = studyTemplate
    schoolItem.recurrenceDate = Date()
    schoolItem.paymentMethod = nil
    mutableItems?.add(schoolItem)
    
    let collegeItem = Item(context: context)
    collegeItem.name = NSLocalizedString("College", comment: "")
    collegeItem.value = 0.0
    collegeItem.recurrenceType = "Monthly"
    collegeItem.template = studyTemplate
    collegeItem.recurrenceDate = Date()
    collegeItem.paymentMethod = nil
    mutableItems?.add(collegeItem)
    
    let courseItem = Item(context: context)
    courseItem.name = NSLocalizedString("Course", comment: "")
    courseItem.value = 0.0
    courseItem.recurrenceType = "Monthly"
    courseItem.template = studyTemplate
    courseItem.recurrenceDate = Date()
    courseItem.paymentMethod = nil
    mutableItems?.add(courseItem)
    
    studyTemplate.items = mutableItems?.copy() as? NSSet
}

func setBusinessTemplate(context: NSManagedObjectContext) {
    
    let businessTemplate = Template(context: context)
    businessTemplate.name = NSLocalizedString("Business", comment: "")
    businessTemplate.paymentMethod = nil
    businessTemplate.templateID = UUID()
    businessTemplate.templateIconName = "SuitcaseSimple"
    businessTemplate.isExpense = true
    
    let mutableItems = businessTemplate.items?.mutableCopy() as? NSMutableSet
    
    let rentItem = Item(context: context)
    rentItem.name = NSLocalizedString("Rent", comment: "")
    rentItem.value = 0.0
    rentItem.recurrenceType = "Monthly"
    rentItem.template = businessTemplate
    rentItem.recurrenceDate = Date()
    rentItem.paymentMethod = nil
    mutableItems?.add(rentItem)
    
    let employeeItem = Item(context: context)
    employeeItem.name = NSLocalizedString("Employees", comment: "")
    employeeItem.value = 0.0
    employeeItem.recurrenceType = "Monthly"
    employeeItem.template = businessTemplate
    employeeItem.recurrenceDate = Date()
    employeeItem.paymentMethod = nil
    mutableItems?.add(employeeItem)
    
    businessTemplate.items = mutableItems?.copy() as? NSSet
}

func setPetsTemplate(context: NSManagedObjectContext) {
    let petsTemplate = Template(context: context)
    petsTemplate.name = NSLocalizedString("Pets", comment: "")
    petsTemplate.paymentMethod = nil
    petsTemplate.templateID = UUID()
    petsTemplate.templateIconName = "Bug"
    petsTemplate.isExpense = true
    
    let mutableItems = petsTemplate.items?.mutableCopy() as? NSMutableSet
    
    let foodItem = Item(context: context)
    foodItem.name = NSLocalizedString("Food", comment: "")
    foodItem.value = 0.0
    foodItem.recurrenceType = "Monthly"
    foodItem.template = petsTemplate
    foodItem.recurrenceDate = Date()
    foodItem.paymentMethod = nil
    mutableItems?.add(foodItem)
    
    let veterinaryItem = Item(context: context)
    veterinaryItem.name = NSLocalizedString("Veterinary", comment: "")
    veterinaryItem.value = 0.0
    veterinaryItem.recurrenceType = "Monthly"
    veterinaryItem.template = petsTemplate
    veterinaryItem.recurrenceDate = Date()
    veterinaryItem.paymentMethod = nil
    mutableItems?.add(veterinaryItem)
    
    let neuteringItem = Item(context: context)
    neuteringItem.name = NSLocalizedString("Neutering", comment: "")
    neuteringItem.value = 0.0
    neuteringItem.recurrenceType = "Never"
    neuteringItem.template = petsTemplate
    neuteringItem.recurrenceDate = Date()
    neuteringItem.paymentMethod = nil
    mutableItems?.add(neuteringItem)
    
    let toysItem = Item(context: context)
    toysItem.name = NSLocalizedString("Toys", comment: "")
    toysItem.value = 0.0
    toysItem.recurrenceType = "Monthly"
    toysItem.template = petsTemplate
    toysItem.recurrenceDate = Date()
    toysItem.paymentMethod = nil
    mutableItems?.add(toysItem)
    
    let medicineItem = Item(context: context)
    medicineItem.name = NSLocalizedString("Medicine", comment: "")
    medicineItem.value = 0.0
    medicineItem.recurrenceType = "Monthly"
    medicineItem.template = petsTemplate
    medicineItem.recurrenceDate = Date()
    medicineItem.paymentMethod = nil
    mutableItems?.add(medicineItem)
    
    petsTemplate.items = mutableItems?.copy() as? NSSet
}

func setEmptyExpenseTemplate(context: NSManagedObjectContext) {
    let emptyTemplate = Template(context: context)
    emptyTemplate.name = NSLocalizedString("Others", comment: "")
    emptyTemplate.paymentMethod = nil
    emptyTemplate.templateID = UUID()
    emptyTemplate.templateIconName = "Atom"
    emptyTemplate.isExpense = true
    
    let mutableItems = emptyTemplate.items?.mutableCopy() as? NSMutableSet
    
    let emptyItem = Item(context: context)
    emptyItem.name = NSLocalizedString("iCloudStoragePlan", comment: "")
    emptyItem.value = 0.0
    emptyItem.recurrenceType = "Monthly"
    emptyItem.template = emptyTemplate
    emptyItem.recurrenceDate = Date()
    emptyItem.paymentMethod = nil
    mutableItems?.add(emptyItem)
    
    emptyTemplate.items = mutableItems?.copy() as? NSSet
}

func setSalaryTemplate(context: NSManagedObjectContext) {
    let salaryTemplate = Template(context: context)
    salaryTemplate.name = NSLocalizedString("Salary", comment: "")
    salaryTemplate.paymentMethod = nil
    salaryTemplate.templateID = UUID()
    salaryTemplate.templateIconName = "Money"
    salaryTemplate.isExpense = false
    
    let mutableItems = salaryTemplate.items?.mutableCopy() as? NSMutableSet
    
    let salaryItem = Item(context: context)
    salaryItem.name = NSLocalizedString("Salary", comment: "")
    salaryItem.value = 0.0
    salaryItem.recurrenceType = "Monthly"
    salaryItem.template = salaryTemplate
    salaryItem.recurrenceDate = Date()
    salaryItem.paymentMethod = nil
    mutableItems?.add(salaryItem)
    
    let fringeBenefitsItem = Item(context: context)
    fringeBenefitsItem.name = NSLocalizedString("FringeBenefits", comment: "")
    fringeBenefitsItem.value = 0.0
    fringeBenefitsItem.recurrenceType = "Monthly"
    fringeBenefitsItem.template = salaryTemplate
    fringeBenefitsItem.recurrenceDate = Date()
    fringeBenefitsItem.paymentMethod = nil
    mutableItems?.add(fringeBenefitsItem)
    
    salaryTemplate.items = mutableItems?.copy() as? NSSet
}

func setProfitTemplate(context: NSManagedObjectContext) {
    let profitTemplate = Template(context: context)
    profitTemplate.name = NSLocalizedString("Profits", comment: "")
    profitTemplate.paymentMethod = nil
    profitTemplate.templateID = UUID()
    profitTemplate.templateIconName = "TrendUp"
    profitTemplate.isExpense = false
    
    let mutableItems = profitTemplate.items?.mutableCopy() as? NSMutableSet
    
    let stocksItem = Item(context: context)
    stocksItem.name = NSLocalizedString("Stocks", comment: "")
    stocksItem.value = 0.0
    stocksItem.recurrenceType = "Weekly"
    stocksItem.template = profitTemplate
    stocksItem.recurrenceDate = Date()
    stocksItem.paymentMethod = nil
    mutableItems?.add(stocksItem)
    
    let fixedIncomesItem = Item(context: context)
    fixedIncomesItem.name = NSLocalizedString("FixedIncomes", comment: "")
    fixedIncomesItem.value = 0.0
    fixedIncomesItem.recurrenceType = "Weekly"
    fixedIncomesItem.template = profitTemplate
    fixedIncomesItem.recurrenceDate = Date()
    fixedIncomesItem.paymentMethod = nil
    mutableItems?.add(fixedIncomesItem)
    
    let variableIncomesItem = Item(context: context)
    variableIncomesItem.name = NSLocalizedString("VariableIncomes", comment: "")
    variableIncomesItem.value = 0.0
    variableIncomesItem.recurrenceType = "Weekly"
    variableIncomesItem.template = profitTemplate
    variableIncomesItem.recurrenceDate = Date()
    variableIncomesItem.paymentMethod = nil
    mutableItems?.add(variableIncomesItem)
    
    profitTemplate.items = mutableItems?.copy() as? NSSet
}

func setEmptyIncomeTemplate(context: NSManagedObjectContext) {
    let emptyTemplate = Template(context: context)
    emptyTemplate.name = NSLocalizedString("Others", comment: "")
    emptyTemplate.paymentMethod = nil
    emptyTemplate.templateID = UUID()
    emptyTemplate.templateIconName = "Atom"
    emptyTemplate.isExpense = false

    let mutableItems = emptyTemplate.items?.mutableCopy() as? NSMutableSet
    
    let emptyItem = Item(context: context)
    emptyItem.name = NSLocalizedString("Cashback", comment: "")
    emptyItem.value = 0.0
    emptyItem.recurrenceType = "Monthly"
    emptyItem.template = emptyTemplate
    emptyItem.recurrenceDate = Date()
    emptyItem.paymentMethod = nil
    mutableItems?.add(emptyItem)
    
    emptyTemplate.items = mutableItems?.copy() as? NSSet
}
