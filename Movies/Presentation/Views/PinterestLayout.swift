import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    /**
     Size for section header. Optional.

     @param collectionView - collectionView
     @param section - section for section header view

     Returns size for section header view.
     */
    func collectionView(collectionView: UICollectionView,
                        sizeForSectionHeaderViewForSection section: Int) -> CGSize
    /**
     Size for section footer. Optional.

     @param collectionView - collectionView
     @param section - section for section footer view

     Returns size for section footer view.
     */
    func collectionView(collectionView: UICollectionView,
                        sizeForSectionFooterViewForSection section: Int) -> CGSize
    /**
     Height for image view in cell.

     @param collectionView - collectionView
     @param indexPath - index path for cell

     Returns height of image view.
     */
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat

    /**
     Height for annotation view (label) in cell.

     @param collectionView - collectionView
     @param indexPath - index path for cell

     Returns height of annotation view.
     */
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat
}

extension PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                        sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        return .zero
    }

    func collectionView(collectionView: UICollectionView,
                        sizeForSectionFooterViewForSection section: Int) -> CGSize {
        return .zero
    }

    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return 0
    }
}

class PinterestLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate!
    var numberOfColumns = 2
    var cellPadding: CGFloat = 3
    private var cache = [PinterestLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        let size = CGSize(width: contentWidth, height: contentHeight)
        return size
    }

    override public class var layoutAttributesClass: AnyClass {
        return PinterestLayoutAttributes.self
    }

    override public var collectionView: UICollectionView {
        return super.collectionView!
    }

    private var numberOfSections: Int {
        return collectionView.numberOfSections
    }

    private func numberOfItems(inSection section: Int) -> Int {
        return collectionView.numberOfItems(inSection: section)
    }

    /**
     Invalidates layout.
     */
    override public func invalidateLayout() {
        cache.removeAll()
        contentHeight = 0

        super.invalidateLayout()
    }

    var cellWidth: CGFloat = 0
    override func prepare() {
        if cache.isEmpty {
            let collumnWidth = contentWidth / CGFloat(numberOfColumns)
            let cellWidth = collumnWidth - (cellPadding * 2)
            self.cellWidth = cellWidth
            var xOffsets = [CGFloat]()

            for collumn in 0..<numberOfColumns {
                xOffsets.append(CGFloat(collumn) * collumnWidth)
            }

            for section in 0..<numberOfSections {
                let numberOfItems = self.numberOfItems(inSection: section)

                if let headerSize = delegate?.collectionView(collectionView: collectionView, sizeForSectionHeaderViewForSection: section ), headerSize != .zero {
                    let headerX = (contentWidth - headerSize.width) / 2
                    let headerFrame = CGRect(origin: CGPoint(x: headerX, y: contentHeight), size: headerSize)
                    let headerAttributes = PinterestLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                    headerAttributes.frame = headerFrame
                    cache.append(headerAttributes)
                    contentHeight = headerFrame.maxY
                }

                var yOffsets = [CGFloat](
                    repeating: contentHeight,
                    count: numberOfColumns
                )

                for item in 0..<numberOfItems {
                    let indexPath = IndexPath(item: item, section: section)
                    let column = yOffsets.firstIndex(of: yOffsets.min() ?? 0) ?? 0
                    let imageHeight = delegate.collectionView(collectionView: collectionView,
                                                              heightForImageAtIndexPath: indexPath,
                                                              withWidth: cellWidth)
                    let annotationHeight = delegate.collectionView(collectionView: collectionView,
                                                                   heightForAnnotationAtIndexPath: indexPath,
                                                                   withWidth: cellWidth)
                    let cellHeight = cellPadding + imageHeight + annotationHeight + cellPadding

                    let frame = CGRect(
                        x: xOffsets[column],
                        y: yOffsets[column],
                        width: collumnWidth,
                        height: cellHeight
                    )

                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    let attributes = PinterestLayoutAttributes(
                        forCellWith: indexPath
                    )
                    attributes.frame = insetFrame
                    attributes.imageHeight = imageHeight
                    cache.append(attributes)

                    contentHeight = max(contentHeight, frame.maxY)
                    yOffsets[column] = yOffsets[column] + cellHeight
                }

                if let footerSize = delegate?.collectionView(collectionView: collectionView, sizeForSectionFooterViewForSection: section), footerSize != .zero {
                    let footerX = (contentWidth - footerSize.width) / 2
                    let footerFrame = CGRect(origin: CGPoint(x: footerX, y: contentHeight), size: footerSize)
                    let footerAttributes = PinterestLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
                    footerAttributes.frame = footerFrame
                    cache.append(footerAttributes)
                    contentHeight = footerFrame.maxY
                }
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

public class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    /**
     Image height to be set to contstraint in collection view cell.
     */
    public var imageHeight: CGFloat = 0

    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.imageHeight = imageHeight
        return copy
    }

    override public func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if attributes.imageHeight == imageHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}
