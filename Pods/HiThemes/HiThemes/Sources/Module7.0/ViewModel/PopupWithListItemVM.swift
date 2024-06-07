//
//  PopupWithListItemVM.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 17/11/2022.
//


class PopupWithListItemVM:BaseViewModel<HiThemesImageTitleIconProtocol>{
    var cacheData : [HiThemesImageTitleIconProtocol] = []
    func fetchData(data : [HiThemesImageTitleIconProtocol]){
        self.setDataItems(data: data)
        cacheData = data
    }
    func didSelectItemAt(id : String){
        for (ind,item) in self.items.enumerated(){
            if id == item.cellId{
                self.items[ind].isSelected = true
            }else{
                self.items[ind].isSelected = false
            }
        }
        for (ind,item) in self.cacheData.enumerated(){
            if id == item.cellId{
                self.cacheData[ind].isSelected = true
            }else{
                self.cacheData[ind].isSelected = false
            }
        }
        self.baseCallbackReloadData?()
    }
    func didSelectMultipleItemAt(id : String){
        for (ind,item) in self.items.enumerated(){
            if id == item.cellId{
                self.items[ind].isSelected.toggle()
            }
        }
        for (ind,item) in self.cacheData.enumerated(){
            if id == item.cellId{
                self.cacheData[ind].isSelected.toggle()
            }
        }
        self.baseCallbackReloadData?()
    }
    func getListIndexItemSelected()->[Int]{
        var tempArr : [Int] = []
        for (ind,item) in self.cacheData.enumerated(){
            if item.isSelected == true{
                tempArr.append(ind)
            }
        }
        return tempArr
    }
    func getIndexItemSelected()->Int?{
        return self.cacheData.firstIndex { item in
            item.isSelected == true
        }
    }
    func search(key: String){
        if key == ""{
            self.setDataItems(data: cacheData)
        }else{
            let filterData = self.cacheData.filter { item in
                item.cellType.getTitle().lowercased().folded.contains(key.lowercased().folded)
            }
            self.setDataItems(data: filterData)
        }
        
        
    }
}

