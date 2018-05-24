import Foundation

struct NavigationManager {
    
    
    static func gotoPlayListDetail(from viewController: UIViewController, playListDetail : PlayListModel){
        
        let obj = PlayListDetailVC.instantiate(fromAppStoryboard: .Home)
        obj.playListDetail = playListDetail
        viewController.navigationController?.pushViewController(obj, animated: true)
        
//        viewController.navigationController?.isNavigationBarHidden = false
//        viewController.addChildViewController(obj)
//        viewController.view.addSubview(obj.view)
//        obj.didMove(toParentViewController: viewController)

    }
    
    static func gotoNotification(){
        
        let mainViewController = CollaboratorsVC.instantiate(fromAppStoryboard: .Home)
        sharedAppDelegate.parentNavigationController = UINavigationController(rootViewController: mainViewController)
        sharedAppDelegate.parentNavigationController.delegate = sharedAppDelegate
        sharedAppDelegate.parentNavigationController.isNavigationBarHidden = true
        sharedAppDelegate.window?.rootViewController = sharedAppDelegate.parentNavigationController
        sharedAppDelegate.window?.makeKeyAndVisible()
        
    }


    static func gotoLoginOption(){
        
        let mainViewController = LoginOptionVC.instantiate(fromAppStoryboard: .PreLogin)
        sharedAppDelegate.parentNavigationController = UINavigationController(rootViewController: mainViewController)
        sharedAppDelegate.parentNavigationController.delegate = sharedAppDelegate
        sharedAppDelegate.parentNavigationController.isNavigationBarHidden = true
        sharedAppDelegate.window?.rootViewController = sharedAppDelegate.parentNavigationController
        sharedAppDelegate.window?.makeKeyAndVisible()

    }

    static func gotoHome(){
        
        let mainViewController = TabBarVC.instantiate(fromAppStoryboard: .Home)
        sharedAppDelegate.parentNavigationController = UINavigationController(rootViewController: mainViewController)
        sharedAppDelegate.parentNavigationController.delegate = sharedAppDelegate
        sharedAppDelegate.parentNavigationController.isNavigationBarHidden = true
        sharedAppDelegate.window?.rootViewController = sharedAppDelegate.parentNavigationController
        sharedAppDelegate.window?.makeKeyAndVisible()
    }

    
    static func signupLoginOption(with signupState: SignupOptionState = .signUp) {
        let signupLoginOptionScene = SignUpOptionVC.instantiate(fromAppStoryboard: .PreLogin)
        signupLoginOptionScene.signupState = signupState
        sharedAppDelegate.parentNavigationController.pushViewController(signupLoginOptionScene, animated: true)
    }
    
    static func gotoTidalLogin(from viewController: UIViewController) {
        
        let tidalScene = TidalLoginVC.instantiate(fromAppStoryboard: .PreLogin)
        tidalScene.modalTransitionStyle = .crossDissolve
        tidalScene.modalPresentationStyle = .overCurrentContext
        tidalScene.delegate = viewController as! TidalLoginDelegate
        sharedAppDelegate.parentNavigationController.present(tidalScene, animated: true, completion: nil)
        
    }



    static func gotoTermsCondition(from viewController: UIViewController) {
        
        let login = TermsAndServicesVC.instantiate(fromAppStoryboard: .PreLogin)
        
        sharedAppDelegate.parentNavigationController.pushViewController(login, animated: true)
    }

    
    static func gotoImportPlayList(from viewController: UIViewController , with selectedDSP : SelectedDSPs = .Spotify) {
        
        let importScene = ImportPlaylistVC.instantiate(fromAppStoryboard: .Home)
        importScene.selectedDSP = selectedDSP
        sharedAppDelegate.parentNavigationController.pushViewController(importScene, animated: true)

    }

    static func moveToSingleChat(from viewController: UIViewController , senderId: String , chatMember : ChatMember) {
        
        let chatScene = ChatVC.instantiate(fromAppStoryboard: .Chat)
        chatScene.senderId = senderId
        chatScene.chatMembers = [chatMember]
        sharedAppDelegate.parentNavigationController.pushViewController(chatScene, animated: true)
        
    }

    
    static func gotoBrowse(from viewController: UIViewController , with selectedDSP : SelectedDSPs = .Spotify, deezerObject : DeezerObject? ,  spotifySongsList : [SPTPlaylistTrack] = []) {
        
        let importScene = BrowseVC.instantiate(fromAppStoryboard: .Home)
        importScene.selectedDSP = selectedDSP
        importScene.object = deezerObject
        importScene.songsList = spotifySongsList
        
        sharedAppDelegate.parentNavigationController.pushViewController(importScene, animated: true)
        
    }


    static func goToAppleMusicPlaylistVC(from viewController: UIViewController ) {
        
        let authorizationManager: AuthorizationManager = {
            return AuthorizationManager(appleMusicManager: AppleMusicManager())
        }()
        
        /// The instance of `MediaLibraryManager` which manages the `MPPMediaPlaylist` this application creates.
        
        let mediaLibraryManager: MediaLibraryManager = {
            return MediaLibraryManager(authorizationManager: authorizationManager)
        }()
        
        let appleMusicPlaylist = AppleMusicPlaylistVC.instantiate(fromAppStoryboard: .PreLogin)
        
        appleMusicPlaylist.authorizationManager = authorizationManager
        appleMusicPlaylist.mediaLibraryManager = mediaLibraryManager
        
        // importScene.selectedDSP = selectedDSP
        sharedAppDelegate.parentNavigationController.pushViewController(appleMusicPlaylist, animated: true)
        
    }

    static func showPopUP(selectedDSP: SelectedDSPs = .Spotify , title: String , message : String , goto : String = "Ok" , url : String = "") {
        
        let popup = PopUpController.instantiate(fromAppStoryboard: .PreLogin)
        popup.selectedDSP = selectedDSP
        popup.alertTitle = title
        popup.alertMessage = message
        popup.gotoText = goto
        popup.openUrl = url
        
        popup.modalPresentationStyle = .overCurrentContext
        sharedAppDelegate.parentNavigationController.present(popup, animated: true, completion: nil)

    }
}
