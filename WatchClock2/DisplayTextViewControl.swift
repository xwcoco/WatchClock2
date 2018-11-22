//
//  DisplayTextViewControl.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/21.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class DisplayTextViewControl: UITableViewController {

    var watch: WatchInfo?
    var watchText: WatchText?
    var editRowIndex: IndexPath?

    func setTitle(newTitle: String) -> Void {
        self.navigationItem.title = newTitle
    }

    @IBAction func FontSizeValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            watch?.beginUpdate()
            watchText?.fontSize = CGFloat(slider.value)
            watch?.endUpdate()
            self.setLabelSliderCell(name: "Font Size", value: CGFloat(slider.value), indexPath: IndexPath.init(row: 1, section: 4))
        }

    }

    private var backImageSize: CGSize = CGSize.init(width: 60, height: 60)

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if let sw = cell.contentView.subviews[1] as? UISwitch {
                sw.isOn = watchText?.enabled ?? false
            }
        }

        if (indexPath.section == 1) {
            if indexPath.row == 0 {
                self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GInfoBackgroud, index: watchText!.backImageIndex), indexPath: indexPath, size: backImageSize)
            }
            if (indexPath.row == 1) {
                self.setLabelSliderCell(name: "Dist To Center", value: watchText!.distToCenter, indexPath: indexPath)
            }
        }

        //text content section

        if (indexPath.section == 2) {
            if (indexPath.row <= WatchTextContent.WatchTextWeather.rawValue) {
                self.setCheckmarkCell(indexPath: indexPath, checkIndex: watchText!.textContentIndex.rawValue)
            }
        }

        if (indexPath.section == 3) {
            self.setColorCell(color: watchText!.textColor, indexPath: indexPath)
        }

        if (indexPath.section == 4) {
            if (indexPath.row == 0) {
                self.setFontCell(fontName: watchText!.fontName, indexPath: indexPath)
            } else {
                self.setLabelSliderCell(name: "Font Size", value: watchText!.fontSize, indexPath: indexPath)
            }
        }

        if (indexPath.section == 5) {
            if (indexPath.row == 5) {
                let sw = cell.contentView.subviews[1] as? UISwitch
                sw?.isOn = watchText!.showWeatchIcon
            } else {
                self.setCheckmarkCell(indexPath: indexPath, checkIndex: watchText!.weatherTextStyle.rawValue)
            }
        }

    }



    override func viewDidLayoutSubviews() {
        self.DisplayTextSwitch.isOn = watchText?.enabled ?? false
        self.DisplayTextSwitchValueChanged(self.DisplayTextSwitch)
    }



    @IBOutlet weak var DisplayTextSwitch: UISwitch!
    @IBAction func DisplayTextSwitchValueChanged(_ sender: Any) {
        for i in 1..<self.tableView.numberOfSections {

            let header = self.tableView.headerView(forSection: i)
            if (DisplayTextSwitch.isOn) {
                header?.alpha = 1
            } else {
                header?.alpha = 0
            }

            for j in 0..<self.tableView.numberOfRows(inSection: i) {
                let cell = self.tableView.getCell(at: IndexPath(row: j, section: i))
                if (DisplayTextSwitch.isOn) {
                    cell?.alpha = 1.0
                } else {
                    cell?.alpha = 0.0
                }
            }

        }

        if self.DisplayTextSwitch.isOn != watchText?.enabled {
            watch?.beginUpdate()
            watchText?.enabled = DisplayTextSwitch.isOn
            watch?.endUpdate()
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = self.tableView.indexPath(for: cell)
            if let nv = segue.destination as? ImageSelectViewControl {
                nv.imageList = WatchSettings.GInfoBackgroud
                nv.imageIndex = watchText!.backImageIndex
                nv.backSegueName = "unwindToTextStyle"
            }
            if let nv = segue.destination as? ColorSelectViewControl {
                nv.editIndexPath = indexPath
                nv.backSegueName = "unwindToTextStyle"
                if (indexPath?.section == 3) {
                    nv.editColor = watchText?.textColor
                }

            }
            if let nv = segue.destination as? FontSelectViewControl {
                nv.editRowIndex = indexPath
                nv.backToSegueName = "unwindToTextStyle"
                nv.selectedFontName = watchText!.fontName
            }
        }
    }

    @IBAction func unwindToTextStyle(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ImageSelectViewControl {
            watch?.beginUpdate()
            watchText?.backImageIndex = nv.imageIndex
            watch?.endUpdate()
            self.setImageCell(imageName: WatchSettings.getImageName(list: WatchSettings.GInfoBackgroud, index: watchText!.backImageIndex), indexPath: IndexPath.init(row: 0, section: 1), size: backImageSize)
        }
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            watch?.beginUpdate()
            watchText?.textColor = nv.editColor!
            watch?.endUpdate()
            self.setColorCell(color: watchText!.textColor, indexPath: IndexPath.init(row: 0, section: 3))
        }
        if let nv = unwindSegue.source as? FontSelectViewControl {
            watch?.beginUpdate()
            watchText?.fontName = nv.selectedFontName
            watch?.endUpdate()
            self.setFontCell(fontName: watchText!.fontName, indexPath: IndexPath.init(row: 0, section: 4))
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //text content section
        if (indexPath.section == 2) {
            watch?.beginUpdate()
            self.watchText?.textContentIndex = WatchTextContent(rawValue: indexPath.row)!
            watch?.endUpdate()

            self.setNewCheckmark(section: indexPath.section, cellNum: WatchTextContent.WatchTextWeather.rawValue, newIndex: indexPath.row)

        }

        if (indexPath.section == 5 && indexPath.row != 5) {
            watch?.beginUpdate()
            self.watchText?.weatherTextStyle = WeatherTextStyle(rawValue: indexPath.row)!
            watch?.endUpdate()
            self.setNewCheckmark(section: 5, cellNum: WeatherTextStyle.WeatherTextPM10.rawValue, newIndex: watchText!.weatherTextStyle.rawValue)
        }
    }


    @IBAction func showWeatcherIconSwitchValueChanged(_ sender: Any) {
        if let sw = sender as? UISwitch {
            watch?.beginUpdate()
            watchText?.showWeatchIcon = sw.isOn
            watch?.endUpdate()
        }
    }
    @IBAction func distToCenterValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            watch?.beginUpdate()
            watchText?.distToCenter = CGFloat(slider.value)
            watch?.endUpdate()
            self.setLabelSliderCell(name: "Dist To Center", value: watchText!.distToCenter, indexPath: IndexPath.init(row: 1, section: 1), setSlider: false)
        }
    }


//    override func didMove(toParent parent: UIViewController?) {
//        print("did Move ....")
//        print(parent)
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.isMovingToParent) {
            if let viewControls = self.navigationController?.viewControllers {
                for view in viewControls {
                    if let vc = view as? FaceStyleViewControl {
                        self.faceStyleViewControl = vc
                        return;
                    }
                }
            }
        }
    }

    private var faceStyleViewControl: FaceStyleViewControl?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            self.faceStyleViewControl?.updateWatchText(indexPath: self.editRowIndex!)
        }
    }


}
