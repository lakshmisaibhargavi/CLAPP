import 'dart:ui';

import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Terms and Conditions'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'CLAPP PLATFORM respects your privacy and is committed to protecting it. Please read this privacy policy (“Policy”) carefully to understand our practices regarding your information. By installing, subscribing to, accessing or using the CLAPP Platform, you agree to this Policy.',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                      'This Policy applies only to information we obtain from you through the CLAPP Platform. It does not apply to information that we may obtain from sources other than CLAPP Platform who provide your information based on their privacy policies and your interaction with their offerings. CLAPP Platform may also be permitted to collect certain information about you from the websites, applications, channels, services or landing pages (“Sites”) you access through CLAPP Platform by the provider/owner of such Sites, in which case, we will treat such information in accordance with the privacy policies of such Sites in addition to this Policy, subject to the terms of the former. ',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      '1. If you elect to install, launch, access and/or use the CLAPP Platform, we will ask you to provide certain information to create your account such as name, telephone number, age and gender. You may also provide the CLAPP Platform with additional information such as content/category preferences, location, areas of interest, language, region preferences etc. in order to customize the experience for you.',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      '2. When you access, and use the CLAPP Platform including when you view any advertisement displayed there, the CLAPP Platform may collect:',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      '1. Details of your access to and use of the CLAPP Platform, including interaction data',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      '2. We may collect information about or on your device such as the online device identifiers, advertising identifiers, device make, IP Address.\n3. The CLAPP Platform collects information about the location of your smart device if you permit. You can choose whether or not to allow the CLAPP Platform to collect information about your device\'s location by turning off the location settings on your device.',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      '4. When you use the CLAPP Platform or its content, certain third parties may use automatic information collection technologies to collect information about you or your device. These third parties may include Ad Partners, ad servers, attribution partners and analytics companies, your device manufacturer and/or your network service provider etc.\n5. Information about advertisements presented on your the CLAPP Platform: Company also collects some or all of the following information about an ad presented on your device: (i) the content type of the ad (what the ad is about, e.g. games, entertainment, news); (ii) the ad type (e.g. whether the ad is a text, image, or video based ad); (iii) where the ad is being served (e.g. the address of the site on which the ad appears); and (iv) certain information about post-click activity in relation to the ad including user interaction with such ad.',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      '3. We (and our partners and Affiliates) may use information that is collected about you or that you provide, to (collectively referred to as “Permitted Purposes”):\n1. Provide you with the CLAPP Platform features and its contents, such as location-based events, featured stories, offers and any other content\n2. Provide advertisements, promotions and/or offerings that may be of interest to you by itself, Ad Partners or Affiliates.\n3. Notify you when any relevant CLAPP Platform updates or upgrades are available and requires notification.',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      '4. Enrich, build custom audience segments or merged data sets (using the data referred herein and/or third party or Affiliate provided data sets) to enable CLAPP Platform, Ad Partners or Affiliates to better target advertisements and offer their services.\n5. Analyze and provide our Ad Partners with reports on the effectiveness of advertisements and campaigns run on CLAPP Platform.\n4. We may disclose aggregated information about our users, and information that does not identify any individual or device. We may also disclose information that we collect, or you provide:',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      '1. Partners. We may share your data with our Ad Partners, vendors, customers, data partners, measurement companies, and other third parties we partner with for providing our products and services.\n2.  Legal Disclosures. We may access, preserve, and disclose any information we store associated with you to external parties if we, in good faith, believe doing so is required or appropriate to: comply with law enforcement or national security requests and legal process, such as a court order or subpoena; protect your, our or others\’ rights, property, or safety; enforce our policies or contracts; collect amounts owed to us; or assist with an investigation or prosecution of suspected or actual illegal activity.',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      '5. We have implemented suitable technical and organizational measures to secure your personal information in compliance with our legal and privacy requirements and contractual obligations. We also seek appropriate contractual protection from our partners regarding their collection, use or treatment of user data. Unfortunately, the transmission of information via the internet and mobile platforms is not completely secure.',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      '6. Company may retain the information relating to your device collected for a period of up to 36 months, unless otherwise required by law or applicable contract\n7. You have to understand that when the user information is modified by end user  the old data is not stored with the owners and will be permanently deleted(old data means the data before you modified)\n8. We may update our privacy policy from time to time. If we make any material changes, we will notify you by means of a notice on this site prior to the change becoming effective. Please check our Privacy Policy regularly to ensure you have read the latest version.',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            )));
  }
}
