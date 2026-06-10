#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// =========================================================
// UI 层 Hook (控制中心、设置)
// =========================================================
%group UI_Hooks

%hook SFAirDropDiscoveryController

// 让 UI 界面认为没有任何时间限制
- (BOOL)isTimeLimitedEveryoneMode {
    return NO;
}

%end

%end // end UI_Hooks


// =========================================================
// Daemon 层 Hook (sharingd 底层逻辑)
// =========================================================
%group Daemon_Hooks

%hook SDStatusMonitor

// 1. 核心防御：直接拦截定时器的创建。不仅突破限制，还能节省系统调度资源的内存开销。
- (void)_scheduleCheckForEveryoneModeExpiry {
    // 留空，不调用 %orig，从根本上杀掉 10 分钟倒计时。
}

// 2. 拦截系统主动的过期检查动作。
- (void)_checkEveryoneModeExpiry {
    // 留空
}

// 3. 状态查询防御：如果系统其他组件询问是否过期，永远回答 NO。
- (BOOL)_isEveryoneModeExpired {
    return NO;
}

// 4. 数据边界防御：赋予倒计时极限值 (DBL_MAX)，防止因为数学计算导致的越界或崩溃。
- (double)_currentEveryoneModeExpiryInterval {
    return DBL_MAX; 
}

- (double)_everyoneModeExpiryInterval {
    return DBL_MAX; 
}

%end

%end // end Daemon_Hooks


// =========================================================
// 构造函数：安全注入策略
// =========================================================
%ctor {
    // 防御性判断：只有在当前进程中找到了对应的类，才执行 Hook。
    // 这能确保即使苹果在 iOS 18 彻底删除了这个类，插件也只会静默失效，而绝对不会导致 Safe Mode。
    
    if (objc_getClass("SFAirDropDiscoveryController")) {
        %init(UI_Hooks);
    }
    
    if (objc_getClass("SDStatusMonitor")) {
        %init(Daemon_Hooks);
    }
}
