//
//  ViewController.swift
//  ARGame
//
//  Created by 花明 on 2017/11/18.
//  Copyright © 2017年 zju.gaps. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var depthView: UIView!
    
    var cubeNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()//SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        addGestures()
    }
    
    private func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(ViewController.handleTap(sender:)))
        view.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action:
            #selector(ViewController.handlePanGesture(sender:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        if sceneView.scene.rootNode.childNodes.count == 0 {
            return
        }
        
        let velocity = sender.velocity(in: self.view)
        let last_scale = cubeNode.scale.x
        
        if velocity.y > 0 {
            cubeNode.scale = SCNVector3(last_scale * 0.99, last_scale * 0.99, last_scale * 0.99)
        }
        
        else {
            cubeNode.scale = SCNVector3(last_scale * 1.01, last_scale * 1.01, last_scale * 1.01)
        }
    }
    
    @objc
    func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        let x = location.x / self.view.bounds.size.width
        if (x > 0.1) {
            return
        }
        
        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }
        
        
        /*
        let imagePlane = SCNPlane(width: sceneView.bounds.width / 6000,
                                  height: sceneView.bounds.height / 6000)
        let image = sceneView.snapshot()
        imagePlane.firstMaterial?.diffuse.contents = image
        imagePlane.firstMaterial?.lightingModel = .constant
        
        let planeNode = SCNNode(geometry: imagePlane)
        sceneView.scene.rootNode.addChildNode(planeNode)
        
        //planeNode.eulerAngles.z = Float.pi + Float.pi / 2
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.1
        planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        //planeNode.simdEulerAngles = float3(0, 0, Float.pi/2)
        */
        
        let cube = SCNBox(width: sceneView.bounds.height / 6000, height: sceneView.bounds.height / 6000, length: sceneView.bounds.height / 6000, chamferRadius: sceneView.bounds.height / 60000)
        cube.firstMaterial?.diffuse.contents = UIColor.init(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.5)
        cube.firstMaterial?.lightingModel = .constant
        
        cubeNode = SCNNode(geometry: cube)
        
        if sceneView.scene.rootNode.childNodes.count > 0 {
            sceneView.scene.rootNode.replaceChildNode(sceneView.scene.rootNode.childNodes[0], with: cubeNode)
        }
        else {
            sceneView.scene.rootNode.addChildNode(cubeNode)
        }
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.1
        cubeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
