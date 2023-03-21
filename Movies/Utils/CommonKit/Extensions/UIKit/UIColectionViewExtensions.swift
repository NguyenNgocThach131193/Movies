import Foundation
import UIKit

extension UICollectionView {
    public enum SectionType {
        case header
        case footer
        var kind: String {
            switch self {
            case .header: return UICollectionView.elementKindSectionHeader
            case .footer: return UICollectionView.elementKindSectionFooter
            }
        }
    }

    public func registerClass<T: UICollectionViewCell>(aClass: T.Type) {
        let name = aClass.className
        register(aClass, forCellWithReuseIdentifier: name)
    }

    public func dequeue<T: UICollectionViewCell>(aClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: aClass), for: indexPath) as! T
    }

    public func dequeue<T: UICollectionReusableView>(aClass: T.Type, type: SectionType, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: type.kind, withReuseIdentifier: String(describing: aClass), for: indexPath) as! T
    }

    /// SwifterSwift: Index path of last item in collectionView.
    public var indexPathForLastItem: IndexPath? {
        let lastSection = numberOfSections - 1
        guard lastSection >= 0, numberOfItems(inSection: lastSection) > 0 else { return nil }
        return IndexPath(item: numberOfItems(inSection: lastSection) - 1, section: lastSection)
    }

    /// SwifterSwift: Index of last section in collectionView.
    public var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }

    /// SwifterSwift: Number of all items in all sections of collectionView.
    public var numberOfItems: Int {
        var section = 0
        var itemsCount = 0
        while section < self.numberOfSections {
            itemsCount += numberOfItems(inSection: section)
            section += 1
        }
        return itemsCount
    }
}

// MARK: - Methods
public extension UICollectionView {

    /// SwifterSwift: IndexPath for last item in section.
    ///
    /// - Parameter section: section to get last item in.
    /// - Returns: optional last indexPath for last item in section (if applicable).
    func indexPathForLastItem(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard section < numberOfSections else {
            return nil
        }
        guard numberOfItems(inSection: section) > 0 else {
            return IndexPath(item: 0, section: section)
        }
        return IndexPath(item: numberOfItems(inSection: section) - 1, section: section)
    }

    /// SwifterSwift: Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    /// SwifterSwift: Register UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    /// SwifterSwift: Register UICollectionViewCell using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the collectionView cell.
    ///   - name: UICollectionViewCell type.
    func register<T: UICollectionViewCell>(nib: UINib?, forCellWithClass name: T.Type) {
        register(nib, forCellWithReuseIdentifier: String(describing: name))
    }

    /// SwifterSwift: Register UICollectionViewCell using class name.
    ///
    /// - Parameter name: UICollectionViewCell type.
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    /// SwifterSwift: Register UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the reusable view.
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    func register<T: UICollectionReusableView>(nib: UINib?, forSupplementaryViewOfKind kind: String, withClass name: T.Type) {
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    func registerNib<T: UICollectionViewCell>(_: T.Type) {
        let Nib = UINib(nibName: T.className, bundle: nil)
        register(Nib, forCellWithReuseIdentifier: T.className)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.className)")
        }
        return cell
    }

}

extension UICollectionView {
    public var visibleIndexPath: IndexPath? {
        let visibleRect = CGRect(origin: self.contentOffset,
                                 size: self.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX,
                                   y: visibleRect.midY)
        let visibleIndexPath = self.indexPathForItem(at: visiblePoint)
        return visibleIndexPath
    }

    public func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    public func restore() {
        self.backgroundView = nil
    }
}

extension UICollectionView {
    public func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.y + self.bounds.size.height))
        self.moveToFrame(contentOffset: contentOffset)
    }

    public func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.y - self.bounds.size.height))
        self.moveToFrame(contentOffset: contentOffset)
    }

    public func moveToFrame(contentOffset: CGFloat) {
        self.setContentOffset(CGPoint(x: self.contentOffset.x, y: contentOffset), animated: true)
    }
}
