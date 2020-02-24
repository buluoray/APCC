//
//  GuestViewController+Update.swift
//  APCC
/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The application's main table view controller showing a list of products.
*/
import UIKit

extension GuestViewController: UISearchResultsUpdating {

    private func findMatches(searchString: String) -> NSCompoundPredicate {
        /** Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
            Example if searchItems contains "Gladiolus 51.99 2001":
                name CONTAINS[c] "gladiolus"
                name CONTAINS[c] "gladiolus", yearIntroduced ==[c] 2001, introPrice ==[c] 51.99
                name CONTAINS[c] "ginger", yearIntroduced ==[c] 2007, introPrice ==[c] 49.98
        */
        var searchItemsPredicate = [NSPredicate]()
        
        /** Below we use NSExpression represent expressions in our predicates.
            NSPredicate is made up of smaller, atomic parts:
            two NSExpressions (a left-hand value and a right-hand value).
        */
        
        // Product title matching.
        let titleExpression = NSExpression(forKeyPath: Business.ExpressionKeys.businessName.rawValue)
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        let titleSearchComparisonPredicate =
        NSComparisonPredicate(leftExpression: titleExpression,
                              rightExpression: searchStringExpression,
                              modifier: .direct,
                              type: .contains,
                              options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(titleSearchComparisonPredicate)
        
        let countryExpression = NSExpression(forKeyPath: Business.ExpressionKeys.country.rawValue)
        let countrySearchComparisonPredicate =
        NSComparisonPredicate(leftExpression: countryExpression,
                              rightExpression: searchStringExpression,
                              modifier: .direct,
                              type: .contains,
                              options: [.caseInsensitive, .diacriticInsensitive])
        searchItemsPredicate.append(countrySearchComparisonPredicate)
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .none
//        numberFormatter.formatterBehavior = .default
//
//        // The `searchString` may fail to convert to a number.
//        if let targetNumber = numberFormatter.number(from: searchString) {
//            // Use `targetNumberExpression` in both the following predicates.
//            let targetNumberExpression = NSExpression(forConstantValue: targetNumber)
//
//            // The `yearIntroduced` field matching.
//            let yearIntroducedExpression = NSExpression(forKeyPath: Product.ExpressionKeys.yearIntroduced.rawValue)
//            let yearIntroducedPredicate =
//                NSComparisonPredicate(leftExpression: yearIntroducedExpression,
//                                      rightExpression: targetNumberExpression,
//                                      modifier: .direct,
//                                      type: .equalTo,
//                                      options: [.caseInsensitive, .diacriticInsensitive])
//
//            searchItemsPredicate.append(yearIntroducedPredicate)
//
//            // The `price` field matching.
//            let lhs = NSExpression(forKeyPath: Product.ExpressionKeys.introPrice.rawValue)
//
//            let finalPredicate =
//                NSComparisonPredicate(leftExpression: lhs,
//                                      rightExpression: targetNumberExpression,
//                                      modifier: .direct,
//                                      type: .equalTo,
//                                      options: [.caseInsensitive, .diacriticInsensitive])
//
//            searchItemsPredicate.append(finalPredicate)
//        }
                
        var finalCompoundPredicate: NSCompoundPredicate!
    
        // Handle the scoping.
        let selectedScopeButtonIndex = searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex > 0 {
            // We have a scope type to narrow our search further.
            if !searchItemsPredicate.isEmpty {
                /** We have a scope type and other fields to search on -
                    so match up the fields of the Product object AND its product type.
                */
                if selectedScopeButtonIndex == 1{
                    finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titleSearchComparisonPredicate])
                } else if selectedScopeButtonIndex == 2 {
                    finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [countrySearchComparisonPredicate])
                }
//                let compPredicate1 = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
//
//                if selectedScopeButtonIndex == 1{
//                    let compPredicate2 = NSPredicate(format: "%K like %@",)
//                    finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [compPredicate1, compPredicate2])
//                } else if selectedScopeButtonIndex == 2{
//                    let compPredicate2 = NSPredicate(format: "(SELF.country == %@)", selectedScopeButtonIndex)
//                   finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [compPredicate1, compPredicate2])
//                }
//

                
            } else {
                // Match up by product scope type only.
                //finalCompoundPredicate = NSCompoundPredicate(format: "(SELF.type == %ld)", selectedScopeButtonIndex)
            }
        } else {
            // No scope type specified, just match up the fields of the Product object
            finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        }

        //Swift.debugPrint("search predicate = \(String(describing: finalCompoundPredicate))")
        return finalCompoundPredicate
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Update the filtered array based on the search text.
        let searchResults = businesses

        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]

        // Build all the "AND" expressions for each value in searchString.
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            findMatches(searchString: searchString)
        }

        // Match up the fields of the Product object.
        let finalCompoundPredicate =
            NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)

        let filteredResults = searchResults!.joined().filter { finalCompoundPredicate.evaluate(with: $0) }

        // Apply the filtered results to the search results table.
        if let resultsController = searchController.searchResultsController as? ResultCollectionViewController {
            
            
            let result = Array(Dictionary(grouping:filteredResults){$0.businessHeader}.values)
            var appendingBusiness = [[Business]]()
            for unsorted in result{
                //sort by [Business]
                
                let sorted = unsorted.sorted(by: {$0 < $1})
                appendingBusiness.append(sorted)
            }
            //sort by [BusinessHeader]
            
            appendingBusiness.sort { ($0[0] ) < ($1[0] ) }
            resultsController.filteredBusinesses = appendingBusiness
            resultsController.collectionView.reloadData()
        }
    }
    
}
