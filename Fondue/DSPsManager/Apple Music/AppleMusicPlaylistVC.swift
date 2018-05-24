/*
See LICENSE folder for this sample’s licensing information.

Abstract:
`PlaylistTableViewController` is a `UITableViewController` subclass that list all the items in the playlist that was created by the app.
*/

import UIKit
import StoreKit
import MediaPlayer

@objcMembers
class AppleMusicPlaylistVC: UIViewController {
    
    // MARK: IB Outlets
    //==================
    @IBOutlet weak var appleMusicPlaylistTableView: UITableView!
        
    // MARK: Properties
    //===================
    /// The instance of `AuthorizationManager` used for querying and requesting authorization status.
    var authorizationManager: AuthorizationManager!
    
    /// The instance of `MediaLibraryManager` that is used as a data source to display the contents of the application's playlist.
    var mediaLibraryManager: MediaLibraryManager!
    
    /// The instance of `MusicPlayerManager` that is used to trigger the playback of the application's playlist.
    
    var musicPlayerManager: MusicPlayerManager!
    var timer:Timer?
    var array = [MPMediaItem]()
    var filteredArray = [MPMediaItem]()
    var selectedMediaItem:MPMediaItem?

    
    // MARK: View Life-cycle Methods
    //==============================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appleMusicPlaylistTableView.delegate = self
        self.appleMusicPlaylistTableView.dataSource = self
        
        // Configure self sizing cells.
        appleMusicPlaylistTableView.rowHeight = UITableViewAutomaticDimension
        appleMusicPlaylistTableView.estimatedRowHeight = 140
        
        // Add the notification observer needed to respond to events from the `MediaLibraryManager`.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMediaLibraryManagerLibraryDidUpdate),
                                               name: MediaLibraryManager.libraryDidUpdate, object: nil)
    }
    
    deinit {
        // Remove all notification observers.
        NotificationCenter.default.removeObserver(self, name: MediaLibraryManager.libraryDidUpdate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getMediaLibraryData(_:)), userInfo: nil, repeats: true)

        DispatchQueue.main.async {
            self.appleMusicPlaylistTableView.reloadData()
        }
        
        /*
         It is important to actually check if your application has the appropriate `SKCloudServiceCapability` options before enabling functionality
         related to playing back content from the Apple Music Catalog or adding items to the user's Cloud Music Library.
         */
        
//        let cloudServiceCapabilities = authorizationManager.cloudServiceCapabilities
//
//        if cloudServiceCapabilities.contains(.musicCatalogPlayback) {
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//        } else {
//            self.navigationItem.rightBarButtonItem?.isEnabled = false
//        }
    }

    // MARK: Notification Observer Callback Methods
    //==============================================
    func handleMediaLibraryManagerLibraryDidUpdate() {
        DispatchQueue.main.async {
            self.appleMusicPlaylistTableView.reloadData()
        }
    }
    
    //MARK:- Private Methods
    //MARK:-
    @objc private func getMediaLibraryData(_ timer:Timer){
        
        //get songs from media library
        let query = MPMediaQuery.playlists()
        let playlist = query.collections
        
        print_debug(playlist?.first?.value(forProperty: MPMediaPlaylistPropertyName))
        query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
        
        if let items = query.items, self.array.count !=  items.count{
            
//            print_debug(items.val)
            self.array = items
        
            //self.filterSongsArray("")
        }
    }
}

// MARK: Target-Action Methods
//=============================
extension AppleMusicPlaylistVC {
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Table view DataSource and Delegate
//============================================
extension AppleMusicPlaylistVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mediaLibraryManager.mediaPlaylist != nil {
            return mediaLibraryManager.mediaPlaylist.items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppleMusicPlaylistCell",
                                                       for: indexPath) as? AppleMusicPlaylistCell else {                                                        return UITableViewCell()
        }
        let mediaItem = mediaLibraryManager.mediaPlaylist.items[indexPath.row]
        cell.mediaItemTitleLabel.text = mediaItem.title
        cell.mediaItemAlbumLabel.text = mediaItem.albumTitle
        cell.mediaItemArtistLabel.text = mediaItem.artist
        cell.assetCoverArtImageView.image = mediaItem.artwork?.image(at: CGSize(width: 80, height: 80))
        return cell
    }
}

// MARK: - Prototype Cell
//======================
class AppleMusicPlaylistCell: UITableViewCell {
        
    // MARK: Properties
    //===================
    
    /// The `UIImageView` for displaying the artwork of the currently playing `MPMediaItem`.
    @IBOutlet weak var assetCoverArtImageView: UIImageView!
    
    /// The 'UILabel` for displaying the title of `MPMediaItem`.
    @IBOutlet weak var mediaItemTitleLabel: UILabel!
    
    /// The 'UILabel` for displaying the album of `MPMediaItem`.
    @IBOutlet weak var mediaItemAlbumLabel: UILabel!
    
    /// The 'UILabel` for displaying the artist of `MPMediaItem`.
    @IBOutlet weak var mediaItemArtistLabel: UILabel!
}
