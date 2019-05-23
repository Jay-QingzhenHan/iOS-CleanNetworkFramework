//
//  GuestViewCellViewController.swift
//  CleanNetworkFramework
//
//  Created by Qingzhen Han on 2019-05-22.
//  Copyright © 2019 Qingzhen Han. All rights reserved.
//

import UIKit

class GuestViewController: UIViewController{
    
    //collection view layout
    private weak var collectionView: UICollectionView!
    private let cvMarginLeft:CGFloat = 10
    private let cvMarginTop:CGFloat = 10
    private let cvMarginRight:CGFloat = 10
    private let cvMarginBottom:CGFloat = 10
    private let cvItemHight:CGFloat = 120
    private let cvColumn:CGFloat = 1
    private let cvInteritemSpacing:CGFloat = 0
    private let cvLineSpacing:CGFloat  = 10
    
    //refresh & load more
    private let loadMoreIndicatorHeight:CGFloat = 30
    private let loadMoreIndicatorIdentifier = "loadMoreView"
    private var hasMore = true
    private var isFetching  = false
    
    //page setting
    private var currentPage  = 0
    private let itemPerPage  = 10
    private let sizePerpage  = 10
    
    //data
    var data: [Int] = Array(0..<10)
    
    override func loadView() {
        super.loadView()
        setupCollectionView()
    }
    
    private func setupCollectionView(){
    
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Guest"
        // Do any additional setup after loading the view.
        configCollectionView()
        
    }
    
    private func configCollectionView(){
        self.collectionView.backgroundColor = .white
        self.collectionView.alwaysBounceVertical = true

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.identifier)
        //refresh
        self.collectionView.refreshControl = refreshControl
        self.collectionView.contentInset.bottom = loadMoreIndicatorHeight
        
        //load more
        self.collectionView.register(LoadMoreIndicator.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: loadMoreIndicatorIdentifier)
        
    }
    
    //refresh control
    lazy var refreshControl : UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.layer.zPosition = -1
        return refresh
    }()

    //load more indicator
    lazy var loadingIndicator : UIActivityIndicatorView = {
        let s = UIActivityIndicatorView()
        s.style = UIActivityIndicatorView.Style.gray
        s.hidesWhenStopped = true
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    lazy var cvLoadMoreFooter : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        return view
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GuestViewController: UICollectionViewDataSource {
    //cell group count
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //cell count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.identifier, for: indexPath) as! PostCell
        
        cell.textLabel.text = String(indexPath.row+1)
        
        return cell
    }
    
    //header or footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: loadMoreIndicatorIdentifier, for: indexPath)
            footerView.backgroundColor = UIColor.clear
            footerView.addSubview(self.loadingIndicator)
            self.loadingIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            self.loadingIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
            self.loadingIndicator.startAnimating()
            return footerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
}

extension GuestViewController: UICollectionViewDelegate {
    
    //click lisenter
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item+1)
    }
    //refresh & load more
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(self.refreshControl.isRefreshing){
            //do some refresh action here
            //self.refreshControl.endRefreshing()
        }else {
            let scrollViewHeight = scrollView.frame.size.height
            let scrollViewContentHeight = scrollView.contentSize.height
            let scrollViewOffset = scrollView.contentOffset.y
            
            if (scrollViewHeight + scrollViewOffset >= scrollViewContentHeight - loadMoreIndicatorHeight) && hasMore && !isFetching {
                
                //do load more action here
            }
        }
    }
}

extension GuestViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width - cvMarginLeft - cvMarginRight - cvInteritemSpacing*(cvColumn - 1))/cvColumn, height: cvItemHight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cvLineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: cvMarginTop, left: cvMarginLeft, bottom: cvMarginBottom, right: cvMarginRight)
    }
    
    // footer height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if hasMore {
            return CGSize(width: collectionView.frame.width, height: self.loadMoreIndicatorHeight)
        }
        return CGSize(width: 0, height: 0)
    }
}
