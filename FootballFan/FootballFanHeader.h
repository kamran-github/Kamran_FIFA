//
//  FootballFanHeader.h
//  FootballFan
//
//  Created by Apple on 16/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

#ifndef FootballFanHeader_h
#define FootballFanHeader_h
#import "KochavaTracker.h"
#import "sqlite3.h"
#import <time.h>
#define RedeemURL @"https://ifootballfan.com/redeem_android.php"
//Live Server

/*#define JIDPostfix @"@ffopenfire.footballfan.mobi"
 #define MediaAPI @"https://api.footballfan.mobi/ffapi/ffapi.php"
 #define MediaAPIjava @ "https://api.footballfan.mobi:8443/FFJavaAPI/FFAPI"
 #define HostName @"ffopenfire.footballfan.mobi"
 #define InviteHost @"https://link.ifootballfan.com/"
 #define NewsDeepLinkURL @"https://ifootballfan.com/news/newsdetail.php?id="
 #define loadpaypalurl @"https://www.paypal.com/signin/authorize?scope=email&redirect_uri=http://api.footballfan.mobi/ffapi/ffapi.php&response_type=code&client_id=AXfQxK_pfZ0-G0OJz-zVv3rViHJK3Iw1eHKCqRPxhPu2dJBYfMmz4aLjKQM9aeQDPLu2L1j3VCyX68cn"
 #define PaypalWithToken @"https://api.paypal.com/v1/oauth2/token?grant_type=authorization_code&client_id=AXfQxK_pfZ0-G0OJz-zVv3rViHJK3Iw1eHKCqRPxhPu2dJBYfMmz4aLjKQM9aeQDPLu2L1j3VCyX68cn&redirect_uri=http://api.footballfan.mobi/ffapi/ffapi.php&client_secret=EMBk9jb2udhJiAbRuCCemU5HyuiT_wGSCi4D_HlVa2CABHWhXdIrZdWIj3pmAosn3U9YMWUsK8Slv0bG&code="
 #define Client_id @"AXfQxK_pfZ0-G0OJz-zVv3rViHJK3Iw1eHKCqRPxhPu2dJBYfMmz4aLjKQM9aeQDPLu2L1j3VCyX68cn"
 #define Secret_key @"EMBk9jb2udhJiAbRuCCemU5HyuiT_wGSCi4D_HlVa2CABHWhXdIrZdWIj3pmAosn3U9YMWUsK8Slv0bG"
 #define PaypalWithaccess_token @"https://api.paypal.com/v1/oauth2/token/userinfo?schema=openid"
 */
// bundelid for live :com.tridecimal.ltd.footballfan
//Test Server
/*#define JIDPostfix @"@oftest.ifootballfan.com"
 #define MediaAPI @"http://apitest.ifootballfan.com/ffapi/ffapi.php"
 #define MediaAPIjava @ "http://apitest.ifootballfan.com:8080/FFJavaAPI/FFAPI"
 #define HostName @"oftest.ifootballfan.com"
 #define InviteHost @"http://linktest.ifootballfan.com/"
 #define NewsDeepLinkURL @"http://apitest.ifootballfan.com/news/newsdetail.php?id="
 #define loadpaypalurl @"https://www.sandbox.paypal.com/signin/authorize?scope=email&redirect_uri=http://apitest.ifootballfan.com/ffapi/ffapi.php&response_type=code&client_id=AQNdPgkUXvVpykQjbsDvgahGWIX2S7hmGHz1GN9T69ZSejwAgpfEhOgzpxQ2P5dT0cL8V7P_3hBrIk_E&state=mks1645"
 #define PaypalWithToken @"https://api.sandbox.paypal.com/v1/oauth2/token?grant_type=authorization_code&client_id=AQNdPgkUXvVpykQjbsDvgahGWIX2S7hmGHz1GN9T69ZSejwAgpfEhOgzpxQ2P5dT0cL8V7P_3hBrIk_E&redirect_uri=http://apitest.ifootballfan.com/ffapi/ffapi.php&client_secret=EHkT97jYe2Zgmu_R7arQ2gBbZoyDsfeWylI-0zS_RX7fnBeJaMDgT7mwKpEg6hiumVPhISMZXWkuW2N-&code="
 #define Client_id @"AQNdPgkUXvVpykQjbsDvgahGWIX2S7hmGHz1GN9T69ZSejwAgpfEhOgzpxQ2P5dT0cL8V7P_3hBrIk_E"
 #define Secret_key @"EHkT97jYe2Zgmu_R7arQ2gBbZoyDsfeWylI-0zS_RX7fnBeJaMDgT7mwKpEg6hiumVPhISMZXWkuW2N-"
 #define PaypalWithaccess_token @"https://api.sandbox.paypal.com/v1/oauth2/token/userinfo?schema=openid"
 */
//bundelid for test :com.tridecimal.ltd.footballfan.test


//Development Server

#define JIDPostfix @"@openfiredev.ifootballfan.com"
#define MediaAPI @"http://apidev.ifootballfan.com/ffapi/ffapi.php"
#define MediaAPIjava @ "http://apidev.ifootballfan.com:8080/FFJavaAPI/FFAPI"
#define HostName @"openfiredev.ifootballfan.com"
#define InviteHost @"http://linkdev.ifootballfan.com/"
#define NewsDeepLinkURL @"http://apidev.ifootballfan.com/news/newsdetail.php?id="
#define loadpaypalurl @"https://www.sandbox.paypal.com/signin/authorize?scope=email&redirect_uri=http://apidev.ifootballfan.com/ffapi/ffapi.php&response_type=code&client_id=AQNdPgkUXvVpykQjbsDvgahGWIX2S7hmGHz1GN9T69ZSejwAgpfEhOgzpxQ2P5dT0cL8V7P_3hBrIk_E&state=mks1645"
#define PaypalWithToken @"https://api.sandbox.paypal.com/v1/oauth2/token?grant_type=authorization_code&client_id=AQNdPgkUXvVpykQjbsDvgahGWIX2S7hmGHz1GN9T69ZSejwAgpfEhOgzpxQ2P5dT0cL8V7P_3hBrIk_E&redirect_uri=http://apidev.ifootballfan.com/ffapi/ffapi.php&client_secret=EHkT97jYe2Zgmu_R7arQ2gBbZoyDsfeWylI-0zS_RX7fnBeJaMDgT7mwKpEg6hiumVPhISMZXWkuW2N-&code="
#define Client_id @"AQNdPgkUXvVpykQjbsDvgahGWIX2S7hmGHz1GN9T69ZSejwAgpfEhOgzpxQ2P5dT0cL8V7P_3hBrIk_E"
#define Secret_key @"EHkT97jYe2Zgmu_R7arQ2gBbZoyDsfeWylI-0zS_RX7fnBeJaMDgT7mwKpEg6hiumVPhISMZXWkuW2N-"
#define PaypalWithaccess_token @"https://api.sandbox.paypal.com/v1/oauth2/token/userinfo?schema=openid"

//#define baseurl @"https://ffapitest.ifootballfan.com:8443/FFJavaAPI/FFAPI"
#define baseurl @"http://ffapitest.ifootballfan.com:7001"
//#define baseurl @"http://ffapidev.ifootballfan.com:7001"
 
#define Signupmail @"http://api.footballfan.mobi/ffapi/ffapi.php?"
#define groupAvtar @"http://ifootballfan.com/image/group_avatar.jpg"
#define userAvtar @"http://ifootballfan.com/image/avatar.jpg"
#define countrystring @"{\"af\": {\"code\": \"+93\",\"name\": \"Afghanistan\",\"flag\": \"flag_afghanistan.png\"},\"al\": {\"code\": \"+355\",\"name\": \"Albania\",\"flag\": \"flag_albania.png\"},\"dz\": {\"code\": \"+213\",\"name\": \"Algeria\",\"flag\": \"flag_algeria.png\"},\"ad\": {\"code\": \"+376\",\"name\": \"Andorra\",\"flag\": \"flag_andorra.png\"},\"ao\": {\"code\": \"+244\",\"name\": \"Angola\",\"flag\": \"flag_angola.png\"},\"aq\": {\"code\": \"+672\",\"name\": \"Antarctica\",\"flag\": \"flag_antarctica.png\"},\"ar\": {\"code\": \"+54\",\"name\": \"Argentina\",\"flag\": \"flag_argentina.png\"},\"am\": {\"code\": \"+374\",\"name\": \"Armenia\",\"flag\": \"flag_armenia.png\"},\"aw\": {\"code\": \"+297\",\"name\": \"Aruba\",\"flag\": \"flag_aruba.png\"},\"au\": {\"code\": \"+61\",\"name\": \"Australia\",\"flag\": \"flag_australia.png\"},\"at\": {\"code\": \"+43\",\"name\": \"Austria\",\"flag\": \"flag_austria.png\"},\"az\": {\"code\": \"+994\",\"name\": \"Azerbaijan\",\"flag\": \"flag_azerbaijan.png\"},\"bh\": {\"code\": \"+973\",\"name\": \"Bahrain\",\"flag\": \"flag_bahrain.png\"},\"bd\": {\"code\": \"+880\",\"name\": \"Bangladesh\",\"flag\": \"flag_bangladesh.png\"},\"by\": {\"code\": \"+375\",\"name\": \"Belarus\",\"flag\": \"flag_belarus.png\"},\"be\": {\"code\": \"+32\",\"name\": \"Belgium\",\"flag\": \"flag_belgium.png\"},\"bz\": {\"code\": \"+501\",\"name\": \"Belize\",\"flag\": \"flag_belize.png\"},\"bj\": {\"code\": \"+229\",\"name\": \"Benin\",\"flag\": \"flag_benin.png\"},\"bt\": {\"code\": \"+975\",\"name\": \"Bhutan\",\"flag\": \"flag_bhutan.png\"},\"bo\": {\"code\": \"+591\",\"name\": \"Bolivia, Plurinational State Of\",\"flag\": \"flag_bolivia.png\"},\"ba\": {\"code\": \"+387\",\"name\": \"Bosnia And Herzegovina\",\"flag\": \"flag_bosnia.png\"},\"bw\": {\"code\": \"+267\",\"name\": \"Botswana\",\"flag\": \"flag_botswana.png\"},\"br\": {\"code\": \"+55\",\"name\": \"Brazil\",\"flag\": \"flag_brazil.png\"},\"bn\": {\"code\": \"+673\",\"name\": \"Brunei Darussalam\",\"flag\": \"flag_brunei.png\"},\"bg\": {\"code\": \"+359\",\"name\": \"Bulgaria\",\"flag\": \"flag_bulgaria.png\"},\"bf\": {\"code\": \"+226\",\"name\": \"Burkina Faso\",\"flag\": \"flag_burkina_faso.png\"},\"mm\": {\"code\": \"+95\",\"name\": \"Myanmar\",\"flag\": \"flag_myanmar.png\"},\"bi\": {\"code\": \"+257\",\"name\": \"Burundi\",\"flag\": \"flag_burundi.png\"},\"kh\": {\"code\": \"+855\",\"name\": \"Cambodia\",\"flag\": \"flag_cambodia.png\"},\"cm\": {\"code\": \"+237\",\"name\": \"Cameroon\",\"flag\": \"flag_cameroon.png\"},\"ca\": {\"code\": \"+1\",\"name\": \"Canada\",\"flag\": \"flag_canada.png\"},\"cv\": {\"code\": \"+238\",\"name\": \"Cape Verde\",\"flag\": \"flag_cape_verde.png\"},\"cf\": {\"code\": \"+236\",\"name\": \"Central African Republic\",\"flag\": \"flag_central_african_republic.png\"},\"td\": {\"code\": \"+235\",\"name\": \"Chad\",\"flag\": \"flag_chad.png\"},\"cl\": {\"code\": \"+56\",\"name\": \"Chile\",\"flag\": \"flag_chile.png\"},\"cn\": {\"code\": \"+86\",\"name\": \"China\",\"flag\": \"flag_china.png\"},\"cx\": {\"code\": \"+61\",\"name\": \"Christmas Island\",\"flag\": \"flag_christmas_island.png\"},\"cc\": {\"code\": \"+61\",\"name\": \"Cocos (keeling) Islands\",\"flag\": \"flag_cocos.png\"},\"co\": {\"code\": \"+57\",\"name\": \"Colombia\",\"flag\": \"flag_colombia.png\"},\"km\": {\"code\": \"+269\",\"name\": \"Comoros\",\"flag\": \"flag_comoros.png\"},\"cg\": {\"code\": \"+242\",\"name\": \"Congo\",\"flag\": \"flag_republic_of_the_congo.png\"},\"cd\": {\"code\": \"+243\",\"name\": \"Congo, The Democratic Republic Of The\",\"flag\": \"flag_democratic_republic_of_the_congo.png\"},\"ck\": {\"code\": \"+682\",\"name\": \"Cook Islands\",\"flag\": \"flag_cook_islands.png\"},\"cr\": {\"code\": \"+506\",\"name\": \"Costa Rica\",\"flag\": \"flag_costa_rica.png\"},\"hr\": {\"code\": \"+385\",\"name\": \"Croatia\",\"flag\": \"flag_croatia.png\"},\"cu\": {\"code\": \"+53\",\"name\": \"Cuba\",\"flag\": \"flag_cuba.png\"},\"cy\": {\"code\": \"+357\",\"name\": \"Cyprus\",\"flag\": \"flag_cyprus.png\"},\"cz\": {\"code\": \"+420\",\"name\": \"Czech Republic\",\"flag\": \"flag_czech_republic.png\"},\"dk\": {\"code\": \"+45\",\"name\": \"Denmark\",\"flag\": \"flag_denmark.png\"},\"dj\": {\"code\": \"+253\",\"name\": \"Djibouti\",\"flag\": \"flag_djibouti.png\"},\"tl\": {\"code\": \"+670\",\"name\": \"Timor-leste\",\"flag\": \"flag_timor_leste.png\"},\"ec\": {\"code\": \"+593\",\"name\": \"Ecuador\",\"flag\": \"flag_ecuador.png\"},\"eg\": {\"code\": \"+20\",\"name\": \"Egypt\",\"flag\": \"flag_egypt.png\"},\"sv\": {\"code\": \"+503\",\"name\": \"El Salvador\",\"flag\": \"flag_el_salvador.png\"},\"gq\": {\"code\": \"+240\",\"name\": \"Equatorial Guinea\",\"flag\": \"flag_equatorial_guinea.png\"},\"er\": {\"code\": \"+291\",\"name\": \"Eritrea\",\"flag\": \"flag_eritrea.png\"},\"ee\": {\"code\": \"+372\",\"name\": \"Estonia\",\"flag\": \"flag_estonia.png\"},\"et\": {\"code\": \"+251\",\"name\": \"Ethiopia\",\"flag\": \"flag_ethiopia.png\"},\"fk\": {\"code\": \"+500\",\"name\": \"Falkland Islands (malvinas)\",\"flag\": \"flag_falkland_islands.png\"},\"fo\": {\"code\": \"+298\",\"name\": \"Faroe Islands\",\"flag\": \"flag_faroe_islands.png\"},\"fj\": {\"code\": \"+679\",\"name\": \"Fiji\",\"flag\": \"flag_fiji.png\"},\"fi\": {\"code\": \"+358\",\"name\": \"Finland\",\"flag\": \"flag_finland.png\"},\"fr\": {\"code\": \"+33\",\"name\": \"France\",\"flag\": \"flag_france.png\"},\"pf\": {\"code\": \"+689\",\"name\": \"French Polynesia\",\"flag\": \"flag_french_polynesia.png\"},\"ga\": {\"code\": \"+241\",\"name\": \"Gabon\",\"flag\": \"flag_gabon.png\"},\"gm\": {\"code\": \"+220\",\"name\": \"Gambia\",\"flag\": \"flag_gambia.png\"},\"ge\": {\"code\": \"+995\",\"name\": \"Georgia\",\"flag\": \"flag_georgia.png\"},\"de\": {\"code\": \"+49\",\"name\": \"Germany\",\"flag\": \"flag_germany.png\"},\"gh\": {\"code\": \"+233\",\"name\": \"Ghana\",\"flag\": \"flag_ghana.png\"},\"gi\": {\"code\": \"+350\",\"name\": \"Gibraltar\",\"flag\": \"flag_gibraltar.png\"},\"gr\": {\"code\": \"+30\",\"name\": \"Greece\",\"flag\": \"flag_greece.png\"},\"gl\": {\"code\": \"+299\",\"name\": \"Greenland\",\"flag\": \"flag_greenland.png\"},\"gt\": {\"code\": \"+502\",\"name\": \"Guatemala\",\"flag\": \"flag_guatemala.png\"},\"gn\": {\"code\": \"+224\",\"name\": \"Guinea\",\"flag\": \"flag_guinea.png\"},\"gw\": {\"code\": \"+245\",\"name\": \"Guinea-bissau\",\"flag\": \"flag_guinea_bissau.png\"},\"gy\": {\"code\": \"+592\",\"name\": \"Guyana\",\"flag\": \"flag_guyana.png\"},\"ht\": {\"code\": \"+509\",\"name\": \"Haiti\",\"flag\": \"flag_haiti.png\"},\"hn\": {\"code\": \"+504\",\"name\": \"Honduras\",\"flag\": \"flag_honduras.png\"},\"hk\": {\"code\": \"+852\",\"name\": \"Hong Kong\",\"flag\": \"flag_hong_kong.png\"},\"hu\": {\"code\": \"+36\",\"name\": \"Hungary\",\"flag\": \"flag_hungary.png\"},\"in\": {\"code\": \"+91\",\"name\": \"India\",\"flag\": \"flag_india.png\"},\"id\": {\"code\": \"+62\",\"name\": \"Indonesia\",\"flag\": \"flag_indonesia.png\"},\"ir\": {\"code\": \"+98\",\"name\": \"Iran, Islamic Republic Of\",\"flag\": \"flag_iran.png\"},\"iq\": {\"code\": \"+964\",\"name\": \"Iraq\",\"flag\": \"flag_iraq.png\"},\"ie\": {\"code\": \"+353\",\"name\": \"Ireland\",\"flag\": \"flag_ireland.png\"},\"il\": {\"code\": \"+972\",\"name\": \"Israel\",\"flag\": \"flag_israel.png\"},\"it\": {\"code\": \"+39\",\"name\": \"Italy\",\"flag\": \"flag_italy.png\"},\"ci\": {\"code\": \"+225\",\"name\": \"CÙte D\'ivoire\",\"flag\": \"flag_cote_divoire.png\"},\"jp\": {\"code\": \"+81\",\"name\": \"Japan\",\"flag\": \"flag_japan.png\"},\"jo\": {\"code\": \"+962\",\"name\": \"Jordan\",\"flag\": \"flag_jordan.png\"},\"kz\": {\"code\": \"+7\",\"name\": \"Kazakhstan\",\"flag\": \"flag_kazakhstan.png\"},\"ke\": {\"code\": \"+254\",\"name\": \"Kenya\",\"flag\": \"flag_kenya.png\"},\"ki\": {\"code\": \"+686\",\"name\": \"Kiribati\",\"flag\": \"flag_kiribati.png\"},\"kw\": {\"code\": \"+965\",\"name\": \"Kuwait\",\"flag\": \"flag_kuwait.png\"},\"kg\": {\"code\": \"+996\",\"name\": \"Kyrgyzstan\",\"flag\": \"flag_kyrgyzstan.png\"},\"la\": {\"code\": \"+856\",\"name\": \"Lao People\'s Democratic Republic\",\"flag\": \"flag_laos.png\"},\"lv\": {\"code\": \"+371\",\"name\": \"Latvia\",\"flag\": \"flag_latvia.png\"},\"lb\": {\"code\": \"+961\",\"name\": \"Lebanon\",\"flag\": \"flag_lebanon.png\"},\"ls\": {\"code\": \"+266\",\"name\": \"Lesotho\",\"flag\": \"flag_lesotho.png\"},\"lr\": {\"code\": \"+231\",\"name\": \"Liberia\",\"flag\": \"flag_liberia.png\"},\"ly\": {\"code\": \"+218\",\"name\": \"Libya\",\"flag\": \"flag_libya.png\"},\"li\": {\"code\": \"+423\",\"name\": \"Liechtenstein\",\"flag\": \"flag_liechtenstein.png\"},\"lt\": {\"code\": \"+370\",\"name\": \"Lithuania\",\"flag\": \"flag_lithuania.png\"},\"lu\": {\"code\": \"+352\",\"name\": \"Luxembourg\",\"flag\": \"flag_luxembourg.png\"},\"mo\": {\"code\": \"+853\",\"name\": \"Macao\",\"flag\": \"flag_macao.png\"},\"mk\": {\"code\": \"+389\",\"name\": \"Macedonia, The Former Yugoslav Republic Of\",\"flag\": \"flag_macedonia.png\"},\"mg\": {\"code\": \"+261\",\"name\": \"Madagascar\",\"flag\": \"flag_madagascar.png\"},\"mw\": {\"code\": \"+265\",\"name\": \"Malawi\",\"flag\": \"flag_malawi.png\"},\"my\": {\"code\": \"+60\",\"name\": \"Malaysia\",\"flag\": \"flag_malaysia.png\"},\"mv\": {\"code\": \"+960\",\"name\": \"Maldives\",\"flag\": \"flag_maldives.png\"},\"ml\": {\"code\": \"+223\",\"name\": \"Mali\",\"flag\": \"flag_mali.png\"},\"mt\": {\"code\": \"+356\",\"name\": \"Malta\",\"flag\": \"flag_malta.png\"},\"mh\": {\"code\": \"+692\",\"name\": \"Marshall Islands\",\"flag\": \"flag_marshall_islands.png\"},\"mr\": {\"code\": \"+222\",\"name\": \"Mauritania\",\"flag\": \"flag_mauritania.png\"},\"mu\": {\"code\": \"+230\",\"name\": \"Mauritius\",\"flag\": \"flag_mauritius.png\"},\"yt\": {\"code\": \"+262\",\"name\": \"Mayotte\",\"flag\": \"flag_martinique.png\"},\"mx\": {\"code\": \"+52\",\"name\": \"Mexico\",\"flag\": \"flag_mexico.png\"},\"fm\": {\"code\": \"+691\",\"name\": \"Micronesia, Federated States Of\",\"flag\": \"flag_micronesia.png\"},\"md\": {\"code\": \"+373\",\"name\": \"Moldova, Republic Of\",\"flag\": \"flag_moldova.png\"},\"mc\": {\"code\": \"+377\",\"name\": \"Monaco\",\"flag\": \"flag_monaco.png\"},\"mn\": {\"code\": \"+976\",\"name\": \"Mongolia\",\"flag\": \"flag_mongolia.png\"},\"me\": {\"code\": \"+382\",\"name\": \"Montenegro\",\"flag\": \"flag_of_montenegro.png\"},\"ma\": {\"code\": \"+212\",\"name\": \"Morocco\",\"flag\": \"flag_morocco.png\"},\"mz\": {\"code\": \"+258\",\"name\": \"Mozambique\",\"flag\": \"flag_mozambique.png\"},\"na\": {\"code\": \"+264\",\"name\": \"Namibia\",\"flag\": \"flag_namibia.png\"},\"nr\": {\"code\": \"+674\",\"name\": \"Nauru\",\"flag\": \"flag_nauru.png\"},\"np\": {\"code\": \"+977\",\"name\": \"Nepal\",\"flag\": \"flag_nepal.png\"},\"nl\": {\"code\": \"+31\",\"name\": \"Netherlands\",\"flag\": \"flag_netherlands.png\"},\"nc\": {\"code\": \"+687\",\"name\": \"New Caledonia\",\"flag\": \"flag_new_caledonia.png\"},\"nz\": {\"code\": \"+64\",\"name\": \"New Zealand\",\"flag\": \"flag_new_zealand.png\"},\"ni\": {\"code\": \"+505\",\"name\": \"Nicaragua\",\"flag\": \"flag_nicaragua.png\"},\"ne\": {\"code\": \"+227\",\"name\": \"Niger\",\"flag\": \"flag_niger.png\"},\"ng\": {\"code\": \"+234\",\"name\": \"Nigeria\",\"flag\": \"flag_nigeria.png\"},\"nu\": {\"code\": \"+683\",\"name\": \"Niue\",\"flag\": \"flag_niue.png\"},\"kp\": {\"code\": \"+850\",\"name\": \"Korea, Democratic People\'s Republic Of\",\"flag\": \"flag_north_korea.png\"},\"no\": {\"code\": \"+47\",\"name\": \"Norway\",\"flag\": \"flag_norway.png\"},\"om\": {\"code\": \"+968\",\"name\": \"Oman\",\"flag\": \"flag_oman.png\"},\"pk\": {\"code\": \"+92\",\"name\": \"Pakistan\",\"flag\": \"flag_pakistan.png\"},\"pw\": {\"code\": \"+680\",\"name\": \"Palau\",\"flag\": \"flag_palau.png\"},\"pa\": {\"code\": \"+507\",\"name\": \"Panama\",\"flag\": \"flag_panama.png\"},\"pg\": {\"code\": \"+675\",\"name\": \"Papua New Guinea\",\"flag\": \"flag_papua_new_guinea.png\"},\"py\": {\"code\": \"+595\",\"name\": \"Paraguay\",\"flag\": \"flag_paraguay.png\"},\"pe\": {\"code\": \"+51\",\"name\": \"Peru\",\"flag\": \"flag_peru.png\"},\"ph\": {\"code\": \"+63\",\"name\": \"Philippines\",\"flag\": \"flag_philippines.png\"},\"pn\": {\"code\": \"+870\",\"name\": \"Pitcairn\",\"flag\": \"flag_pitcairn_islands.png\"},\"pl\": {\"code\": \"+48\",\"name\": \"Poland\",\"flag\": \"flag_poland.png\"},\"pt\": {\"code\": \"+351\",\"name\": \"Portugal\",\"flag\": \"flag_portugal.png\"},\"pr\": {\"code\": \"+1\",\"name\": \"Puerto Rico\",\"flag\": \"flag_puerto_rico.png\"},\"qa\": {\"code\": \"+974\",\"name\": \"Qatar\",\"flag\": \"flag_qatar.png\"},\"ro\": {\"code\": \"+40\",\"name\": \"Romania\",\"flag\": \"flag_romania.png\"},\"ru\": {\"code\": \"+7\",\"name\": \"Russian Federation\",\"flag\": \"flag_russian_federation.png\"},\"rw\": {\"code\": \"+250\",\"name\": \"Rwanda\",\"flag\": \"flag_rwanda.png\"},\"bl\": {\"code\": \"+590\",\"name\": \"Saint BarthÈlemy\",\"flag\": \"flag_saint_barthelemy.png\"},\"ws\": {\"code\": \"+685\",\"name\": \"Samoa\",\"flag\": \"flag_samoa.png\"},\"sm\": {\"code\": \"+378\",\"name\": \"San Marino\",\"flag\": \"flag_san_marino.png\"},\"st\": {\"code\": \"+239\",\"name\": \"Sao Tome And Principe\",\"flag\": \"flag_sao_tome_and_principe.png\"},\"sa\": {\"code\": \"+966\",\"name\": \"Saudi Arabia\",\"flag\": \"flag_saudi_arabia.png\"},\"sn\": {\"code\": \"+221\",\"name\": \"Senegal\",\"flag\": \"flag_senegal.png\"},\"rs\": {\"code\": \"+381\",\"name\": \"Serbia\",\"flag\": \"flag_serbia.png\"},\"sc\": {\"code\": \"+248\",\"name\": \"Seychelles\",\"flag\": \"flag_seychelles.png\"},\"sl\": {\"code\": \"+232\",\"name\": \"Sierra Leone\",\"flag\": \"flag_sierra_leone.png\"},\"sg\": {\"code\": \"+65\",\"name\": \"Singapore\",\"flag\": \"flag_singapore.png\"},\"sk\": {\"code\": \"+421\",\"name\": \"Slovakia\",\"flag\": \"flag_slovakia.png\"},\"si\": {\"code\": \"+386\",\"name\": \"Slovenia\",\"flag\": \"flag_slovenia.png\"},\"sb\": {\"code\": \"+677\",\"name\": \"Solomon Islands\",\"flag\": \"flag_soloman_islands.png\"},\"so\": {\"code\": \"+252\",\"name\": \"Somalia\",\"flag\": \"flag_somalia.png\"},\"za\": {\"code\": \"+27\",\"name\": \"South Africa\",\"flag\": \"flag_south_africa.png\"},\"kr\": {\"code\": \"+82\",\"name\": \"Korea, Republic Of\",\"flag\": \"flag_south_korea.png\"},\"es\": {\"code\": \"+34\",\"name\": \"Spain\",\"flag\": \"flag_spain.png\"},\"lk\": {\"code\": \"+94\",\"name\": \"Sri Lanka\",\"flag\": \"flag_sri_lanka.png\"},\"sh\": {\"code\": \"+290\",\"name\": \"Saint Helena, Ascension And Tristan Da Cunha\",\"flag\": \"flag_saint_helena.png\"},\"pm\": {\"code\": \"+508\",\"name\": \"Saint Pierre And Miquelon\",\"flag\": \"flag_saint_pierre.png\"},\"sd\": {\"code\": \"+249\",\"name\": \"Sudan\",\"flag\": \"flag_sudan.png\"},\"sr\": {\"code\": \"+597\",\"name\": \"Suriname\",\"flag\": \"flag_suriname.png\"},\"sz\": {\"code\": \"+268\",\"name\": \"Swaziland\",\"flag\": \"flag_swaziland.png\"},\"se\": {\"code\": \"+46\",\"name\": \"Sweden\",\"flag\": \"flag_sweden.png\"},\"ch\": {\"code\": \"+41\",\"name\": \"Switzerland\",\"flag\": \"flag_switzerland.png\"},\"sy\": {\"code\": \"+963\",\"name\": \"Syrian Arab Republic\",\"flag\": \"flag_syria.png\"},\"tw\": {\"code\": \"+886\",\"name\": \"Taiwan, Province Of China\",\"flag\": \"flag_taiwan.png\"},\"tj\": {\"code\": \"+992\",\"name\": \"Tajikistan\",\"flag\": \"flag_tajikistan.png\"},\"tz\": {\"code\": \"+255\",\"name\": \"Tanzania, United Republic Of\",\"flag\": \"flag_tanzania.png\"},\"th\": {\"code\": \"+66\",\"name\": \"Thailand\",\"flag\": \"flag_thailand.png\"},\"tg\": {\"code\": \"+228\",\"name\": \"Togo\",\"flag\": \"flag_togo.png\"},\"tk\": {\"code\": \"+690\",\"name\": \"Tokelau\",\"flag\": \"flag_tokelau.png\"},\"to\": {\"code\": \"+676\",\"name\": \"Tonga\",\"flag\": \"flag_tonga.png\"},\"tn\": {\"code\": \"+216\",\"name\": \"Tunisia\",\"flag\": \"flag_tunisia.png\"},\"tr\": {\"code\": \"+90\",\"name\": \"Turkey\",\"flag\": \"flag_turkey.png\"},\"tm\": {\"code\": \"+993\",\"name\": \"Turkmenistan\",\"flag\": \"flag_turkmenistan.png\"},\"tv\": {\"code\": \"+688\",\"name\": \"Tuvalu\",\"flag\": \"flag_tuvalu.png\"},\"ae\": {\"code\": \"+971\",\"name\": \"United Arab Emirates\",\"flag\": \"flag_uae.png\"},\"ug\": {\"code\": \"+256\",\"name\": \"Uganda\",\"flag\": \"flag_uganda.png\"},\"gb\": {\"code\": \"+44\",\"name\": \"United Kingdom\",\"flag\": \"flag_united_kingdom.png\"},\"ua\": {\"code\": \"+380\",\"name\": \"Ukraine\",\"flag\": \"flag_ukraine.png\"},\"uy\": {\"code\": \"+598\",\"name\": \"Uruguay\",\"flag\": \"flag_uruguay.png\"},\"us\": {\"code\": \"+1\",\"name\": \"United States\",\"flag\": \"flag_united_states_of_america.png\"},\"uz\": {\"code\": \"+998\",\"name\": \"Uzbekistan\",\"flag\": \"flag_uzbekistan.png\"},\"vu\": {\"code\": \"+678\",\"name\": \"Vanuatu\",\"flag\": \"flag_vanuatu.png\"},\"va\": {\"code\": \"+39\",\"name\": \"Holy See (vatican City State)\",\"flag\": \"flag_vatican_city.png\"},\"ve\": {\"code\": \"+58\",\"name\": \"Venezuela, Bolivarian Republic Of\",\"flag\": \"flag_venezuela.png\"},\"vn\": {\"code\": \"+84\",\"name\": \"Viet Nam\",\"flag\": \"flag_vietnam.png\"},\"wf\": {\"code\": \"+681\",\"name\": \"Wallis And Futuna\",\"flag\": \"flag_wallis_and_futuna.png\"},\"ye\": {\"code\": \"+967\",\"name\": \"Yemen\",\"flag\": \"flag_yemen.png\"},\"zm\": {\"code\": \"+260\",\"name\": \"Zambia\",\"flag\": \"flag_zambia.png\"},\"zw\": {\"code\": \"+263\",\"name\": \"Zimbabwe\",\"flag\": \"flag_zimbabwe.png\"},\"ai\": {\"code\": \"+1\",\"name\": \"Anguilla\",\"flag\": \"flag_anguilla.png\"},\"ag\": {\"code\": \"+1\",\"name\": \"Antigua & Barbuda\",\"flag\": \"flag_antigua_and_barbuda.png\"},\"bs\": {\"code\": \"+1\",\"name\": \"Bahamas\",\"flag\": \"flag_bahamas.png\"},\"bb\": {\"code\": \"+1\",\"name\": \"Barbados\",\"flag\": \"flag_barbados.png\"},\"bm\": {\"code\": \"+1\",\"name\": \"Bermuda\",\"flag\": \"flag_bermuda.png\"},\"vg\": {\"code\": \"+1\",\"name\": \"British Virgin Islands\",\"flag\": \"flag_british_virgin_islands.png\"},\"dm\": {\"code\": \"+1\",\"name\": \"Dominica\",\"flag\": \"flag_dominica.png\"},\"do\": {\"code\": \"+1\",\"name\": \"Dominican republic\",\"flag\": \"flag_dominican_republic.png\"},\"gd\": {\"code\": \"+1\",\"name\": \"Grenada\",\"flag\": \"flag_grenada.png\"},\"jm\": {\"code\": \"+1\",\"name\": \"Jamaica\",\"flag\": \"flag_jamaica.png\"},\"ms\": {\"code\": \"+1\",\"name\": \"Montserrat\",\"flag\": \"flag_montserrat.png\"},\"kn\": {\"code\": \"+1\",\"name\": \"St Kitts & Nevis\",\"flag\": \"flag_saint_kitts_and_nevis.png\"},\"lc\": {\"code\": \"+1\",\"name\": \"St Lucia\",\"flag\": \"flag_saint_lucia.png\"},\"vc\": {\"code\": \"+1\",\"name\": \"St Vincent & The Grenadines\",\"flag\": \"flag_saint_vicent_and_the_grenadines.png\"},\"tt\": {\"code\": \"+1\",\"name\": \"Trinidad & Tobago\",\"flag\": \"flag_trinidad_and_tobago.png\"},\"tc\": {\"code\": \"+1\",\"name\": \"Turks & Caicos Islands\",\"flag\": \"flag_turks_and_caicos_islands.png\"},\"vi\": {\"code\": \"+1\",\"name\": \"US Virgin Islands\",\"flag\": \"flag_us_virgin_islands.png\"}}"
//Insentive Strings
#define isfcsignup @"isfcsignup"
#define fcsignup @"fcsignup"
#define isfcjoinbanter @"isfcjoinbanter"
#define fcjoinbanter @"fcjoinbanter"
#define fcbanterth @"fcbanterth"
#define isfcactivity @"isfcactivity"
#define fcactivity @"fcactivity"
#define fcactivityth @"fcactivityth"
#define isgroupchat @"isgroupchat"
#define isbanterchat @"isbanterchat"
#define isnewfu @"isnewfu"
#define isfulike @"isfulike"
#define isfucomment @"isfucomment"
#define isnewslike @"isnewslike"
#define isnewscomment @"isnewscomment"
#define fcbronzeth @"fcbronzeth"
#define  fcsilverth @"fcsilverth"
#define fcgoldth @"fcgoldth"
#define fcplatinumth @"fcplatinumth"
#define fcdiamondth @"fcdiamondth"
#define fcbonusthb @"fcbonusthb"
#define fcbonusths @"fcbonusths"
#define fcbonusthg @"fcbonusthg"
#define fcbonusthp @"fcbonusthp"
#define fcbonusthd @"fcbonusthd"
#define fcbronzeimage @"fcbronzeimage"
#define fcsilverimage @"fcsilverimage"
#define fcgoldimage @"fcgoldimage"
#define fcplatinumimage @"fcplatinumimage"
#define fcdiamondimage @"fcdiamondimage"
#define fcbronzeimageh @"fcbronzeimageh"
#define fcsilverimageh @"fcsilverimageh"
#define fcgoldimageh @"fcgoldimageh"
#define fcplatinumimageh @"fcplatinumimageh"
#define fcdiamondimageh @"fcdiamondimageh"
#define fcredeemth @"fcredeemth"
#define fcredeemamt @"fcredeemamt"
#define fcredeemcurrency @"fcredeemcurrency"
#define fctotalcoin @"fctotalcoin"
#define fcavailablecoin @"fcavailablecoin"
#define fccurrentlevel @"fccurrentlevel"
#define fcactivitycount @"fcactivitycount"
#define ThisIsGroup @"isgroupchat"
#define ThisIsBanter @"isbanterchat"
#define ThisIsTeambr @"isteambrchat"
#define ThisIsupdateLike @"isfulike"
#define ThisIsupdateComment @"isfucomment"
#define ThisIsnewUpdate @"isnewfu"
#define ThisIsNewsLike @"isnewslike"
#define ThisIsNewsComment @"isnewscomment"
#define isfcreferral @"isfcreferral"
#define fcreferral @"fcreferral"
#define isstream @"isstream"
#define isfcfanstory @"isfcfanstory"
#define fcfanstory @"fcfanstory"
#define fcfanstoryth @"fcfanstoryth"
#define islogging @"islogging"
#define DbronzeLink @"http://api.footballfan.mobi/ffapi/levels/bronze_d.png"
#define DsilverLink @"http://api.footballfan.mobi/ffapi/levels/silver_d.png"
#define DgoldLink @"http://api.footballfan.mobi/ffapi/levels/gold_d.png"
#define DplatinumLink @"http://api.footballfan.mobi/ffapi/levels/platinum_d.png"
#define DdiamondLink @"http://api.footballfan.mobi/ffapi/levels/diamond_d.png"
// message strings
#define Emptyuser "Username cannot be empty."
#define Emptypassword "Password cannot be empty."
#define Emptyname "Name cannot be empty."
#define Emptyemail "Email address cannot be empty."
#define Emptymobile "Mobile number cannot be empty."
#define InvalidAge "Fans under 13 years of age are not eligible."
#define Invalidemail "Invalid email address."



#endif /* FootballFanHeader_h */
