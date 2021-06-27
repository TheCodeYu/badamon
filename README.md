Don't forget to add these 2 lines at the beggining of windows\runner\main.cpp

#include <bitsdojo_window/bitsdojo_window_plugin.h>
auto bdw = bitsdojo_window_configure(BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP);

# 这个一定要加,去除Flutter自带的顶部标题栏和启动动画转场

## 已知问题带修复
1.配置文件读取时值超过范围


//监听每一帧结束
@override
void initState() {
  super.initState();
  widgetsBinding=WidgetsBinding.instance;
  widgetsBinding.addPostFrameCallback((callback){
    widgetsBinding.addPersistentFrameCallback((callback){
      print("addPersistentFrameCallback be invoke");
      //触发一帧的绘制
      widgetsBinding.scheduleFrame();
    });
  });