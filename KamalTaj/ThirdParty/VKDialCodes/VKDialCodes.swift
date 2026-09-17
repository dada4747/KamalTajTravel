//
//  VKDialCodes.swift
//  Yathir
//
//  Created by Anand S on 18/07/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import CoreTelephony

class VKDialCodes: NSObject {

    // instance
    static let shared = VKDialCodes()
    
    // countries dial codes
    var dialCodes_array: [[String: String]] = []
    
    // current country dial code
    var current_dialCode: [String: String] = [:]
    
    // init...
    private override init() {
        super.init()
        self.countriesWithISO()
        self.currentDialCode()
    }
}

extension VKDialCodes {
    
    // get country dial code -> country_code like "91" or "1"
    func getDialCode(country_code: String) -> [String: String] {
        
        // selected dial code...
        var c_dialcode: [String: String] = [:]
        for i in 0 ..< dialCodes_array.count {
            
            // trim dial code...
            let temp_code = dialCodes_array[i]["DialCode"]?.replacingOccurrences(of: "+", with: "")
            if country_code == temp_code {
                c_dialcode = dialCodes_array[i]
                break
            }
        }
        return c_dialcode
    }
    
    // current country dial code
    private func currentDialCode() {
        
        // getting net provider details...
        let network_Info = CTTelephonyNetworkInfo()
        let carrier: CTCarrier? = network_Info.subscriberCellularProvider
        if #available(iOS 12.0, *) {
            print(network_Info.serviceSubscriberCellularProviders ?? [:])
        } else {
            // Fallback on earlier versions
        }
        
        // getting iso code form sim or locale
        let currentLocale = NSLocale.current as NSLocale
        var iso_code = currentLocale.object(forKey: .countryCode) as? String
        if carrier?.isoCountryCode != nil {
            iso_code = carrier?.isoCountryCode ?? "US"
        }
        
        // getting country name...
        let identifier_name = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: iso_code ?? "US"])
        let country_name = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: identifier_name) ?? "Country not found"
        
        // current location dial code object...
        current_dialCode = ["ISOCode": iso_code ?? "US", "Country": country_name, "DialCode": ""]
        
        // getting dial codes...
        let country_dialCodes = countriesWithDialCodes()
        for (key, values) in country_dialCodes {
            if country_name == key {
                current_dialCode["DialCode"] = values
                break
            }
        }
    }

    // country list getting.....
    private func countriesWithISO() -> Void {
        
        // country iso code...
        var countries_list: [[String: String]] = []
        for iso_code in NSLocale.isoCountryCodes as [String] {
            
            let identifier_name = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: iso_code])
            let country_name = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: identifier_name) ?? "Country not found for code: \(iso_code)"
            countries_list.append(["ISOCode": iso_code, "Country": country_name, "DialCode": ""])
        }
        
        // getting dial codes...
        let country_dialCodes = countriesWithDialCodes()
        for i in 0 ..< countries_list.count {
            var country_dict = countries_list[i]
            
            for (key, values) in country_dialCodes {
                if key == country_dict["Country"] {
                    
                    country_dict["DialCode"] = values
                    countries_list[i] = country_dict
                }
            }
        }
        
        // final result array...
        let final_predicate = NSPredicate(format: "DialCode != %@", "")
        let result_arry = countries_list.filter { final_predicate.evaluate(with: $0) }
        print("Result least : \(result_arry.count)")
        
        // sorting...
        let results = result_arry.sorted(by: { ($0["Country"] ?? "").localizedCaseInsensitiveCompare(($1["Country"] ?? "")) == ComparisonResult.orderedAscending })
        dialCodes_array = results
        
        // empty predicate code not available...
        let predicate = NSPredicate(format: "DialCode == %@", "")
        let final_arry = countries_list.filter { predicate.evaluate(with: $0) }
        print("Empty least : \(final_arry.count)")
    }
    
    
    private func countriesWithDialCodes() -> [String: String] {
        
        // country dial codes...
        let country_dials: [String: String] = [
            
            "Abkhazia"                                     : "+7840",
            "Afghanistan"                                  : "+93",
            "Albania"                                      : "+355",
            "Algeria"                                      : "+213",
            "American Samoa"                               : "+1684",
            "Andorra"                                      : "+376",
            "Angola"                                       : "+244",
            "Anguilla"                                     : "+1264",
            "Antigua & Barbuda"                            : "+1268",
            "Argentina"                                    : "+54",
            "Armenia"                                      : "+374",
            "Aruba"                                        : "+297",
            "Ascension Island"                             : "+247",
            "Antarctica"                                   : "+672",
            "Australia"                                    : "+61",
            "Australian External Territories"              : "+672",
            "Austria"                                      : "+43",
            "Azerbaijan"                                   : "+994",
            
            "Bahamas"                                      : "+1242",
            "Bahrain"                                      : "+973",
            "Bangladesh"                                   : "+880",
            "Barbados"                                     : "+1246",
            "Barbuda"                                      : "+1268",
            "Belarus"                                      : "+375",
            "Belgium"                                      : "+32",
            "Belize"                                       : "+501",
            "Benin"                                        : "+229",
            "Bermuda"                                      : "+1441",
            "Bhutan"                                       : "+975",
            "Bolivia"                                      : "+591",
            "Bosnia & Herzegovina"                         : "+387",
            "Botswana"                                     : "+267",
            "Brazil"                                       : "+55",
            "British Indian Ocean Territory"               : "+246",
            "British Virgin Islands"                       : "+1284",
            "Brunei"                                       : "+673",
            "Bulgaria"                                     : "+359",
            "Burkina Faso"                                 : "+226",
            "Burundi"                                      : "+257",
            
            "Cambodia"                                     : "+855",
            "Cameroon"                                     : "+237",
            "Canada"                                       : "+1",
            "Cape Verde"                                   : "+238",
            "Cayman Islands"                               : "+345",
            "Central African Republic"                     : "+236",
            "Chad"                                         : "+235",
            "Chile"                                        : "+56",
            "China"                                        : "+86",
            "Christmas Island"                             : "+61",
            "Cocos-Keeling Islands"                        : "+61",
            "Colombia"                                     : "+57",
            "Comoros"                                      : "+269",
            "Congo"                                        : "+242",
            "Congo, Dem. Rep. of (Zaire)"                  : "+243",
            "Cook Islands"                                 : "+682",
            "Costa Rica"                                   : "+506",
            "Croatia"                                      : "+385",
            "Cuba"                                         : "+53",
            "Curacao"                                      : "+599",
            "Cyprus"                                       : "+537",
            "Czech Republic"                               : "+420",
            
            "Denmark"                                      : "+45",
            "Diego Garcia"                                 : "+246",
            "Djibouti"                                     : "+253",
            "Dominica"                                     : "+1767",
            "Dominican Republic"                           : "+1809",
            
            "East Timor"                                   : "+670",
            "Easter Island"                                : "+56",
            "Ecuador"                                      : "+593",
            "Egypt"                                        : "+20",
            "El Salvador"                                  : "+503",
            "Equatorial Guinea"                            : "+240",
            "Eritrea"                                      : "+291",
            "Estonia"                                      : "+372",
            "Ethiopia"                                     : "+251",
            
            "Falkland Islands"                             : "+500",
            "Faroe Islands"                                : "+298",
            "Fiji"                                         : "+679",
            "Finland"                                      : "+358",
            "France"                                       : "+33",
            "French Antilles"                              : "+596",
            "French Guiana"                                : "+594",
            "French Polynesia"                             : "+689",
            
            "Gabon"                                        : "+241",
            "Gambia"                                       : "+220",
            "Georgia"                                      : "+995",
            "Germany"                                      : "+49",
            "Ghana"                                        : "+233",
            "Gibraltar"                                    : "+350",
            "Greece"                                       : "+30",
            "Greenland"                                    : "+299",
            "Grenada"                                      : "+1473",
            "Guadeloupe"                                   : "+590",
            "Guam"                                         : "+1671",
            "Guatemala"                                    : "+502",
            "Guinea"                                       : "+224",
            "Guinea-Bissau"                                : "+245",
            "Guyana"                                       : "+595",
            
            "Haiti"                                        : "+509",
            "Honduras"                                     : "+504",
            "Hong Kong SAR China"                          : "+852",
            "Hungary"                                      : "+36",
            
            "Iceland"                                      : "+354",
            "India"                                        : "+91",
            "Indonesia"                                    : "+62",
            "Iran"                                         : "+98",
            "Iraq"                                         : "+964",
            "Ireland"                                      : "+353",
            "Israel"                                       : "+972",
            "Italy"                                        : "+39",
            "Ivory Coast"                                  : "+225",
            
            "Jamaica"                                      : "+1876",
            "Japan"                                        : "+81",
            "Jordan"                                       : "+962",
            
            "Kazakhstan"                                   : "+77",
            "Kenya"                                        : "+254",
            "Kiribati"                                     : "+686",
            "Kuwait"                                       : "+965",
            "Kyrgyzstan"                                   : "+996",
            
            "Laos"                                         : "+856",
            "Latvia"                                       : "+371",
            "Lebanon"                                      : "+961",
            "Lesotho"                                      : "+266",
            "Liberia"                                      : "+231",
            "Libya"                                        : "+218",
            "Liechtenstein"                                : "+423",
            "Lithuania"                                    : "+370",
            "Luxembourg"                                   : "+352",
            
            "Macau SAR China"                              : "+853",
            "Macedonia"                                    : "+389",
            "Madagascar"                                   : "+261",
            "Malawi"                                       : "+265",
            "Malaysia"                                     : "+60",
            "Maldives"                                     : "+960",
            "Mali"                                         : "+223",
            "Malta"                                        : "+356",
            "Marshall Islands"                             : "+692",
            "Martinique"                                   : "+596",
            "Mauritania"                                   : "+222",
            "Mauritius"                                    : "+230",
            "Mayotte"                                      : "+262",
            "Mexico"                                       : "+52",
            "Micronesia"                                   : "+691",
            "Midway Island"                                : "+1808",
            "Moldova"                                      : "+373",
            "Monaco"                                       : "+377",
            "Mongolia"                                     : "+976",
            "Montenegro"                                   : "+382",
            "Montserrat"                                   : "+1664",
            "Morocco"                                      : "+212",
            "Myanmar"                                      : "+95",
            
            "Namibia"                                      : "+264",
            "Nauru"                                        : "+674",
            "Nepal"                                        : "+977",
            "Netherlands"                                  : "+31",
            "Netherlands Antilles"                         : "+599",
            "Caribbean Netherlands"                        : "+599",
            "Nevis"                                        : "+1869",
            "New Caledonia"                                : "+687",
            "New Zealand"                                  : "+64",
            "Nicaragua"                                    : "+505",
            "Niger"                                        : "+227",
            "Nigeria"                                      : "+234",
            "Niue"                                         : "+683",
            "Norfolk Island"                               : "+672",
            "Northern Mariana Islands"                     : "+1670",
            "Norway"                                       : "+47",
            "North Korea"                                  : "+850",
            
            "Oman"                                         : "+968",
            
            "Pakistan"                                     : "+92",
            "Palau"                                        : "+680",
            "Palestinian Territory"                        : "+970",
            "Panama"                                       : "+507",
            "Papua New Guinea"                             : "+675",
            "Paraguay"                                     : "+595",
            "Peru"                                         : "+51",
            "Philippines"                                  : "+63",
            "Poland"                                       : "+48",
            "Portugal"                                     : "+351",
            "Puerto Rico"                                  : "+1787",
            
            "Qatar"                                        : "+974",
            
            "Reunion"                                      : "+262",
            "Romania"                                      : "+40",
            "Russia"                                       : "+7",
            "Rwanda"                                       : "+250",
            
            "Samoa"                                        : "+685",
            "San Marino"                                   : "+378",
            "Saudi Arabia"                                 : "+966",
            "Senegal"                                      : "+221",
            "Serbia"                                       : "+381",
            "Seychelles"                                   : "+248",
            "Sierra Leone"                                 : "+232",
            "Singapore"                                    : "+65",
            "Slovakia"                                     : "+421",
            "Slovenia"                                     : "+386",
            "Solomon Islands"                              : "+677",
            "South Africa"                                 : "+27",
            "South Georgia and the South Sandwich Islands" : "+500",
            "South Korea"                                  : "+82",
            "Spain"                                        : "+34",
            "Sri Lanka"                                    : "+94",
            "Sudan"                                        : "+249",
            "Suriname"                                     : "+597",
            "Swaziland"                                    : "+268",
            "Sweden"                                       : "+46",
            "Switzerland"                                  : "+41",
            "Syria"                                        : "+963",
            
            "Taiwan"                                       : "+886",
            "Tajikistan"                                   : "+992",
            "Tanzania"                                     : "+255",
            "Thailand"                                     : "+66",
            "Timor Leste"                                  : "+670",
            "Togo"                                         : "+228",
            "Tokelau"                                      : "+690",
            "Tonga"                                        : "+676",
            "Trinidad & Tobago"                            : "+1868",
            "Tunisia"                                      : "+216",
            "Turkey"                                       : "+90",
            "Turkmenistan"                                 : "+993",
            "Turks & Caicos Islands"                       : "+1649",
            "Tuvalu"                                       : "+688",
            
            "Uganda"                                       : "+256",
            "Ukraine"                                      : "+380",
            "United Arab Emirates"                         : "+971",
            "United Kingdom"                               : "+44",
            "United States"                                : "+1",
            "Uruguay"                                      : "+598",
            "US Virgin Islands"                            : "+1340",
            "Uzbekistan"                                   : "+998",
            
            "Vanuatu"                                      : "+678",
            "Venezuela"                                    : "+58",
            "Vietnam"                                      : "+84",
            
            "Wake Island"                                  : "+1808",
            "Wallis and Futuna"                            : "+681",
            
            "Yemen"                                        : "+967",
            
            "Zambia"                                       : "+260",
            "Zanzibar"                                     : "+255",
            "Zimbabwe"                                     : "+263"]
        
        return country_dials
    }
}


/*

[["dial_code": "+247", "iso": "AC", "name": "Ascension Island"],
["dial_code": "+376", "iso": "AD", "name": "Andorra"],
["dial_code": "+971", "iso": "AE", "name": "United Arab Emirates"],
["dial_code": "+93", "iso": "AF", "name": "Afghanistan"],
["dial_code": "+1268", "iso": "AG", "name": "Antigua & Barbuda"],
["dial_code": "+1264", "iso": "AI", "name": "Anguilla"],
["dial_code": "+355", "iso": "AL", "name": "Albania"],
["dial_code": "+374", "iso": "AM", "name": "Armenia"],
["dial_code": "+244", "iso": "AO", "name": "Angola"],
["dial_code": "+672", "iso": "AQ", "name": "Antarctica"],
["dial_code": "+54", "iso": "AR", "name": "Argentina"],
["dial_code": "+1684", "iso": "AS", "name": "American Samoa"],
["dial_code": "+43", "iso": "AT", "name": "Austria"],
["dial_code": "+61", "iso": "AU", "name": "Australia"],
["dial_code": "+297", "iso": "AW", "name": "Aruba"],
["dial_code": "", "iso": "AX", "name": "Åland Islands"],
["dial_code": "+994", "iso": "AZ", "name": "Azerbaijan"],
["dial_code": "+387", "iso": "BA", "name": "Bosnia & Herzegovina"],
["dial_code": "+1246", "iso": "BB", "name": "Barbados"],
["dial_code": "+880", "iso": "BD", "name": "Bangladesh"],
["dial_code": "+32", "iso": "BE", "name": "Belgium"],
["dial_code": "+226", "iso": "BF", "name": "Burkina Faso"],
["dial_code": "+359", "iso": "BG", "name": "Bulgaria"],
["dial_code": "+973", "iso": "BH", "name": "Bahrain"],
["dial_code": "+257", "iso": "BI", "name": "Burundi"],
["dial_code": "+229", "iso": "BJ", "name": "Benin"],
["dial_code": "", "iso": "BL", "name": "St. Barthélemy"],
["dial_code": "+1441", "iso": "BM", "name": "Bermuda"],
["dial_code": "+673", "iso": "BN", "name": "Brunei"],
["dial_code": "+591", "iso": "BO", "name": "Bolivia"],
["dial_code": "+599", "iso": "BQ", "name": "Caribbean Netherlands"],
["dial_code": "+55", "iso": "BR", "name": "Brazil"],
["dial_code": "+1242", "iso": "BS", "name": "Bahamas"],
["dial_code": "+975", "iso": "BT", "name": "Bhutan"],
["dial_code": "", "iso": "BV", "name": "Bouvet Island"],
["dial_code": "+267", "iso": "BW", "name": "Botswana"],
["dial_code": "+375", "iso": "BY", "name": "Belarus"],
["dial_code": "+501", "iso": "BZ", "name": "Belize"],
["dial_code": "+1", "iso": "CA", "name": "Canada"],
["dial_code": "", "iso": "CC", "name": "Cocos [Keeling] Islands"],
["dial_code": "", "iso": "CD", "name": "Congo - Kinshasa"],
["dial_code": "+236", "iso": "CF", "name": "Central African Republic"],
["dial_code": "", "iso": "CG", "name": "Congo - Brazzaville"],
["dial_code": "+41", "iso": "CH", "name": "Switzerland"],
["dial_code": "", "iso": "CI", "name": "Côte d’Ivoire"],
["dial_code": "+682", "iso": "CK", "name": "Cook Islands"],
["dial_code": "+56", "iso": "CL", "name": "Chile"],
["dial_code": "+237", "iso": "CM", "name": "Cameroon"],
["dial_code": "+86", "iso": "CN", "name": "China"],
["dial_code": "+57", "iso": "CO", "name": "Colombia"],
["dial_code": "", "iso": "CP", "name": "Clipperton Island"],
["dial_code": "+506", "iso": "CR", "name": "Costa Rica"],
["dial_code": "+53", "iso": "CU", "name": "Cuba"],
["dial_code": "+238", "iso": "CV", "name": "Cape Verde"],
["dial_code": "", "iso": "CW", "name": "Curaçao"],
["dial_code": "+61", "iso": "CX", "name": "Christmas Island"],
["dial_code": "+537", "iso": "CY", "name": "Cyprus"],
["dial_code": "", "iso": "CZ", "name": "Czechia"],
["dial_code": "+49", "iso": "DE", "name": "Germany"],
["dial_code": "+246", "iso": "DG", "name": "Diego Garcia"],
["dial_code": "+253", "iso": "DJ", "name": "Djibouti"],
["dial_code": "+45", "iso": "DK", "name": "Denmark"],
["dial_code": "+1767", "iso": "DM", "name": "Dominica"],
["dial_code": "+1809", "iso": "DO", "name": "Dominican Republic"],
["dial_code": "+213", "iso": "DZ", "name": "Algeria"],
["dial_code": "", "iso": "EA", "name": "Ceuta & Melilla"],
["dial_code": "+593", "iso": "EC", "name": "Ecuador"],
["dial_code": "+372", "iso": "EE", "name": "Estonia"],
["dial_code": "+20", "iso": "EG", "name": "Egypt"],
["dial_code": "", "iso": "EH", "name": "Western Sahara"],
["dial_code": "+291", "iso": "ER", "name": "Eritrea"],
["dial_code": "+34", "iso": "ES", "name": "Spain"],
["dial_code": "+251", "iso": "ET", "name": "Ethiopia"],
["dial_code": "+358", "iso": "FI", "name": "Finland"],
["dial_code": "+679", "iso": "FJ", "name": "Fiji"],
["dial_code": "+500", "iso": "FK", "name": "Falkland Islands"],
["dial_code": "+691", "iso": "FM", "name": "Micronesia"],
["dial_code": "+298", "iso": "FO", "name": "Faroe Islands"],
["dial_code": "+33", "iso": "FR", "name": "France"],
["dial_code": "+241", "iso": "GA", "name": "Gabon"],
["dial_code": "+44", "iso": "GB", "name": "United Kingdom"],
["dial_code": "+1473", "iso": "GD", "name": "Grenada"],
["dial_code": "+995", "iso": "GE", "name": "Georgia"],
["dial_code": "+594", "iso": "GF", "name": "French Guiana"],
["dial_code": "", "iso": "GG", "name": "Guernsey"],
["dial_code": "+233", "iso": "GH", "name": "Ghana"],
["dial_code": "+350", "iso": "GI", "name": "Gibraltar"],
["dial_code": "+299", "iso": "GL", "name": "Greenland"],
["dial_code": "+220", "iso": "GM", "name": "Gambia"],
["dial_code": "+224", "iso": "GN", "name": "Guinea"],
["dial_code": "+590", "iso": "GP", "name": "Guadeloupe"],
["dial_code": "+240", "iso": "GQ", "name": "Equatorial Guinea"],
["dial_code": "+30", "iso": "GR", "name": "Greece"],
["dial_code": "", "iso": "GS", "name": "So. Georgia & So. Sandwich Isl."],
["dial_code": "+502", "iso": "GT", "name": "Guatemala"],
["dial_code": "+1671", "iso": "GU", "name": "Guam"],
["dial_code": "+245", "iso": "GW", "name": "Guinea-Bissau"],
["dial_code": "+595", "iso": "GY", "name": "Guyana"],
["dial_code": "", "iso": "HK", "name": "Hong Kong [China]"],
["dial_code": "", "iso": "HM", "name": "Heard & McDonald Islands"],
["dial_code": "+504", "iso": "HN", "name": "Honduras"],
["dial_code": "+385", "iso": "HR", "name": "Croatia"],
["dial_code": "+509", "iso": "HT", "name": "Haiti"],
["dial_code": "+36", "iso": "HU", "name": "Hungary"],
["dial_code": "", "iso": "IC", "name": "Canary Islands"],
["dial_code": "+62", "iso": "ID", "name": "Indonesia"],
["dial_code": "+353", "iso": "IE", "name": "Ireland"],
["dial_code": "+972", "iso": "IL", "name": "Israel"],
["dial_code": "", "iso": "IM", "name": "Isle of Man"],
["dial_code": "+91", "iso": "IN", "name": "India"],
["dial_code": "+246", "iso": "IO", "name": "British Indian Ocean Territory"],
["dial_code": "+964", "iso": "IQ", "name": "Iraq"],
["dial_code": "+98", "iso": "IR", "name": "Iran"],
["dial_code": "+354", "iso": "IS", "name": "Iceland"],
["dial_code": "+39", "iso": "IT", "name": "Italy"],
["dial_code": "", "iso": "JE", "name": "Jersey"],
["dial_code": "+1876", "iso": "JM", "name": "Jamaica"],
["dial_code": "+962", "iso": "JO", "name": "Jordan"],
["dial_code": "+81", "iso": "JP", "name": "Japan"],
["dial_code": "+254", "iso": "KE", "name": "Kenya"],
["dial_code": "+996", "iso": "KG", "name": "Kyrgyzstan"],
["dial_code": "+855", "iso": "KH", "name": "Cambodia"],
["dial_code": "+686", "iso": "KI", "name": "Kiribati"],
["dial_code": "+269", "iso": "KM", "name": "Comoros"],
["dial_code": "", "iso": "KN", "name": "St. Kitts & Nevis"],
["dial_code": "+850", "iso": "KP", "name": "North Korea"],
["dial_code": "+82", "iso": "KR", "name": "South Korea"],
["dial_code": "+965", "iso": "KW", "name": "Kuwait"],
["dial_code": "+345", "iso": "KY", "name": "Cayman Islands"],
["dial_code": "+77", "iso": "KZ", "name": "Kazakhstan"],
["dial_code": "+856", "iso": "LA", "name": "Laos"],
["dial_code": "+961", "iso": "LB", "name": "Lebanon"],
["dial_code": "", "iso": "LC", "name": "St. Lucia"],
["dial_code": "+423", "iso": "LI", "name": "Liechtenstein"],
["dial_code": "+94", "iso": "LK", "name": "Sri Lanka"],
["dial_code": "+231", "iso": "LR", "name": "Liberia"],
["dial_code": "+266", "iso": "LS", "name": "Lesotho"],
["dial_code": "+370", "iso": "LT", "name": "Lithuania"],
["dial_code": "+352", "iso": "LU", "name": "Luxembourg"],
["dial_code": "+371", "iso": "LV", "name": "Latvia"],
["dial_code": "+218", "iso": "LY", "name": "Libya"],
["dial_code": "+212", "iso": "MA", "name": "Morocco"],
["dial_code": "+377", "iso": "MC", "name": "Monaco"],
["dial_code": "+373", "iso": "MD", "name": "Moldova"],
["dial_code": "+382", "iso": "ME", "name": "Montenegro"],
["dial_code": "", "iso": "MF", "name": "St. Martin"],
["dial_code": "+261", "iso": "MG", "name": "Madagascar"],
["dial_code": "+692", "iso": "MH", "name": "Marshall Islands"],
["dial_code": "+389", "iso": "MK", "name": "Macedonia"],
["dial_code": "+223", "iso": "ML", "name": "Mali"],
["dial_code": "", "iso": "MM", "name": "Myanmar [Burma]"],
["dial_code": "+976", "iso": "MN", "name": "Mongolia"],
["dial_code": "", "iso": "MO", "name": "Macau [China]"],
["dial_code": "+1670", "iso": "MP", "name": "Northern Mariana Islands"],
["dial_code": "+596", "iso": "MQ", "name": "Martinique"],
["dial_code": "+222", "iso": "MR", "name": "Mauritania"],
["dial_code": "+1664", "iso": "MS", "name": "Montserrat"],
["dial_code": "+356", "iso": "MT", "name": "Malta"],
["dial_code": "+230", "iso": "MU", "name": "Mauritius"],
["dial_code": "+960", "iso": "MV", "name": "Maldives"],
["dial_code": "+265", "iso": "MW", "name": "Malawi"],
["dial_code": "+52", "iso": "MX", "name": "Mexico"],
["dial_code": "+60", "iso": "MY", "name": "Malaysia"],
["dial_code": "", "iso": "MZ", "name": "Mozambique"],
["dial_code": "+264", "iso": "NA", "name": "Namibia"],
["dial_code": "+687", "iso": "NC", "name": "New Caledonia"],
["dial_code": "+227", "iso": "NE", "name": "Niger"],
["dial_code": "+672", "iso": "NF", "name": "Norfolk Island"],
["dial_code": "+234", "iso": "NG", "name": "Nigeria"],
["dial_code": "+505", "iso": "NI", "name": "Nicaragua"],
["dial_code": "+31", "iso": "NL", "name": "Netherlands"],
["dial_code": "+47", "iso": "NO", "name": "Norway"],
["dial_code": "+977", "iso": "NP", "name": "Nepal"],
["dial_code": "+674", "iso": "NR", "name": "Nauru"],
["dial_code": "+683", "iso": "NU", "name": "Niue"],
["dial_code": "+64", "iso": "NZ", "name": "New Zealand"],
["dial_code": "+968", "iso": "OM", "name": "Oman"],
["dial_code": "+507", "iso": "PA", "name": "Panama"],
["dial_code": "+51", "iso": "PE", "name": "Peru"],
["dial_code": "+689", "iso": "PF", "name": "French Polynesia"],
["dial_code": "+675", "iso": "PG", "name": "Papua New Guinea"],
["dial_code": "+63", "iso": "PH", "name": "Philippines"],
["dial_code": "+92", "iso": "PK", "name": "Pakistan"],
["dial_code": "+48", "iso": "PL", "name": "Poland"],
["dial_code": "", "iso": "PM", "name": "St. Pierre & Miquelon"],
["dial_code": "", "iso": "PN", "name": "Pitcairn Islands"],
["dial_code": "+1787", "iso": "PR", "name": "Puerto Rico"],
["dial_code": "", "iso": "PS", "name": "Palestinian Territories"],
["dial_code": "+351", "iso": "PT", "name": "Portugal"],
["dial_code": "+680", "iso": "PW", "name": "Palau"],
["dial_code": "+595", "iso": "PY", "name": "Paraguay"],
["dial_code": "+974", "iso": "QA", "name": "Qatar"],
["dial_code": "", "iso": "RE", "name": "Réunion"],
["dial_code": "+40", "iso": "RO", "name": "Romania"],
["dial_code": "+381", "iso": "RS", "name": "Serbia"],
["dial_code": "+7", "iso": "RU", "name": "Russia"],
["dial_code": "+250", "iso": "RW", "name": "Rwanda"],
["dial_code": "+966", "iso": "SA", "name": "Saudi Arabia"],
["dial_code": "+677", "iso": "SB", "name": "Solomon Islands"],
["dial_code": "+248", "iso": "SC", "name": "Seychelles"],
["dial_code": "+249", "iso": "SD", "name": "Sudan"],
["dial_code": "+46", "iso": "SE", "name": "Sweden"],
["dial_code": "+65", "iso": "SG", "name": "Singapore"],
["dial_code": "", "iso": "SH", "name": "St. Helena"],
["dial_code": "+386", "iso": "SI", "name": "Slovenia"],
["dial_code": "", "iso": "SJ", "name": "Svalbard & Jan Mayen"],
["dial_code": "+421", "iso": "SK", "name": "Slovakia"],
["dial_code": "+232", "iso": "SL", "name": "Sierra Leone"],
["dial_code": "+378", "iso": "SM", "name": "San Marino"],
["dial_code": "+221", "iso": "SN", "name": "Senegal"],
["dial_code": "", "iso": "SO", "name": "Somalia"],
["dial_code": "+597", "iso": "SR", "name": "Suriname"],
["dial_code": "", "iso": "SS", "name": "South Sudan"],
["dial_code": "", "iso": "ST", "name": "São Tomé & Príncipe"],
["dial_code": "+503", "iso": "SV", "name": "El Salvador"],
["dial_code": "", "iso": "SX", "name": "Sint Maarten"],
["dial_code": "+963", "iso": "SY", "name": "Syria"],
["dial_code": "+268", "iso": "SZ", "name": "Swaziland"],
["dial_code": "", "iso": "TA", "name": "Tristan da Cunha"],
["dial_code": "+1649", "iso": "TC", "name": "Turks & Caicos Islands"],
["dial_code": "+235", "iso": "TD", "name": "Chad"],
["dial_code": "", "iso": "TF", "name": "French Southern Territories"],
["dial_code": "+228", "iso": "TG", "name": "Togo"],
["dial_code": "+66", "iso": "TH", "name": "Thailand"],
["dial_code": "+992", "iso": "TJ", "name": "Tajikistan"],
["dial_code": "+690", "iso": "TK", "name": "Tokelau"],
["dial_code": "", "iso": "TL", "name": "Timor-Leste"],
["dial_code": "+993", "iso": "TM", "name": "Turkmenistan"],
["dial_code": "+216", "iso": "TN", "name": "Tunisia"],
["dial_code": "+676", "iso": "TO", "name": "Tonga"],
["dial_code": "+90", "iso": "TR", "name": "Turkey"],
["dial_code": "+1868", "iso": "TT", "name": "Trinidad & Tobago"],
["dial_code": "+688", "iso": "TV", "name": "Tuvalu"],
["dial_code": "+886", "iso": "TW", "name": "Taiwan"],
["dial_code": "+255", "iso": "TZ", "name": "Tanzania"],
["dial_code": "+380", "iso": "UA", "name": "Ukraine"],
["dial_code": "+256", "iso": "UG", "name": "Uganda"],
["dial_code": "", "iso": "UM", "name": "U.S. Outlying Islands"],
["dial_code": "+1", "iso": "US", "name": "United States"],
["dial_code": "+598", "iso": "UY", "name": "Uruguay"],
["dial_code": "+998", "iso": "UZ", "name": "Uzbekistan"],
["dial_code": "", "iso": "VA", "name": "Vatican City"],
["dial_code": "", "iso": "VC", "name": "St. Vincent & Grenadines"],
["dial_code": "+58", "iso": "VE", "name": "Venezuela"],
["dial_code": "+1284", "iso": "VG", "name": "British Virgin Islands"],
["dial_code": "", "iso": "VI", "name": "U.S. Virgin Islands"],
["dial_code": "+84", "iso": "VN", "name": "Vietnam"],
["dial_code": "+678", "iso": "VU", "name": "Vanuatu"],
["dial_code": "", "iso": "WF", "name": "Wallis & Futuna"],
["dial_code": "+685", "iso": "WS", "name": "Samoa"],
["dial_code": "", "iso": "XK", "name": "Kosovo"],
["dial_code": "+967", "iso": "YE", "name": "Yemen"],
["dial_code": "+262", "iso": "YT", "name": "Mayotte"],
["dial_code": "+27", "iso": "ZA", "name": "South Africa"],
["dial_code": "+260", "iso": "ZM", "name": "Zambia"],
["dial_code": "+263", "iso": "ZW", "name": "Zimbabwe"]]

*/

