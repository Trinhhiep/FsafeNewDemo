//
//  HiTipView.swift
//  HiThemes_Example
//
//  Created by k2 tam on 02/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import HiThemes
import Combine


public enum eHiTipViewAlignment {
    case top
    case bottom
}

//MARK: - 👾 HiTipConstant
public struct HiTipConstant {
    static let HiTipPaddingToParent: CGFloat = 16
    static let HiTipSpacing: CGFloat = 8
    static let TipItemViewHeight: CGFloat = 50
}

extension View {
    public func hiTip(alignment: eHiTipViewAlignment,timeExist: Int? ,tips: [any HiTipProtocol]) -> some View{
        
        var verticalAlignment: Alignment {
            switch alignment {
            case .top:
                return .top
            case .bottom:
                return .bottom
            }
        }
        
        return ZStack(alignment: verticalAlignment) {
            self
            
            
            HiTipView(timeExist: timeExist,tips: tips)
                .padding(.top, HiTipConstant.HiTipPaddingToParent)
                .padding(.bottom, 96 + HiTipConstant.HiTipPaddingToParent)
                .padding(.horizontal, 16)
            
            
            
        }
    }
}

class HiTipVM: ObservableObject {
    @Published var tips: [any HiTipProtocol] = []
    private var recommendTipTimerSubscription = Set<AnyCancellable>()
    private var tipTimer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    
    init() {
    }
    
    ///🗑️ Dismiss 1 tip
    func dismissTipItem(_ tipToDismiss: any HiTipProtocol) {
        self.tips.removeAll { tip in
            return tip.id == tipToDismiss.id
        }
    }
    
    ///🔥 Dismiss All Tips
    func dismissAllTips() {
        self.tips.removeAll()
    }
    
    ///⏰🔥 Timer dismiss all
    func setTimerToDismissAll(timeExist: Int){
        var tempRecommendTipTimeExist = timeExist
        
        Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
            .sink { value in
                if tempRecommendTipTimeExist < 1 {
                    
                    self.dismissAllTips()
                    self.recommendTipTimerSubscription.forEach {  $0.cancel()}
                    
                    
                }else {
                    tempRecommendTipTimeExist -= 1
                    
                }
            }
            .store(in: &recommendTipTimerSubscription)
        
        
        
    }
    
    func addRecommendTipTimerSubscriber(timeExist: Int) {
        
        
        
        var tempRecommendTipTimeExist = timeExist
        
        if let recommendTipTimer = tipTimer {
            recommendTipTimer.sink { value in
                if tempRecommendTipTimeExist < 1 {
                    
                    self.dismissAllTips()
                    self.recommendTipTimerSubscription.forEach {  $0.cancel()}
                    
                    
                }else {
                    tempRecommendTipTimeExist -= 1
                    
                }
            }
            .store(in: &recommendTipTimerSubscription)
            
        }
        
    }
}

public struct HiTipView: View {
    @Backport.StateObject var vm = HiTipVM()
    
    public init(timeExist: Int? = nil, tips: [any HiTipProtocol]){
        vm.tips = tips
        
        if let timeExist {
            vm.setTimerToDismissAll(timeExist: timeExist)
        }
    }
    
    public var body: some View {
        VStack {
            ForEach(vm.tips, id: \.self.id) { tip in
                HiTipItem(tip: tip) { tipToDismiss in
                    vm.dismissTipItem(tipToDismiss)
                }
            }
        }
        
    }
    
    
    
    
}

struct HiTipView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let tips =  [
            Tip(type: .info, title: "Hi Tip 1", body: "Tips View tailored for HiFPT iOS team"),
            Tip(type: .info, title: "Hi Tip 2" ,body: "Tips View tailored for HiFPT iOS team"),
            Tip(type: .info, title: "Hi Tip 3", body: "Tips View tailored for HiFPT iOS team")
        ]
        
        HiTipView(tips: tips)
    }
}

