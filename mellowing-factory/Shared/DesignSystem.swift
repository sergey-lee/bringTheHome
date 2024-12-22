//
//  DesignSystem.swift
//  mellowing-factory
//
//  Created by Florian Topf on 12.09.21.
//

import SwiftUI

let gradientBackground = LinearGradient(colors: [Color(red: 245 / 255, green: 245 / 255, blue: 246 / 255),
                                                 Color(red: 236 / 255, green: 246 / 255, blue: 255 / 255)],
                                        startPoint: .top, endPoint: .bottom)

let gradientPrimaryButton = LinearGradient(colors: [Color.green200, Color.green300, Color.blue300,
                                                    Color.blue400, Color.blue500, Color.blue500, Color.blue500, Color.blue400, Color.blue300, Color.blue200],
                                        startPoint: .topLeading, endPoint: .bottomTrailing)

let topGradientColor = LinearGradient(colors: [
    Color(red: 245 / 255, green: 245 / 255, blue: 246 / 255),
    Color(red: 243 / 255, green: 246 / 255, blue: 248 / 255)
],
                                      startPoint: .top, endPoint: .bottom)

let pretendardBlack = "Pretendard-Black"
let pretendardBold = "Pretendard-Bold"
let pretendardExtraBold = "Pretendard-ExtraBold"
let pretendardExtraLight = "Pretendard-ExtraLight"
let pretendardLight = "Pretendard-Light"
let pretendardMedium = "Pretendard-Medium"
let pretendardRegular = "Pretendard-Regular"
let pretendardSemiBold = "Pretendard-SemiBold"
let pretendardThin = "Pretendard-Thin"

let extraBold46Font: Font = Font.custom(pretendardExtraBold, size: Size.w(46))
let extraBold40Font: Font = Font.custom(pretendardExtraBold, size: Size.w(40))
let extraBold32Font: Font = Font.custom(pretendardExtraBold, size: Size.w(32))

let bold52Font: Font = Font.custom(pretendardBold, size: Size.w(52))
let bold50Font: Font = Font.custom(pretendardBold, size: Size.w(50))
let bold46Font: Font = Font.custom(pretendardBold, size: Size.w(46))
let bold38Font: Font = Font.custom(pretendardBold, size: Size.w(38))
let bold32Font: Font = Font.custom(pretendardBold, size: Size.w(32))
let bold30Font: Font = Font.custom(pretendardBold, size: Size.w(30))
let bold26Font: Font = Font.custom(pretendardBold, size: Size.w(26))
let bold24Font: Font = Font.custom(pretendardBold, size: Size.w(24))
let bold22Font: Font = Font.custom(pretendardBold, size: Size.w(22))
let bold20Font: Font = Font.custom(pretendardBold, size: Size.w(20))
let bold18Font: Font = Font.custom(pretendardBold, size: Size.w(18))
let bold16Font: Font = Font.custom(pretendardBold, size: Size.w(16))
let bold14Font: Font = Font.custom(pretendardBold, size: Size.w(14))
let bold13Font: Font = Font.custom(pretendardBold, size: Size.w(13))
let bold12Font: Font = Font.custom(pretendardBold, size: Size.w(12))

let semiBold58Font: Font = Font.custom(pretendardSemiBold, size: Size.w(58))
let semiBold36Font: Font = Font.custom(pretendardSemiBold, size: Size.w(36))
let semiBold34Font: Font = Font.custom(pretendardSemiBold, size: Size.w(34))
let semiBold32Font: Font = Font.custom(pretendardSemiBold, size: Size.w(32))
let semiBold30Font: Font = Font.custom(pretendardSemiBold, size: Size.w(30))
let semiBold26Font: Font = Font.custom(pretendardSemiBold, size: Size.w(26))
let semiBold24Font: Font = Font.custom(pretendardSemiBold, size: Size.w(24))
let semiBold22Font: Font = Font.custom(pretendardSemiBold, size: Size.w(22))
let semiBold20Font: Font = Font.custom(pretendardSemiBold, size: Size.w(20))
let semiBold18Font: Font = Font.custom(pretendardSemiBold, size: Size.w(18))
let semiBold17Font: Font = Font.custom(pretendardSemiBold, size: Size.w(17))
let semiBold16Font: Font = Font.custom(pretendardSemiBold, size: Size.w(16))
let semiBold14Font: Font = Font.custom(pretendardSemiBold, size: Size.w(14))
let semiBold13Font: Font = Font.custom(pretendardSemiBold, size: Size.w(13))
let semiBold12Font: Font = Font.custom(pretendardSemiBold, size: Size.w(12))

let regular60Font: Font = Font.custom(pretendardRegular, size: Size.w(60))
let regular22Font: Font = Font.custom(pretendardRegular, size: Size.w(22))
let regular20Font: Font = Font.custom(pretendardRegular, size: Size.w(20))
let regular18Font: Font = Font.custom(pretendardRegular, size: Size.w(18))
let regular17Font: Font = Font.custom(pretendardRegular, size: Size.w(17))
let regular16Font: Font = Font.custom(pretendardRegular, size: Size.w(16))
let regular15Font: Font = Font.custom(pretendardRegular, size: Size.w(15))
let regular14Font: Font = Font.custom(pretendardRegular, size: Size.w(14))
let regular12Font: Font = Font.custom(pretendardRegular, size: Size.w(12))

let medium30Font: Font = Font.custom(pretendardMedium, size: Size.w(30))
let medium20Font: Font = Font.custom(pretendardMedium, size: Size.w(20))
let medium18Font: Font = Font.custom(pretendardMedium, size: Size.w(18))
let medium16Font: Font = Font.custom(pretendardMedium, size: Size.w(16))
let medium15Font: Font = Font.custom(pretendardMedium, size: Size.w(15))
let medium14Font: Font = Font.custom(pretendardMedium, size: Size.w(14))
let medium13Font: Font = Font.custom(pretendardMedium, size: Size.w(13))
let medium12Font: Font = Font.custom(pretendardMedium, size: Size.w(12))
let medium11Font: Font = Font.custom(pretendardMedium, size: Size.w(11))

let light30Font: Font = Font.custom(pretendardLight, size: Size.w(30))
let light22Font: Font = Font.custom(pretendardLight, size: Size.w(22))
let light20Font: Font = Font.custom(pretendardLight, size: Size.w(20))
let light18Font: Font = Font.custom(pretendardLight, size: Size.w(18))
let light16Font: Font = Font.custom(pretendardLight, size: Size.w(16))
let light14Font: Font = Font.custom(pretendardLight, size: Size.w(14))
let light12Font: Font = Font.custom(pretendardLight, size: Size.w(12))
let light11Font: Font = Font.custom(pretendardLight, size: Size.w(11))
let light10Font: Font = Font.custom(pretendardLight, size: Size.w(10))

let thin18Font: Font = Font.custom(pretendardThin, size: Size.w(18))
