import UIKit
//swiftlint:disable all
extension UIAlertController {

    /// Add a picker view
    ///
    /// - Parameters:
    ///   - values: values for picker view
    ///   - initialSelection: initial selection of picker view
    ///   - action: action for selected value of picker view
    public func addPickerView(values: PickerViewViewController.Values, initialSelection: [PickerViewViewController.Index]? = nil, withSerchBar: Bool = false, action: PickerViewViewController.Action?) {
        let pickerView = PickerViewViewController(values: values, initialSelection: initialSelection, action: action, withSerchBar: withSerchBar)
        set(vc: pickerView, height: 216)
    }
}

final public class PickerViewViewController: UIViewController {

    public typealias Values = [[String]]
    public typealias Index = (column: Int, row: Int)
    public typealias Action = (_ vc: UIViewController, _ picker: UIPickerView, _ index: Index, _ values: Values) -> Void

    fileprivate var action: Action?
    fileprivate var values: Values = [[]]
    fileprivate var valuesBySearch: Values = [[]]
    fileprivate var initialSelections: [Index]?
    fileprivate var withSerchBar: Bool?

    fileprivate var isFromSearchArray: Bool?

    fileprivate lazy var pickerView: UIPickerView = {
        return $0
    }(UIPickerView())

    init(values: Values, initialSelection: [Index]? = nil, action: Action?, withSerchBar: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.values = values
        self.initialSelections = initialSelection
        self.action = action
        self.withSerchBar = withSerchBar
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
    }

    override public func loadView() {
        if self.withSerchBar == true {
        } else {
            view = pickerView
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let initialSelections = initialSelections {
            if initialSelections.count > values.count {
                return
            }
            for i in 0..<initialSelections.count {
                if initialSelections[i].column > values.count {
                    return
                }
                pickerView.selectRow(initialSelections[i].row, inComponent: initialSelections[i].column, animated: true)
            }
        }
    }
}
extension PickerViewViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isFromSearchArray = searchText.count > 0
        valuesBySearch.removeAll()
        for objects in values {
            var temp = [String]()
            for obj in objects {
                if obj.contains(searchText) {
                    temp.append(obj)
                }
            }
            valuesBySearch.append(temp)
        }
        self.pickerView.reloadAllComponents()
        self.pickerView.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(self.pickerView, didSelectRow: 0, inComponent: 0)
    }
}
extension PickerViewViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.isFromSearchArray == true ? valuesBySearch.count : values.count
    }

    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.isFromSearchArray == true ? valuesBySearch[component].count : values[component].count
    }
    /*
     // returns width of column and height of row for each component.
     public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
     
     }
     
     public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
     
     }
     */

    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.isFromSearchArray == true ? valuesBySearch[component][row] : values[component][row]
    }
    /*
     public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
     // attributed title is favored if both methods are implemented
     }
     
     
     public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
     
     }
     */
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.isFromSearchArray == true {
            for value in values {
                for valueObj in value {
                    if valuesBySearch.count > 0 && valuesBySearch[component].count > 0 {
                        if valuesBySearch[component][row] == valueObj {
                            action?(self, pickerView, Index(column: values.indexes(of: value).first ?? 0, row: value.indexes(of: valueObj).first ?? 0), values)
                        }
                    }
                }
            }
        } else {
            action?(self, pickerView, Index(column: component, row: row), values)
        }
    }
}

import Foundation

internal extension Array {

    @discardableResult
    mutating func append(_ newArray: Array) -> CountableRange<Int> {
        let range = count..<(count + newArray.count)
        self += newArray
        return range
    }

    @discardableResult
    mutating func insert(_ newArray: Array, at index: Int) -> CountableRange<Int> {
        let mIndex = Swift.max(0, index)
        let start = Swift.min(count, mIndex)
        let end = start + newArray.count

        let left = self[0..<start]
        let right = self[start..<count]
        self = left + newArray + right
        return start..<end
    }

    mutating func remove<T: AnyObject> (_ element: T) {
        let anotherSelf = self

        removeAll(keepingCapacity: true)

        anotherSelf.each { (_: Int, current: Element) in
            if (current as! T) !== element {
                self.append(current)
            }
        }
    }

    func each(_ exe: (Int, Element) -> Void) {
        for (index, item) in enumerated() {
            exe(index, item)
        }
    }
}

extension Array where Element: Equatable {

    /// Remove Dublicates
    var unique: [Element] {
        // Thanks to https://github.com/sairamkotha for improving the method
        return self.reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }

    /// Check if array contains an array of elements.
    ///
    /// - Parameter elements: array of elements to check.
    /// - Returns: true if array contains all given items.
    public func contains(_ elements: [Element]) -> Bool {
        guard !elements.isEmpty else { // elements array is empty
            return false
        }
        var found = true
        for element in elements {
            if !contains(element) {
                found = false
            }
        }
        return found
    }

    /// All indexes of specified item.
    ///
    /// - Parameter item: item to check.
    /// - Returns: an array with all indexes of the given item.
    public func indexes(of item: Element) -> [Int] {
        var indexes: [Int] = []
        for index in 0..<self.count {
            if self[index] == item {
                indexes.append(index)
            }
        }
        return indexes
    }

    /// Remove all instances of an item from array.
    ///
    /// - Parameter item: item to remove.
    public mutating func removeAll(_ item: Element) {
        self = self.filter { $0 != item }
    }

    /// Creates an array of elements split into groups the length of size.
    /// If array can’t be split evenly, the final chunk will be the remaining elements.
    ///
    /// - parameter array: to chunk
    /// - parameter size: size of each chunk
    /// - returns: array elements chunked
    public func chunk(size: Int = 1) -> [[Element]] {
        var result = [[Element]]()
        var chunk = -1
        for (index, elem) in self.enumerated() {
            if index % size == 0 {
                result.append([Element]())
                chunk += 1
            }
            result[chunk].append(elem)
        }
        return result
    }
}
