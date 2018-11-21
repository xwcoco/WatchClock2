//
//  FaceCustomViewControl.swift
//  WatchClock2
//
//  Created by 徐卫 on 2018/11/21.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class FaceCustomViewControl: UITableViewController {
    var watch: WatchInfo?


    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            self.setColorCell(color: watch!.customFace_back_color, indexPath: IndexPath.init(row: 0, section: 0))
        }
        if (indexPath.section == 1) {
            cell.accessoryType = .none
            if (indexPath.row == watch!.faceStyle.rawValue) {
                cell.accessoryType = .checkmark
            }
        }
        
        
        if (indexPath.section == 2) {
            if (indexPath.row <= NumeralStyle.NumeralStyleNone.rawValue) {
                cell.accessoryType = .none
                if (indexPath.row == watch!.numeralStyle.rawValue) {
                    cell.accessoryType = .checkmark
                }
            }

            if (indexPath.row == 3) {
                self.setColorCell(color: watch!.numbers_color, indexPath: indexPath)
            }
            
            if (indexPath.row == 4) {
                self.setFontCell(fontName: watch!.numbers_fontName, indexPath: indexPath)
            }
            
            if (indexPath.row == 5) {
                self.setLabelSliderCell(name: "Font Size", value: watch!.numbers_fontSize, indexPath: indexPath)
            }
            
        }

        if (indexPath.section == 3) {
            if (indexPath.row <= TickmarkStyle.TickmarkStyleNone.rawValue) {
                cell.accessoryType = .none
                if (indexPath.row == watch!.tickmarkStyle.rawValue) {
                    cell.accessoryType = .checkmark
                }
            }
            if (indexPath.row == 4) {
                self.setColorCell(color: watch!.tick_majorColor, indexPath: indexPath)
            }
            if (indexPath.row == 5) {
                self.setColorCell(color: watch!.tick_minorColor, indexPath: indexPath)
            }
        }

        if (indexPath.section == 4) {
            if (indexPath.row == 0) {
                let sw = cell.contentView.subviews[1] as? UISwitch
                sw?.isOn = watch!.customFace_showColorRegion
            }
            if (indexPath.row == 1) {
                self.setColorCell(color: watch!.customFace_ColorRegion_Color1, indexPath: indexPath)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = self.tableView.indexPath(for: cell)
            if let nv = segue.destination as? ColorSelectViewControl {
                nv.editIndexPath = indexPath
                if (indexPath?.section == 0) {
                    nv.editColor = watch!.customFace_back_color
                }
                if (indexPath?.section == 2) {
                    nv.editColor = watch?.numbers_color
                }
                if (indexPath?.section == 3) {
                    if (indexPath?.row == 4) {
                        nv.editColor = watch?.tick_majorColor
                    } else if (indexPath?.row == 5) {
                        nv.editColor = watch?.tick_minorColor
                    }
                }
                if (indexPath?.section == 4) {
                    nv.editColor = watch?.customFace_ColorRegion_Color1
                }

                nv.backSegueName = "unwindToFaceCustom"
            }
            
            if let nv = segue.destination as? FontSelectViewControl {
                nv.editRowIndex = indexPath
                nv.selectedFontName = watch!.numbers_fontName
                nv.backToSegueName = "unwindToFaceCustom"
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            watch?.beginUpdate()
            watch?.faceStyle = WatchFaceStyle(rawValue: indexPath.row)!
            self.setNewCheckmark(section: indexPath.section, cellNum: 2, newIndex: watch!.faceStyle.rawValue)
            watch?.endUpdate()

        }
        if (indexPath.section == 2 && indexPath.row <= NumeralStyle.NumeralStyleNone.rawValue) {

            watch?.beginUpdate()
            watch?.numeralStyle = NumeralStyle(rawValue: indexPath.row)!

            self.setNewCheckmark(section: indexPath.section, cellNum: NumeralStyle.NumeralStyleNone.rawValue, newIndex: (watch?.numeralStyle.rawValue)!)

            watch?.endUpdate()
        }

        if (indexPath.section == 3 && indexPath.row <= TickmarkStyle.TickmarkStyleNone.rawValue) {
            watch?.beginUpdate()
            watch?.tickmarkStyle = TickmarkStyle(rawValue: indexPath.row)!
            self.setNewCheckmark(section: indexPath.section, cellNum: TickmarkStyle.TickmarkStyleNone.rawValue, newIndex: (watch?.tickmarkStyle.rawValue)!)
            watch?.endUpdate()
        }
    }

    @IBAction func unwindToFaceCustom(_ unwindSegue: UIStoryboardSegue) {
        self.watch?.beginUpdate()
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            setColorCell(color: nv.editColor!, indexPath: nv.editIndexPath!)

            if (nv.editIndexPath?.section == 0 && nv.editIndexPath?.row == 0) {
                self.watch?.customFace_back_color = nv.editColor!
            }


            if (nv.editIndexPath?.section == 2) {
                watch?.numbers_color = nv.editColor!
            }
            if (nv.editIndexPath?.section == 3) {
                if (nv.editIndexPath?.row == 4) {
                    watch?.tick_majorColor = nv.editColor!
                }
                if (nv.editIndexPath?.row == 5) {
                    watch?.tick_minorColor = nv.editColor!
                }
            }
            if (nv.editIndexPath?.section == 4) {
                watch?.customFace_ColorRegion_Color1 = nv.editColor!
            }
        }
        
        if let nv = unwindSegue.source as? FontSelectViewControl {
            self.setFontCell(fontName: nv.selectedFontName, indexPath: nv.editRowIndex!)
            self.watch?.numbers_fontName = nv.selectedFontName
        }
        self.watch?.endUpdate()
    }
    
    @IBAction func showColorRegionSwitchValueChanged(_ sender: Any) {
        if let sw = sender as? UISwitch {
            watch?.beginUpdate()
            watch?.customFace_showColorRegion = sw.isOn
            watch?.endUpdate()
        }
    }
    @IBAction func fontValueChange(_ sender: Any) {
        if let slider = sender as? UISlider {
            self.watch?.beginUpdate()
            self.watch?.numbers_fontSize = CGFloat(slider.value)
            self.setLabelSliderCell(name: "Font Size", value: CGFloat(slider.value), indexPath: IndexPath.init(row: 5, section: 2),setSlider: false)
            self.watch?.endUpdate()
        }
        
    }
    
    
}
