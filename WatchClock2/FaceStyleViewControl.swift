//
//  FaceStyleViewControl.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/20.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class FaceStyleViewControl: UITableViewController {
    var watch: WatchInfo?

    private var faceSize : CGSize = CGSize.init(width: 82, height: 100)
    
    private var hourSize : CGSize = CGSize.init(width: 30, height: 80)
    
    private var logoSize : CGSize = CGSize.init(width: 80, height: 80)

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            switch indexPath.row {
            case 1:
                self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GFaceNameList, index: watch!.faceIndex), indexPath: indexPath, size: faceSize)
                break
            case 2:
                self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GHourImageList, index: watch!.hourIndex), indexPath: indexPath, size: hourSize)
                break
            case 3:
                self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GMinuteImageList, index: watch!.minuteIndex), indexPath: indexPath, size: hourSize)
                break
            case 4:
                self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GSecondImageList, index: watch!.secondIndex), indexPath: indexPath, size: hourSize)
                break
            default:
                break
            }
        } else if (indexPath.section == 1) {
            switch indexPath.row {
            case 0:
                self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GLogoImageList, index: watch!.LogoIndex), indexPath: indexPath, size: logoSize)
                break
            case 1:
                self.setLabelSliderCell(name: "Dist To Center", value: watch!.LogoToCenter, indexPath: indexPath)
                break
            default:
                break
            }
        } else if (indexPath.section == 2) {
            switch indexPath.row {
            case 0:
                self.setImageCell(image: watch!.bottomText.toImage()!, indexPath: indexPath)
                break
            case 1:
                self.setImageCell(image: watch!.rightText.toImage()!, indexPath: indexPath)
                break
            default:
                self.setImageCell(image: watch!.leftText.toImage()!, indexPath: indexPath)
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = self.tableView.indexPath(for: cell)
            if let nv = segue.destination as? FaceCustomViewControl {
                nv.watch = self.watch
            }
            
            else if let nv = segue.destination as? ImageSelectViewControl {
                nv.backSegueName = "unwindToFaceStyle"
                nv.editIndexPath = indexPath
                if (indexPath?.section == 0) {
                    switch indexPath?.row {
                    case 1:
                        nv.imageIndex = watch!.faceIndex
                        nv.imageList = WatchSettings.GFaceNameList
                        nv.selectTitle = NSLocalizedString("Background Image", comment: "")
                        nv.itemHeight = faceSize.height
                        nv.itemWidth = faceSize.width
                        break
                    case 2:
                        nv.imageIndex = watch!.hourIndex
                        nv.imageList = WatchSettings.GHourImageList
                        nv.selectTitle = NSLocalizedString("Hour Style", comment: "")
                        nv.itemHeight = hourSize.height
                        nv.itemWidth = hourSize.width
                        break
                    case 3:
                        nv.imageIndex = watch!.minuteIndex
                        nv.imageList = WatchSettings.GMinuteImageList
                        nv.selectTitle = NSLocalizedString("Minute Style", comment: "")
                        nv.itemHeight = hourSize.height
                        nv.itemWidth = hourSize.width
                        break

                    case 4:
                        nv.imageIndex = watch!.secondIndex
                        nv.imageList = WatchSettings.GSecondImageList
                        nv.selectTitle = NSLocalizedString("Second Style", comment: "")
                        nv.itemHeight = hourSize.height
                        nv.itemWidth = hourSize.width
                        break
                    default:
                        break
                    }
                } else if (indexPath?.section == 1 && indexPath?.row == 0) {
                    nv.imageIndex = watch!.LogoIndex
                    nv.imageList = WatchSettings.GLogoImageList
                    nv.selectTitle = NSLocalizedString("Logo", comment: "")
                    nv.itemHeight = logoSize.height
                    nv.itemWidth = logoSize.width
                }
            } else if let nv = segue.destination as? DisplayTextViewControl {
                nv.watch = self.watch
                nv.editRowIndex = indexPath
                switch indexPath?.row {
                case 0:
                    nv.watchText = self.watch?.bottomText
                    break
                case 1:
                    nv.watchText = self.watch?.rightText
                    break
                default:
                    nv.watchText = self.watch?.leftText
                    break
                }
            }
        }

    }
    
    @IBAction func unwindToFaceStyle(_ unwindSegue: UIStoryboardSegue) {
        self.watch?.beginUpdate()
        if let nv = unwindSegue.source as? ImageSelectViewControl {
            
            if (nv.editIndexPath?.section == 0) {
                switch nv.editIndexPath?.row {
                case 1:
                    watch?.faceIndex = nv.imageIndex
                    self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GFaceNameList, index: watch!.faceIndex), indexPath: nv.editIndexPath!, size: faceSize)

                    break
                case 2:
                    watch?.hourIndex = nv.imageIndex
                    self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GHourImageList, index: nv.imageIndex), indexPath: nv.editIndexPath!, size: hourSize)
                    break
                case 3:
                    watch?.minuteIndex = nv.imageIndex
                    self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GMinuteImageList, index: nv.imageIndex), indexPath: nv.editIndexPath!, size: hourSize)
                    break
                case 4:
                    watch?.secondIndex = nv.imageIndex
                    self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GSecondImageList, index: nv.imageIndex), indexPath: nv.editIndexPath!, size: hourSize)
                    break
                default:
                    break
                }
            } else if (nv.editIndexPath?.section == 1) {
                watch?.LogoIndex = nv.imageIndex
                self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GLogoImageList, index: nv.imageIndex), indexPath: nv.editIndexPath!, size: logoSize)
            }
        }
        self.watch?.endUpdate()
    }
    
    @IBAction func logoDistValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            self.watch?.beginUpdate()
            watch?.LogoToCenter = CGFloat(slider.value)
            self.setLabelSliderCell(name: "Dist To Center", value: watch!.LogoToCenter, indexPath: IndexPath.init(row: 1, section: 1),setSlider: false)
            self.watch?.endUpdate()
        }
    }
    
    func updateWatchText(indexPath : IndexPath) -> Void {
        switch indexPath.row {
        case 0:
            self.setImageCell(image: watch!.bottomText.toImage()!, indexPath: indexPath)
            break
        case 1:
            self.setImageCell(image: watch!.rightText.toImage()!, indexPath: indexPath)
            break
        default:
            self.setImageCell(image: watch!.leftText.toImage()!, indexPath: indexPath)
        }

    }
    
}
