//
//  ViewController.swift
//  Animation
//
//  Created by Азизбек on 08.07.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var allClouds = [UIImageView]()
    var allLabels = [UILabel]()
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let angles = [(CGFloat.pi / 3), (CGFloat.pi / 6), 0.0, (11 * CGFloat.pi / 6), (5 * CGFloat.pi / 3), (3 * CGFloat.pi / 2),
                  (4 * CGFloat.pi / 3), (7 * CGFloat.pi / 6), (CGFloat.pi), (5 * CGFloat.pi / 6), (2 * CGFloat.pi / 3)]
    let numbersOfClock = [5,4,3,2,1,12,11,10,9,8,7]

    override func viewDidLoad() {
        super.viewDidLoad()
        addImageViews()
        //серая полоса загрузки
        let circlularPath = UIBezierPath(arcCenter: view.center, radius: 150, startAngle: CGFloat.pi/3, endAngle: 2 * CGFloat.pi / 3, clockwise: false)
        shapeLayer.strokeEnd = 0
        shapeLayer.lineWidth = 11
        setUpLayer(layer: shapeLayer, color: .systemGray, path: circlularPath)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSmallLines()
    }

    private func addImageViews() {
        for _ in 0...10 {
            
        }
    }

    private func setSmallLines() {
        let path = UIBezierPath()
        let imagePoint: CGFloat = 185
        let innerRadius: CGFloat = 150
        let numberPoint: CGFloat = 120
        let outerRadius: CGFloat = 151
        for (index, item) in angles.enumerated() {
            let inner = CGPoint(x: innerRadius * cos(item) + view.center.x, y: innerRadius * sin(item) + view.center.y)
            let outer = CGPoint(x: outerRadius * cos(item) + view.center.x, y: outerRadius * sin(item)  + view.center.y)
            let numberCenter = CGPoint(x: numberPoint * cos(item) + view.center.x, y: numberPoint * sin(item)  + view.center.y)
            let imageCenter = CGPoint(x: imagePoint * cos(item) + view.center.x, y: imagePoint * sin(item)  + view.center.y)
            path.move(to: inner)
            path.addLine(to: outer)

            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            label.center = numberCenter
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 20)
            label.alpha = 0
            allLabels.append(label)
            label.text = "\(numbersOfClock[index])"
            view.addSubview(label)

            let imageView = UIImageView(image: UIImage(named: "cloud"))
            imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            imageView.center = imageCenter
            imageView.contentMode = .scaleAspectFit
            imageView.alpha = 0
            allClouds.append(imageView)
            view.addSubview(imageView)

        }
        trackLayer.strokeEnd = 0
        trackLayer.lineWidth = 10
        setUpLayer(layer: trackLayer, color: .black, path: path)
    }

    private func setUpLayer(layer: CAShapeLayer,color: UIColor, path: UIBezierPath) {
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.lineCap = .square
        layer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(layer)
    }

    @IBAction func tapMeAction(_ sender: UIButton) {
        for item in allLabels {
            item.alpha = 0
        }
        for item in allClouds {
            item.alpha = 0
        }
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 3
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "second")
        trackLayer.add(basicAnimation, forKey: "someBasicAnimation")
        let timeInterval = (3.0 / 11.0)
        var runCount = 0
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {[weak self] timer in
            UIView.animate(withDuration: 0.3) {
                self?.allLabels[runCount].alpha = 1
                self?.allClouds[runCount].alpha = 1

            }
            let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
            rotation.toValue = Double.pi * 2
            rotation.duration = 1
            rotation.isCumulative = true
            rotation.repeatCount = 1
            self?.allClouds[runCount].layer.add(rotation, forKey: "rotationAnimation")
            runCount += 1
            if runCount == 11 {
                timer.invalidate()
            }
        }
    }
}

