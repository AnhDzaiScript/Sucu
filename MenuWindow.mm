


//#include <JRMemory/MemScan.h>

#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#import <substrate.h>


//ramdis
#include <sys/utsname.h>
#include <thread>
#include <mach/mach.h>
#include <sys/sysctl.h>

//ip
#import <objc/runtime.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

//viewSFRi
@import SafariServices;

#import "View/MenuWindow.h"
#import "View/OverlayView.h"
#import "View/imgui/Icon.h"
#import "View/mahoa.h"
#import "View/ImNotHacker.h"
#import "View/MBProgressHUD.h"
#import "View/Reachability.h"
#import "View/ip.h"
#import "View/FTIndicator.h"
#import "View/iconbase.h"



#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^


@implementation MenuWindow



UIWindow *Esp;

ImNotHacker *HideEsp;
static bool hidehacker = false;

NSDateFormatter *ttime;
UIDevice *myDevice;



//show ip

inline NSString *GetIPAddress()
{
        NSString *result = nil;
        struct ifaddrs *interfaces;
        char str[INET_ADDRSTRLEN];
        if (getifaddrs(&interfaces))
                return nil;
        struct ifaddrs *test_addr = interfaces;
        while (test_addr) {
                if(test_addr->ifa_addr->sa_family == AF_INET) {
                        if (strcmp(test_addr->ifa_name, "en0") == 0) {
                                inet_ntop(AF_INET, &((struct sockaddr_in *)test_addr->ifa_addr)->sin_addr, str, INET_ADDRSTRLEN);
                                result = [NSString stringWithUTF8String:str];
                                break;
                        }
                }
                test_addr = test_addr->ifa_next;
        }
        freeifaddrs(interfaces);
        return result;
}

inline NSString *WiFiInfoString()
{
	NSString *network = [[objc_getClass("SBWiFiManager") sharedInstance] currentNetworkName] ?: @"Not connected";
	NSString *ip = GetIPAddress() ?: @"";


	return [NSString stringWithFormat:@"IP: %@" ,ip];


}

////end////



INI* config;


const char *optionItemName[] = {ICON_FA_HOME" Home", ICON_FA_ROCKET" Esp", ICON_FA_CUBES" Items", ICON_FA_CROSSHAIRS" Aimbot", 
ICON_FA_EDIT" Memory",
ICON_FA_COG" Setting"};
int optionItemCurrent = 0;


int aimbotIntensity; 
const char *aimbotIntensityText[] = {"So Low","Low", "Normal", "High", "So High"};
//Phần văn bản tự nhắm
const char *aimbotModeText[] = {"Open Scope", "Fire", "Open Scope & Fire", "Auto", "Not Aim"};
//Phần văn bản tự nhắm
const char *aimbotPartsText[] = {"(Auto) Head", "(Auto) Body", "(Auto) Head & Body", "Default Head", "Default Body"};

OverlayView *overlayView;

- (instancetype)initWithFrame:(ModuleControl*)control {
    self.moduleControl = control;
  
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
   
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"BoniOSVN.ini"];
    
    if(![fileManager fileExistsAtPath:filePath]){
       
        [fileManager createFileAtPath:filePath contents:[NSData data] attributes:nil];
    }
    
    config = ini_load((char*)filePath.UTF8String);
    
    return [super init];
}

-(void)setOverlayView:(OverlayView*)ov{
    overlayView = ov;
  
    [self readIniConfig];




}






-(void)delConfig{

 [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {

    NSString *filepath9= [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/BoniOSVN.ini"];
    NSFileManager *fileManager9= [NSFileManager defaultManager];
    [fileManager9 removeItemAtPath:filepath9 error:nil];
            }];



timer(1){


    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progress.mode = MBProgressHUDModeText;
    progress.label.numberOfLines = 10;
    //progress.label.textColor = [UIColor redColor];
    progress.label.text = NSSENCRYPT("Delete Config success!! Game will crash after 3s ...");
    [self performSelector:@selector(closeAlert) withObject:nil afterDelay:1.5];

//exit

   [self out];


});




}







-(void)closeAlert{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

-(void)out{
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
exit(0);
});
}











-(void)drawMenuWindow {


//Hide
    ImNotHacker *NotHacker = [[ImNotHacker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [NotHacker setUserInteractionEnabled:NO];
    [[[[UIApplication sharedApplication] windows]lastObject] addSubview:NotHacker];
               
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{


        HideEsp = [[ImNotHacker alloc] initWithFrame:CGRectMake(0, 0, 1280, 700)];
        HideEsp.userInteractionEnabled = NO;
        Esp = [UIApplication sharedApplication].keyWindow;
        [Esp addSubview:HideEsp];


    //Đặt kích thước của cửa sổ tiếp theo
    ImGuiIO & io = ImGui::GetIO();

ImFont* font = ImGui::GetFont();
    font->Scale = 28.f / font->FontSize;
            

    ImGui::SetNextWindowSize({1280, 700}, ImGuiCond_FirstUseEver);

    ImGui::SetNextWindowPos(ImVec2(io.DisplaySize.x * 0.5f, io.DisplaySize.y * 0.5f), 0, ImVec2(0.5f, 0.5f));  


});




static int a = 20;//bo viền menu
static int b = 8;//bo tròn checkbox, button

ImGui::GetStyle().WindowRounding = a;
ImGui::GetStyle().FrameRounding = b;



struct utsname systemInfo;
uname(&systemInfo);

NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleNameKey];
  NSString *appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleIdentifierKey];

//name device
   NSString *deviceName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

char* bonios = (char*) [[NSString stringWithFormat:NSSENCRYPT("BONIOSHAX.VN Ver: %@") ,ver] cStringUsingEncoding:NSUTF8StringEncoding];


//, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize
     if (ImGui::Begin(bonios,&self.moduleControl->menuStatus)) {
        ImGuiContext& g = *GImGui;
        if(g.NavWindow == NULL){
            self.moduleControl->menuStatus = !self.moduleControl->menuStatus;
        }
        // Đặt chiều rộng của điều khiển tiếp theo
        ImGui::BeginChild("##optionLayout", {calcTextSize("Bố cục tùy chọn") + 120.0f, 0}, false, ImGuiWindowFlags_None);
        for (int i = 0; i < 6; ++i) {
            if (optionItemCurrent != i) {
                ImGui::PushStyleColor(ImGuiCol_Button, ImColor(0, 0, 0, 0).Value);
                ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImColor(0, 0, 0, 0).Value);
                ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImColor(0, 0, 0, 0).Value);
            }
            bool isClick = ImGui::Button(optionItemName[i]);
            if (optionItemCurrent != i) {
                ImGui::PopStyleColor(3);
            }
            if (isClick) {
                optionItemCurrent = i;
            }
        }
        ImGui::EndChild();
    
        ImGui::SameLine();
        ImGui::BeginChild("##surfaceLayout", {0, 0}, false, ImGuiWindowFlags_None);
        switch (optionItemCurrent) {
            case 0:
                [self showSystemInfo];
                break;
            case 1:
                [self showPlayerControl];
                break;
            case 2:
                [self showMaterialControl];
                break;
            case 3:
                [self showAimbotControl];
                break;
            case 4:
                [self showMemory];
                break;
            case 5:
                [self showSetting];
                break;
        }
        ImGui::EndChild();
        
        
        ImGui::End();
    }
}




-(void)showSetting{

ImGui::BeginChild("##2", ImVec2(800, 50), true, 0);
            {


myDevice = [UIDevice currentDevice];
[myDevice setBatteryMonitoringEnabled:YES];
double batLeft = (float)[myDevice batteryLevel] * 100;

ttime = [[NSDateFormatter alloc] init];
[ttime setDateFormat:@"EEEE,dd/MM/yyyy | HH:mm:ss"];


NSString *date = [NSString stringWithFormat:NSSENCRYPT("%@"),[ttime stringFromDate:[NSDate date]]];

char* showdate = (char*) [date cStringUsingEncoding:NSUTF8StringEncoding];

ImGui::TextColored(ImColor(255, 255, 255, 255).Value, ICON_FA_CALENDAR" Today: %s  (Battery: %0.0f)",showdate ,batLeft);

    

        }
        ImGui::EndChild();


ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Config Menu");


   if (ImGui::Button("Save Config")) {
        [self readIniConfig];


}

   ImGui::SameLine();
   if (ImGui::Button("Delete Config")) {
      [self delConfig];
}

   ImGui::SameLine();
   if (ImGui::Button("Open File Config")) {

//tìm kiếm file
NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"BoniOSVN.ini"];

//lấy giá trị file
NSURL *sFilePathURL = [NSURL fileURLWithPath:filePath];

//chia sẻ trong
UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[sFilePathURL] applicationActivities:nil];


[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityViewController animated:YES completion:^{}];


}



   if (ImGui::Button("Open Web")) {
     
//NSArray *activityItems = @[self.imageView.image]; UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil]; [self presentViewController:activityController animated:YES completion:nil];

NSString *urlweb = NSSENCRYPT("https://bonioshax.vn");

NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlweb]];

//chế độ duyệt web
SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL];

//chế độ đọc
//SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL entersReaderIfAvailable:YES];


[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:sfvc animated:YES completion:^{}];







}




auto &colors = ImGui::GetStyle().Colors;

static int blur = 1;

    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Blur theme");
    if (ImGui::RadioButton("100%",&blur , 1)) {
    colors[ImGuiCol_WindowBg] = ImVec4{0.1f, 0.1f, 0.13f, 1.0f};//màu nền menu
        //style->Alpha = 1.0f;

configManager::putInteger(config,"mainSwitch", "Blur Theme",blur);

    }
    ImGui::SameLine();
    if (ImGui::RadioButton("80%",&blur , 2)) {
        //style->Alpha = .9f;
   colors[ImGuiCol_WindowBg] = ImVec4{0.1f, 0.1f, 0.13f, .9f};//màu nền menu

configManager::putInteger(config,"mainSwitch", "Blur Theme",blur);


    }
    ImGui::SameLine();
    if (ImGui::RadioButton("60%",&blur , 3)) {
        //style->Alpha = .7f;
   colors[ImGuiCol_WindowBg] = ImVec4{0.1f, 0.1f, 0.13f, .6f};//màu nền menu

configManager::putInteger(config,"mainSwitch", "Blur Theme",blur);

    }
    
    ImGui::SameLine();
    if (ImGui::RadioButton("40%",&blur , 4)) {
        //style->Alpha = .6f;
    colors[ImGuiCol_WindowBg] = ImVec4{0.1f, 0.1f, 0.13f, .4f};//màu nền menu

configManager::putInteger(config,"mainSwitch", "Blur Theme",blur);

    }


// Show setting Imgui
ImGui::ShowStyleEditor();



}





-(void)showMemory {

ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Memory Function:");




ImGui::TextColored(ImColor(255, 255, 255), "(%s)", "Lưu ý: Để mod hiệu ứng băng bắn địch, bạn cần cầm súng trên tay.\n Sau đó hãy bật Mod (Vì là hiệu ứng beta nên bạn không nên mở scope khi bắn");



if (ImGui::Button(" Mod Effect ice kill "))
{



}




ImGui::TextColored(ImColor(255, 255, 255), "(%s)", "Mod hiệu ứng skin súng M416 băng bản full");



if (ImGui::Button(" Mod Skin M416 Ice "))
{


}



ImGui::TextColored(ImColor( 255, 0, 0), " # Mod Skin là sử dụng MEMORY để thay đổi giá trị trong trò chơi nên có thể bị BAN !!!  \n # Khi mod cần tháo bỏ quần áo để nhân vật mặc đồ nội y. \n # Vui lòng áp dụng Mod trong trận và trước khi lên máy bay. \n # Sau mỗi trận đấu cần Mod lại từ đầu.");




}//end memory



-(void)showSystemInfo {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "FPS Frame Rate");
    if (ImGui::RadioButton("60FPS", &self.moduleControl->fps, 0)) {
        configManager::putInteger(config,"mainSwitch", "fps",self.moduleControl->fps);
        overlayView.preferredFramesPerSecond = 60;
    }
    ImGui::SameLine();
    if (ImGui::RadioButton("90FPS", &self.moduleControl->fps, 1)) {
        configManager::putInteger(config,"mainSwitch", "fps",self.moduleControl->fps);
        overlayView.preferredFramesPerSecond = 90;
    }
    ImGui::SameLine();
    if (ImGui::RadioButton("120FPS", &self.moduleControl->fps, 2)) {
        configManager::putInteger(config,"mainSwitch", "fps",self.moduleControl->fps);
        overlayView.preferredFramesPerSecond = 120;



    }
    
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Control Switch");
    
    if (ImGui::Checkbox("Player ESP", &self.moduleControl->mainSwitch.playerStatus)) {
        configManager::putBoolean(config,"mainSwitch", "player", self.moduleControl->mainSwitch.playerStatus);
           }
    ImGui::SameLine();
    if (ImGui::Checkbox("Items ESP", &self.moduleControl->mainSwitch.materialStatus)) {
        configManager::putBoolean(config,"mainSwitch", "material", self.moduleControl->mainSwitch.materialStatus);
        }
    ImGui::SameLine();
    if (ImGui::Checkbox("Aimbot", &self.moduleControl->mainSwitch.aimbotStatus)) {
        configManager::putBoolean(config,"mainSwitch", "aimbot", self.moduleControl->mainSwitch.aimbotStatus);
            }


        ImGui::SameLine();
    if (ImGui::Checkbox("Im not Hacker",&hidehacker)) {
        
        static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

  [HideEsp addSubview:overlayView];

});

    }



ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "System Notifi");
    
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(32.0f, 32.0f));
    ImGui::TextWrapped("%s", "Expired Time: 2023-06-05");
    ImGui::TextWrapped("%s", "Expired End Time: 2033-06-05");
    ImGui::PopStyleVar();
    

/////

NSString *ip = [NSString stringWithFormat:NSSENCRYPT("%@"),WiFiInfoString()];

char* showip = (char*) [ip cStringUsingEncoding:NSUTF8StringEncoding];


//////

ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Status:");

    ImGui::SameLine();
ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(32.0f, 32.0f));


    //Try this
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        NSLog(@"none");
        //No internet
        
        ImGui::TextColored(ImColor(255, 0, 0), "(%s)", [NSSENCRYPT("Không có kết nối, Vui lòng kiểm tra lại đường truyền mạng!") UTF8String]);
        
    }
    else if (status == ReachableViaWiFi)
    {
        NSLog(@"Wifi");
        //WiFi

ImGui::TextColored(ImColor(0, 255, 255), "%s", [NSSENCRYPT("Bạn đang kết nối bằng Wifi") UTF8String]);
ImGui::SameLine();
ImGui::TextColored(ImColor(255, 0, 0), " (%s)",showip);

    }
    else if (status == ReachableViaWWAN)
    {
        NSLog(@"WWAN");
        
ImGui::TextColored(ImColor(255, 255, 0), "(%s)", [NSSENCRYPT("Bạn đang kết nối bằng LTE/4G") UTF8String]);
    }

    ImGui::PopStyleVar();

/////

    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "RAM Usage:");
    



//ram
mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);        
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        printf("Failed to fetch vm statistics");
        return;
    }
    
    natural_t mem_used = (vm_stat.active_count +
                         vm_stat.inactive_count +
                         vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;

/////





ImGui::TextColored(ImColor(255, 165, 79), "%s", [NSSENCRYPT("Total:") UTF8String]);

ImGui::SameLine();

ImGui::TextColored(ImColor(0, 255, 0), "%.2f%s", mem_total / 1024.0 / 1024.0, [NSSENCRYPT("MB") UTF8String
]);

ImGui::SameLine();
ImGui::Text("%s", [NSSENCRYPT("/") UTF8String]);
ImGui::SameLine();

ImGui::TextColored(ImColor(255, 0, 255), "%s", [NSSENCRYPT("Used:") UTF8String]);

ImGui::SameLine();
    
ImGui::TextColored(ImColor(255, 255, 0), "%.2f%s", mem_used / 1024.0 / 1024.0, [NSSENCRYPT("MB") UTF8String
]);

ImGui::SameLine();

ImGui::TextColored(ImColor(192, 255, 62), "(%.2f%%)", 100.0 * mem_used / mem_total);


ImGui::TextColored(ImColor(125, 165, 62),"Delay frame .  %.3f ms/frame (%.1f FPS)", 500.0f / ImGui::GetIO().Framerate, ImGui::GetIO().Framerate);



    ImGui::Text("Copyright © 2023 @BoniOSVN. All Rights Reserved.");
    
}





-(void) showPlayerControl {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "ESP Control");
    if (ImGui::Checkbox("Handheld Icon", &self.moduleControl->playerSwitch.SCStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_6", self.moduleControl->playerSwitch.SCStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Handheld Text", &self.moduleControl->playerSwitch.SCWZStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_7", self.moduleControl->playerSwitch.SCWZStatus);
    }

    
    if (ImGui::Checkbox("Box", &self.moduleControl->playerSwitch.boxStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_0", self.moduleControl->playerSwitch.boxStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Bone", &self.moduleControl->playerSwitch.boneStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_1", self.moduleControl->playerSwitch.boneStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Line", &self.moduleControl->playerSwitch.lineStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_2", self.moduleControl->playerSwitch.lineStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Info", &self.moduleControl->playerSwitch.infoStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_3", self.moduleControl->playerSwitch.infoStatus);
    }
    
    if (ImGui::Checkbox("Radar", &self.moduleControl->playerSwitch.radarStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_4", self.moduleControl->playerSwitch.radarStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Warning Behind", &self.moduleControl->playerSwitch.backStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_5", self.moduleControl->playerSwitch.backStatus);
    }
    
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Radar Adjustment");
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("雷达X") - 32.0f);
    if (ImGui::SliderFloat("Radar X##radarX", &self.moduleControl->playerSwitch.radarCoord.x, 0.0f, ([UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].nativeScale), "%.0f")) {
        configManager::putFloat(config,"playerSwitch", "radarX", self.moduleControl->playerSwitch.radarCoord.x);
    }
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("雷达Y") - 32.0f);
    if (ImGui::SliderFloat("Radar Y##radarY", &self.moduleControl->playerSwitch.radarCoord.y, 0.0f, ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].nativeScale), "%.0f")) {
        configManager::putFloat(config,"playerSwitch", "radarY", self.moduleControl->playerSwitch.radarCoord.y);
    }
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("雷达大小") - 32.0f);
    if (ImGui::SliderFloat("Radar Size##radarSize", &self.moduleControl->playerSwitch.radarSize, 1.0f, 100, "%.0f%%")) {
        configManager::putFloat(config,"playerSwitch", "radarSize", self.moduleControl->playerSwitch.radarSize);
    }
}




-(void) showMaterialControl {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Draw Items");
    
    if (ImGui::Checkbox("Material Icon", &self.moduleControl->playerSwitch.WZStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_8", self.moduleControl->playerSwitch.WZStatus);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Material Text", &self.moduleControl->playerSwitch.WZWZStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_9", self.moduleControl->playerSwitch.WZWZStatus);
    }

    ImGui::SameLine();
    if (ImGui::Checkbox("Bomb Warning", &self.moduleControl->materialSwitch[Warning])) {
        std::string str = "materialSwitch_" + std::to_string(Warning);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Warning]);
    }

    ImGui::Separator();


    if (ImGui::Checkbox("Vehicle", &self.moduleControl->materialSwitch[Vehicle])) {
        std::string str = "materialSwitch_" + std::to_string(Vehicle);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Vehicle]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Airdrop(or Loot Box)", &self.moduleControl->materialSwitch[Airdrop])) {
        std::string str = "materialSwitch_" + std::to_string(Airdrop);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Airdrop]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("FlareGun", &self.moduleControl->materialSwitch[FlareGun])) {
        std::string str = "materialSwitch_" + std::to_string(FlareGun);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[FlareGun]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Sniper", &self.moduleControl->materialSwitch[Sniper])) {
        std::string str = "materialSwitch_" + std::to_string(Sniper);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Sniper]);
    }
    
    if (ImGui::Checkbox("Rifle", &self.moduleControl->materialSwitch[Rifle])) {
        std::string str = "materialSwitch_" + std::to_string(Rifle);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Rifle]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Missile", &self.moduleControl->materialSwitch[Missile])) {
        std::string str = "materialSwitch_" + std::to_string(Missile);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Missile]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Armor", &self.moduleControl->materialSwitch[Armor])) {
        std::string str = "materialSwitch_" + std::to_string(Armor);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Armor]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("SniperParts", &self.moduleControl->materialSwitch[SniperParts])) {
        std::string str = "materialSwitch_" + std::to_string(SniperParts);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[SniperParts]);
    }
    
    if (ImGui::Checkbox("RifleParts", &self.moduleControl->materialSwitch[RifleParts])) {
        std::string str = "materialSwitch_" + std::to_string(RifleParts);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[RifleParts]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Drug", &self.moduleControl->materialSwitch[Drug])) {
        std::string str = "materialSwitch_" + std::to_string(Drug);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Drug]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Bullet", &self.moduleControl->materialSwitch[Bullet])) {
        std::string str = "materialSwitch_" + std::to_string(Bullet);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Bullet]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Grip", &self.moduleControl->materialSwitch[Grip])) {
        std::string str = "materialSwitch_" + std::to_string(Grip);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Grip]);
    }
    
    if (ImGui::Checkbox("Sight", &self.moduleControl->materialSwitch[Sight])) {
        std::string str = "materialSwitch_" + std::to_string(Sight);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Sight]);
    }

}

-(void) showAimbotControl {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "automatic target");
    

    if (ImGui::Checkbox("aiming range", &self.moduleControl->aimbotController.showAimbotRadius)) {
        configManager::putBoolean(config,"aimbotControl", "showRadius", self.moduleControl->aimbotController.showAimbotRadius);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Not Knockdown", &self.moduleControl->aimbotController.fallNotAim)) {
        configManager::putBoolean(config,"aimbotControl", "fall", self.moduleControl->aimbotController.fallNotAim);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Not aim Smoke", &self.moduleControl->aimbotController.smoke)) {
        configManager::putBoolean(config,"aimbotControl", "smoke", self.moduleControl->aimbotController.smoke);
    }


    ImGui::SetNextItemWidth(calcTextSize("自瞄强度占位"));
    if (ImGui::Combo("self-aiming power", &aimbotIntensity, aimbotIntensityText, IM_ARRAYSIZE(aimbotIntensityText))) {
        configManager::putInteger(config,"aimbotControl", "intensity",aimbotIntensity);
        switch (aimbotIntensity) {
            case 0:
                self.moduleControl->aimbotController.aimbotIntensity = 0.1f;
                break;
            case 1:
                self.moduleControl->aimbotController.aimbotIntensity = 0.2f;
                break;
            case 2:
                self.moduleControl->aimbotController.aimbotIntensity = 0.3f;
                break;
            case 3:
                self.moduleControl->aimbotController.aimbotIntensity = 0.4f;
                break;
            case 4:
                self.moduleControl->aimbotController.aimbotIntensity = 0.5f;
                break;
            case 5:
                self.moduleControl->aimbotController.aimbotIntensity = 1.0f;
                break;
            case 6:
                self.moduleControl->aimbotController.aimbotIntensity = 1.2f;
                break;
        }
    }
    

    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() / 2 - calcTextSize("自瞄模式") - 32.0f);
    if (ImGui::Combo("Mode Aimbot", &self.moduleControl->aimbotController.aimbotMode, aimbotModeText, IM_ARRAYSIZE(aimbotModeText))) {
        configManager::putInteger(config,"aimbotControl", "mode", self.moduleControl->aimbotController.aimbotMode);
    }

    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() / 2 - calcTextSize("自瞄部位") - 32.0f);
    if (ImGui::Combo("Aimbot Parts", &self.moduleControl->aimbotController.aimbotParts, aimbotPartsText, IM_ARRAYSIZE(aimbotPartsText))) {
        configManager::putBoolean(config,"aimbotControl", "parts", self.moduleControl->aimbotController.aimbotParts);
    }
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("自瞄范围") - 32.0f);
    if (ImGui::SliderFloat("Aimbot FOV", &self.moduleControl->aimbotController.aimbotRadius, 0.0f, ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].nativeScale) / 2 + 800, "%.0f")) {
        configManager::putFloat(config,"aimbotControl", "radius", self.moduleControl->aimbotController.aimbotRadius);
    }
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("自瞄距离") - 32.0f);
    if (ImGui::SliderFloat("Aimbot Distance", &self.moduleControl->aimbotController.distance, 0.0f, 450.0f, "%.0fM")) {
        configManager::putFloat(config,"aimbotControl", "distance", self.moduleControl->aimbotController.distance);


//ImGui::SliderFloat("Bullet Speed", &bulletSpeed, 1.0f, 100, "%.0f%%");


    }
    //ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Contact Us");
    //ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(32.0f, 32.0f));
    //ImGui::TextWrapped( "Contact: @BoniOSVN");
    //ImGui::PopStyleVar();

}

-(void)readIniConfig{
    self.moduleControl->fps = configManager::readInteger(config,"mainSwitch", "fps", 0);
    switch(self.moduleControl->fps){
        case 0:
            overlayView.preferredFramesPerSecond = 60;
            break;
        case 1:
            overlayView.preferredFramesPerSecond = 90;
            break;
        case 2:
            overlayView.preferredFramesPerSecond = 120;
            break;
        default:
            overlayView.preferredFramesPerSecond = 120;
            break;
    }
  
    self.moduleControl->mainSwitch.playerStatus = configManager::readBoolean(config,"mainSwitch", "player", false);
    self.moduleControl->mainSwitch.materialStatus = configManager::readBoolean(config,"mainSwitch", "material", false);
    self.moduleControl->mainSwitch.aimbotStatus = configManager::readBoolean(config,"mainSwitch", "aimbot", false);
   
    for (int i = 0; i < 10; ++i) {
        std::string str = "playerSwitch_" + std::to_string(i);
        *((bool *) &self.moduleControl->playerSwitch + sizeof(bool) * i) = configManager::readBoolean(config,"playerSwitch", str.c_str(), false);
    }
   
    self.moduleControl->playerSwitch.radarSize = configManager::readFloat(config,"playerSwitch", "radarSize", 70);
    self.moduleControl->playerSwitch.radarCoord.x = configManager::readFloat(config,"playerSwitch", "radarX", 500);
    self.moduleControl->playerSwitch.radarCoord.y = configManager::readFloat(config,"playerSwitch", "radarY", 500);
   
    for (int i = 0; i < All; ++i) {
        std::string str = "materialSwitch_" + std::to_string(i);
        self.moduleControl->materialSwitch[i] = configManager::readBoolean(config,"materialSwitch", str.c_str(), false);
    }
  
    self.moduleControl->aimbotController.fallNotAim = configManager::readBoolean(config,"aimbotControl", "fall", false);
    self.moduleControl->aimbotController.showAimbotRadius = configManager::readBoolean(config,"aimbotControl", "showRadius", true);
    self.moduleControl->aimbotController.aimbotRadius = configManager::readFloat(config,"aimbotControl", "radius", 420);
    
    self.moduleControl->aimbotController.smoke = configManager::readBoolean(config,"aimbotControl", "smoke", true);
    
    //自瞄模式
    self.moduleControl->aimbotController.aimbotMode = configManager::readInteger(config,"aimbotControl", "mode", 3);
    
    self.moduleControl->aimbotController.aimbotParts = configManager::readInteger(config,"aimbotControl", "parts", 2);
 
    aimbotIntensity = configManager::readInteger(config,"aimbotControl", "intensity", 2);
    switch (aimbotIntensity) {
        case 0:
            self.moduleControl->aimbotController.aimbotIntensity = 0.1f;
            break;
        case 1:
            self.moduleControl->aimbotController.aimbotIntensity = 0.2f;
            break;
        case 2:
            self.moduleControl->aimbotController.aimbotIntensity = 0.3f;
            break;
        case 3:
            self.moduleControl->aimbotController.aimbotIntensity = 0.4f;
            break;
        case 4:
            self.moduleControl->aimbotController.aimbotIntensity = 0.5f;
            break;
        case 5:
            self.moduleControl->aimbotController.aimbotIntensity = 1.0f;
            break;
        case 6:
            self.moduleControl->aimbotController.aimbotIntensity = 1.2f;
            break;
    }
    
    self.moduleControl->aimbotController.distance = configManager::readFloat(config,"aimbotControl", "distance", 450);
}

@end
