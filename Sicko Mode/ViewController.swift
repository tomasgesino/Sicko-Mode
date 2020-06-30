//
//  ViewController.swift
//  Sicko Mode
//
//  Created by Tomas Gesino on 23/03/2019.
//  Copyright © 2019 Tomas Gesino. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var ferrariNode : SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        let ferrariScene = SCNScene(named: "art.scnassets/subte.scn")
        ferrariNode = ferrariScene?.rootNode
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Changed Configuration To Track 2D Object/Image
        let configuration = ARImageTrackingConfiguration()
        
        // Referencing Image To Track
        guard let trackedImage = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main) else {
            print("No Images Available")
            return
        }
        
        // Track Referenced Image With Camara
        configuration.trackingImages = trackedImage
        
        // Setup Numebr Of Images Tracked
        configuration.maximumNumberOfTrackedImages = 1
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // Create Function That Returns a node
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // Create Node Var
        let node = SCNNode()
        
        // Add Image Tracking && Color Image
        if let imageAnchor = anchor as? ARImageAnchor {
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
        }
        
        // Add Model To Node If Available
        if let modelNode = ferrariNode {
            node.addChildNode(modelNode)
        }
        
        // Return Node Var
        return node
    }

}
