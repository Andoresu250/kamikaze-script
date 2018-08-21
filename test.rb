require 'net/http'
require 'date'
require 'json/ext'
require 'em-http-request'

plates = ['AXC064', 'DVM752', 'NRR518', 'HBD951', 'PCO119', 'XDD671', 'APR386', 'OEE860', 'ZLC586', 'LWG175', 'PLV507', 'KJG650', 
'DUL484', 'FDS924', 'ZSZ108', 'ZDQ991', 'PCB305', 'HFM822', 'CZA227', 'MOL285', 'ZSO294', 'VAW529', 'XOE237', 'KEI209', 'JWB213', 
'BJV815', 'XSX933', 'FKA570', 'IGF286', 'JEC946', 'WVQ288', 'XHW546', 'UFI257', 'MTB053', 'LXH193', 'QOT412', 'LNX377', 'HJP583', 
'LHS318', 'XDS171', 'TJR167', 'BFZ241', 'ZOD113', 'UUR187', 'EPG981', 'LNY448', 'FWZ139', 'QNM200', 'YYR991', 'EXW936', 'IMV822', 
'TWI879', 'AKY090', 'BEB909', 'HHH099', 'GHV871', 'JNL026', 'PUV194', 'WMG971', 'AEG636', 'JQF777', 'IOM562', 'OBE045', 'PLI155', 
'ZWI991', 'IKK752', 'GIV374', 'YDO168', 'WLN818', 'LYI001', 'PHA248', 'WGT122', 'LKZ550', 'NNA845', 'NUV835', 'OTR349', 'HCY516', 
'XKB436', 'JKK525', 'EKL779', 'LAR295', 'GVJ266', 'FAA080', 'WPF786', 'BRQ053', 'XEA332', 'KRP035', 'QDJ635', 'FVG377', 'OXB097', 
'FJO863', 'NYT024', 'GYM730', 'ZEB349', 'BNQ656', 'DWW250', 'LVW254', 'IPZ364', 'GYD230', 'IGD126', 'UPB404', 'YBL696', 'MNA071', 
'EPE506', 'WUG240', 'BGO734', 'VXE035', 'MQA675', 'INL470', 'QKP483', 'XCI759', 'AYI990', 'BTO935', 'TFO951', 'RWO296', 'UDE937', 
'CFH185', 'IKG178', 'VHR851', 'QDN052', 'SWR828', 'OUS963', 'FVE160', 'OXN222', 'JGD354', 'KSY561', 'HTL610', 'PUP913', 'QCI492', 
'JVC148', 'OUV711', 'FSZ963', 'NXN003', 'ALM065', 'KRT832', 'LEL074', 'SFS576', 'OEQ262', 'MWK319', 'DSI736', 'FSK624', 'SWX194', 
'ODM787', 'PVJ075', 'LOL227', 'QWG949', 'ASY220', 'XAI485', 'PJC492', 'BKI763', 'EKS849', 'UPU118', 'RFM981', 'SRZ445', 'WBZ447', 
'KNI168', 'LMX162', 'TKI027', 'NPU878', 'YDM954', 'CYS378', 'VHL613', 'WRO283', 'TXH983', 'GFC425', 'IBX087', 'HLZ676', 'PDS849', 
'WDC157', 'JJI148', 'WVW081', 'GMX224', 'CON312', 'MDW224', 'VUE113', 'BYC420', 'MMC850', 'CFZ372', 'JQV190', 'TYK721', 'HAG814', 
'VMH472', 'LYB340', 'HDD437', 'DET952', 'VGM964', 'CHZ509', 'VZR992', 'ZIC183', 'MOT033', 'EXK343', 'XDY470', 'DQP912', 'IYS706', 
'ZUH411', 'OAP375', 'FDZ917', 'LWP632', 'HIH071', 'FUI238', 'NWG521', 'CXQ480', 'GCL024', 'MRA383', 'KHK149', 'LFZ454', 'ZVH639', 
'OVR536', 'BHF649', 'JQT938', 'TQG882', 'YRJ084', 'CPU061', 'SOT269', 'WMY741', 'JAK044', 'DRH676', 'DQV685', 'GXO650', 'PGI843', 
'ASK472', 'SYG824', 'YLW880', 'RCN026', 'RPO179', 'WAI410', 'EKT822', 'VOG269', 'KGA923', 'WBJ042', 'PPG914', 'BOD942', 'JLM000', 
'VLG998', 'STH969', 'UMH826', 'WPC318', 'OEW699', 'THF120', 'YGH011', 'OKK440', 'LUC282', 'QDG174', 'PZX796', 'ZJB677', 'EWV186',
 'OTM449', 'MWK148', 'FHH402', 'LNT005', 'JPO289', 'ZOJ777', 'CIO039', 'YML595', 'QHY178', 'JPP658', 'ZUY732', 'OYT486', 'GSX614', 
 'YTP436', 'YEP503', 'GMM227', 'YWR344', 'ONN996', 'BVI417', 'KUJ682', 'UOM747', 'NVO336', 'JYG562', 'RJR422', 'ZRP689', 'KDS375', 
 'GSH014', 'TSL866', 'CJB191', 'VJJ870', 'LBI219', 'VNS795', 'MIZ924', 'PKB270', 'XSR653', 'CWN295', 'IXX615', 'GBE182', 'QLB384', 
 'GXD079', 'KBC164', 'JVE939', 'SKW361', 'LZS078', 'DZN697', 'FPL936', 'COC845', 'ITN266', 'BZH026', 'XNG784', 'BGA314', 'EBG873', 
 'UJT298', 'VRY064', 'UTU112', 'EJA319', 'POG569', 'FZM734', 'GQD647', 'JPN776', 'YTW180', 'HBW408', 'YLN179', 'ZMC026', 'MJI624', 
 'VOY946', 'XIL596', 'BXH946', 'RMY266', 'ZDC209', 'DYD754', 'MIP024', 'UFF485', 'VZE755', 'SEY692', 'JSW590', 'XJG711', 'ZFW306', 
 'TFF107', 'XPC171', 'FIU566', 'JHB927', 'XMR175', 'XTC790', 'USG515', 'LLT318', 'PFF427', 'BKE564', 'ZXJ119', 'XCJ328', 'SVU163', 
 'HJV269', 'VWB817', 'NHN828', 'HSX672', 'ZPD849', 'FCV700', 'LJD113', 'QTK592', 'QJS842', 'OGI053', 'NJU831', 'XMY970', 'SNW683', 
 'YSK119', 'XBR984', 'ZLC888', 'LNV695', 'JQQ662', 'OMG848', 'EAL845', 'OMB733', 'NOV986', 'XIV498', 'TXK868', 'JGR846', 'NLZ645', 
 'OZM931', 'FGW591', 'JBC348', 'PLR823', 'LRH827', 'RJS643', 'PCX695', 'CDI107', 'OJH348', 'FYU452', 'CIK849', 'XFI672', 'WNA521', 'BIX312', 'LZF241', 'HWY857', 'GTS217', 'LWC590', 'QIZ491', 'MPY314', 'FPQ497', 'HST818', 'SMV650', 'AYO488', 'NCH364', 'IGD275', 'MLN510', 'FBG224', 'WZW164', 'YJB510', 'ZFT104', 'HCR500', 'SVN358', 'CWS135', 'UDJ619', 'FDD975', 'HHM077', 'GYF795', 'KFV199', 'AYE993', 'VZQ251', 'LQD963', 'NMN960', 'SLD557', 'SDS300', 'APM435', 'GBR973', 'HED957', 'EBV034', 'HNK584', 'WLF898', 'PKR694', 'LUA398', 'XLM136', 'HLK079', 'ZPE014', 'INR116', 'GKM012', 'KZB633', 'LDZ020', 'GQS245', 'SMO695', 'FIX683', 'JJY240', 'KVN067', 'HZW675', 'JWQ422', 'ASS179', 'LNJ131', 'GWZ604', 'EBR636', 'XRU552', 'VSA859', 'LZN487', 'ULH291', 'SMI341', 'NCE541', 'RGZ645', 'DXL221', 'HVJ952', 'VPA227', 'YWZ870', 'GTS232', 'VCW402', 'WBY520', 'WWS525', 'WHZ213', 'ZZT428', 'VVA138', 'OFE191', 'KWE069', 'EDZ392', 'RVG682', 'QIO179', 'FCR287', 'QAJ034', 'IHF045', 'NGI636', 'PKM380', 'DAD053', 'FXF387', 'IUL170', 'XLU594', 'APB112', 'ZMV863', 'LKH919', 'NFV358', 'MSJ853', 'QST750', 'VAH450', 'OEI789', 'VXR697', 'WKX222', 'BJQ294', 'WNK424', 'GXQ376', 'XBB874', 'LFL258', 'QHE429', 'YTM435', 'RAJ713', 'PYX147', 'ARM744', 'DMU035', 'TDQ460', 'WXQ167', 'EJU721', 'FUL658', 'JEU318', 'TSP150', 'BON485', 'QHS754', 'MLG453', 'LWC711', 'LIY603', 'EVG004', 'UQU387', 'OVE015', 'IYU253', 'PDH508', 'GUO025', 'IWF347', 'UEX281', 'EWA673', 'OJG682', 'KEM663', 'ZMD752', 'YRL162', 'JXS105', 'ZEP139', 'UBH323', 'EXZ459', 'PBO906', 'PVD405', 'KIK100', 'WOP565', 'ZGL674', 'OFY452', 'IRW073', 'XQM455', 'STM203', 'OZA042', 'JDR711', 'UYW278', 'RRW540', 'HZJ847', 'EZS830', 'IKY143', 'BOL140', 'LPI825', 'ISS468', 'LER216', 'WVO157', 'TQX595', 'LUM580', 'VNA813', 'QOC925', 'JYM242', 'IBL684', 'CBT476', 'EWZ796', 'KGO105', 'DLM654', 'CDN864', 'KAB173', 'AJD536', 'IZV519', 'PTH676', 'HZU532', 'COM486', 'VOW554', 'SVU039', 'NMN613', 'WFS739', 'WKD631', 'OJR539', 'KMB292', 'RTX623', 'REP314', 'UHE105', 'TNN604', 'IUU372', 'VVQ588', 'OLX219', 'TRM327', 'XAP007', 'HHK068', 'FZF909', 'CZN888', 'ZGC939', 'YVH632', 'ZDO769', 'IOF130', 'QWX822', 'QYN761', 'BXQ927', 'SQS577', 'RNR538', 'XGB550', 'AFG576', 'GVM972', 'XTY643', 'LIG808', 'KBQ461', 'USU371', 'ZFO921', 'MGY471', 'XSH335', 'YIR243', 'MUM856', 'LPX492', 'JME592', 'JPE993', 'RYI716', 'ZOA327', 'BAA226', 'IMQ019', 'CYH158', 'RRR631', 'EXO249', 'GCX302', 'NOM414', 'XTE597', 'FRM332', 'ODQ510', 'ZIJ505', 'JRZ687', 'EVK541', 'DIP489', 'UNI020', 'HYM246', 'SPT184', 'ZOG945', 'FVD790', 'FNX317', 'LAH141', 'ZRK230', 'RDR380', 'GFI384', 'ZGN232', 'WXF814', 'HZS805', 'JBN954', 'IME202', 'PFW721', 'PVN007', 'KMY054', 'DSB117', 'GIL984', 'FGU441', 'YAZ241', 'HEN102', 'USK456', 'NAX285', 'OFO579', 'NCD551', 'HXE675', 'MOC463', 'WJQ997', 'IFI944', 'XWY064', 'WLB228', 'LSH845', 'VTD442', 'GID119', 'UNF488', 'QLJ472', 'KUR526', 'VCZ631', 'OBB041', 'DIS836', 'VMJ918', 'ROG553', 'ZJO313', 'ICH258', 'TSA961', 'EWR254', 'JTD427', 'GWK163', 'AHY494', 'AQR446', 'XLD805', 'WFH328', 'ZKA354', 'AUJ766', 'WBX667', 'GWA770', 'YME529', 'QBL375', 'YPP366', 'SFS976', 'RIK423', 'SQZ343', 'JQQ071', 'WBT643', 'FFD211', 'CFY515', 'NAJ071', 'KBV374', 'OJI291', 'AHN451', 'KWQ651', 'NAP613', 'WPE203', 'AKA337', 'ZQU782', 'QQG982', 'VUI546', 'DDC355', 'ZFW632', 'ZVD182', 'JVK759', 'LFZ594', 'HQW399', 'LHC289', 'LEG464', 'XPD059', 'AJJ001', 'EEJ408', 'FBK129', 'MXM368', 'ZLF716', 'NZB428', 'CTD404', 'IUD953', 'QGS867', 'GOQ787', 'CJN390', 'UOJ784', 'TVU798', 'RSB093', 'BRK757', 'CRK021', 'WZA232', 'TPG691', 'RPT405', 'RJO531', 'ZHI997', 'UBV012', 'AXD585', 'VFS730', 'FOE432', 'YFG254', 'PNO984', 'AMD389', 'YPK233', 'PLC684', 'PCN227', 'IRQ081', 'IVU372', 'NIA408', 'ZQQ593', 'NKB850', 'NSP344', 'BWU485', 'ENC950', 'XQC511', 'WVO391', 'VHK801', 'HAV010', 'VQW403', 'BPZ622', 'OBH677', 'XQU511', 'UBA264', 'FWZ294', 'RIX613', 'TGB289', 'LZW453', 'EZK664', 'IOA615', 'SLT330', 'QTB891', 'EOE676', 'LYR303', 'RHT825', 'VPI563', 'QNS955', 'JOP902', 'DRP041', 'FYS130', 'HNG026', 'KFV986', 'LFF335', 'CRV987', 'FJM113', 'OKW062', 'XDB636', 'HVJ010', 'EBO513', 'ULM004', 'GQN826', 'HDS501', 'AJK037', 'EAL400', 'XWC353', 'DFH200', 'VRJ498', 'XPI704', 'LQO510', 'QRN992', 'FOV249', 'YDH008', 'AVP883', 'DIY442', 'CWK409', 'KUY110', 'VXR356', 'PJF929', 'XZT603', 'YEE845', 'QTW446', 'GLK270', 'DRU932', 'WDC815', 'GRH654', 'ACC895', 'SDQ279', 'KLI000', 'SAG476', 'GEH743', 'DEI169', 'ZHJ823', 'BMS603', 'YLD408', 'AXK170', 'SMO410', 'BJO098', 'VGD101', 'ZJG444', 'SBK075', 'ZKE524', 'YKR128', 'WTH633', 'ACX282', 'DMH152', 'AQB108', 'BJR963', 'ENE494', 'DHU390', 'GTV105', 'DFS418', 'TZY605', 'OXB515', 'NIO915', 'WKQ970', 'UDG126', 'TNN164', 'JOZ869', 'KHM756', 'MZC131', 'CRL980', 'NWX128', 'MPH500', 'COV345', 'IBU929', 'TWU474', 'RGJ512', 'PTU752', 'MLV815', 'ZEA375', 'DGS317', 'OXY219', 'JSG816', 'CWY933', 'MYN181', 'IIA626', 'KEI584', 'AXS401', 'DGC647', 'POX116', 'NUW805', 'ZHU368', 'UYQ366', 'NHS229', 'AJZ634', 'GSI416', 'UMP929', 'DPJ701', 'NQB970', 'OFU542', 'AEM795', 'ULF132', 'YBF042', 'OVS466', 'IMS663', 'FOL520', 'ODW493', 'RTC529', 'PWS045', 'DFV499', 'GFD514', 'MLN353', 'GBN348', 'ORN641', 'OTS552', 'VOX474', 'MOP195', 'XYG069', 'IEW147', 'PAA721', 'ABU404', 'XVO966', 'NDR806', 'PPZ594', 'XZA402', 'MTU548', 'ZZL572', 'PTS629', 'ESM570', 'JLV192', 'PJM047', 'JNK460', 'DIV888', 'KUB082', 'OYV285', 'IPP591', 'VNU524', 'TNX062', 'DIV725', 'UCQ812', 'XQU309', 'LJI051', 'UZD872', 'QTF310', 'URC072', 'SPU738', 'OAF362', 'NEJ652', 'RXU065', 'IJA336', 'DFO049', 'LSD967', 'XYG921', 'XFW061', 'AHP685', 'ZCE966', 'YKC263', 'RVR535', 'TWH505', 'NJM167', 'CPC895', 'PKC221', 'QOF563', 'MNN361', 'TPS678', 'JXI318', 'BRY900', 'ZDN109', 'YRW316', 'KLX950', 'OOX446', 'SII145', 'LVK438', 'NRK761', 'ZSF745', 'AVC339', 'SHI499', 'RSZ450', 'OMI391', 'MAR090', 'WVU418', 'NUK087', 'BQT378', 'HOJ149', 'UOX854', 'SXE562', 'UPS055', 'CML626', 'PBW888', 'SVC052', 'AWM689', 'NWD067', 'UEQ254', 'YQO091', 'WHI445', 'OXP069', 'ANA484', 'UXS178', 'BUO421', 'VMI290', 'ZKH419', 'WEV685', 'UML069', 'RBD875', 'NGM290', 'PGM899', 'PHY629', 'TNU623', 'WPE195', 'PHO580', 'XPA301', 'NNA528', 'OVR796', 'LII842', 'PTD503', 'DHX533', 'IXM448', 'DWR051', 'NPM059', 'ECY937', 'AKT482', 'ETB494', 'KEQ496', 'SED036', 'UND943', 'AIA358', 'UQK796', 'OOD880', 'EOL286', 'CMV829', 'IUU664', 'CHS189', 'ACW608', 'BCB951', 'NTN406', 'QYA542', 'GEI419']

def generate_plate
    Array.new(3) { CHARSET.sample }.join + Array.new(3) { NUMBER_CHARSET.sample }.join
end

def move_cars(array)

    array.each_with_index do |a, index|
        array[index][:location][:lat] = "#{10.9}#{(Random.new.rand * 100000).to_i}".to_f
        array[index][:location][:lng] = "#{-74.8}#{(Random.new.rand * 100000).to_i}".to_f
        array[index][:location][:rotation] = Random.new.rand(0..360)
    end

    return array

end

def generate_array(n)
    array = []
    (1..n).each do |i|
        plate = generate_plate

        lat = "#{10.9}#{(Random.new.rand * 100000).to_i}"
        lng = "#{-74.8}#{(Random.new.rand * 100000).to_i}"        
    
        body = {
            driver: {
                id: i,
                cc: i
            },
            car: {
                id: i,
                plate: plate
            },
            location: {
                lat: lat,
                lng: lng,
                rotation: Random.new.rand(0..360),
                alt: 0
            },
            state: 1,
            date: DateTime.now.to_s,
            transportCompanyId: 1
        }

        array << body        
    end
    return array
end

def generate_objects(plates)
    array = []
    plates.each_with_index do |plate, i|
        

        lat = "#{10.9}#{(Random.new.rand * 100000).to_i}".to_f
        lng = "#{-74.8}#{(Random.new.rand * 100000).to_i}".to_f
    
        body = {
            driver: {
                id: i + 1,
                cc: i + 1
            },
            car: {
                id: i + 1,
                plate: plate
            },
            location: {
                lat: lat,
                lng: lng,
                rotation: Random.new.rand(0..360),
                alt: 0
            },
            state: 1,
            date: DateTime.now.to_s,
            transportCompanyId: 1
        }

        array << body        
    end
    return array
end

def multi_send(array)
    sw = true
    while sw do
        EventMachine.run do
            multi = EventMachine::MultiRequest.new

            array.each_with_index do |body, index|
                puts "json #{body.to_json}"
                multi.add(index + 1, EventMachine::HttpRequest.new('http://206.81.13.83:82/v1/location_records').post(:head => {"Content-Type" => "application/json"}, :body => body.to_json))
            end

            multi.callback do   
                puts "success: #{multi.responses[:callback].keys.size}"
                puts "failed: #{multi.responses[:errback].keys.size}"
                
                if multi.responses[:errback].keys.empty?                
                    sleep(5)                    
                    array = move_cars(array)
                else
                    puts multi.responses[:errback].keys
                    # sw = false             
                end
                
                EventMachine.stop
            end
        end
    end
end


CHARSET = Array('A'..'Z')
NUMBER_CHARSET = Array('0'..'9')

multi_send(generate_objects(plates.take(500)))


puts "end"




  