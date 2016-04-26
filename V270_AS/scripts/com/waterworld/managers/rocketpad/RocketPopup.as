package com.waterworld.managers.rocketpad
{
   import com.waterworld.managers.popups.AbstractPopup;
   import com.kixeye.popups.IPopupBehavior;
   import com.kixeye.logging.KXLogger;
   import flash.geom.Rectangle;
   import com.kixeye.logging.class_72;
   import com.waterworld.ui.List2D;
   import flash.display.Sprite;
   import package_166.BuildingOfficerTray;
   import package_64.InventoryController;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import package_197.ProgressBar;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.utils.movieclip.class_277;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.display.ButtonManager;
   import package_40.class_301;
   import com.waterworld.datastores.IOShipComponent;
   import gs.TweenLite;
   import package_64.InventoryItem;
   import package_32.ComponentManager;
   import com.waterworld.utils.class_84;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import package_40.RocketSpeedupView;
   import com.waterworld.core.BASE;
   import com.waterworld.entities.RocketLaunchPad;
   import com.waterworld.datastores.IOBuildingCosts;
   import package_59.BaseTransactionLogEvent;
   import com.waterworld.managers.store.STORE;
   import package_177.BasicAutomation;
   import package_23.TwoButtonMessagePopupWithClose;
   import package_226.SimpleSliderSkin;
   import com.kixeye.ui.list.class_243;
   import package_40.RocketInventoryUpdateEvent;
   import package_40.RocketInventoryManager;
   import com.kixeye.popups.PopupManager;
   
   public class RocketPopup extends AbstractPopup implements IPopupBehavior
   {
      
      private static var _log:KXLogger = class_72.getLoggerForClass(RocketPopup);
      
      private static const const_18:String = "AssetRocketPopup_V3";
      
      public static const const_249:int = 1;
      
      public static const const_186:int = 2;
      
      public static const const_2617:int = 3;
      
      public static const const_3840:int = 3;
      
      private static const const_460:Array = [10,10,6,6];
      
      private static const const_2581:String = "ResearchPopup3.speedUp";
      
      private static const const_2804:String = "ResearchPopup3.cancel";
      
      private static const const_2685:String = "ResearchPopup3.bScrap";
      
      private static const const_1955:String = "ResearchPopup3.loadout";
      
      private static const const_3619:String = "bScrap";
      
      private static const const_199:Rectangle = new Rectangle(0,0,721,478);
      
      private static const const_1317:int = 60;
      
      {
         _log = class_72.getLoggerForClass(RocketPopup);
      }
      
      private var var_389:int = 0;
      
      private var _list:List2D;
      
      private var var_2142:int = -1;
      
      private var var_161:Sprite;
      
      private var var_442:Array;
      
      private var var_5765:BuildingOfficerTray;
      
      private var var_342:InventoryController;
      
      private var var_471:MovieClip;
      
      private var var_1337:MovieClip;
      
      private var var_1379:MovieClip;
      
      private var var_2767:MovieClip;
      
      private var var_5407:MovieClip;
      
      private var var_2118:Vector.<RocketBuildButton>;
      
      private var var_4147:TextField;
      
      private var var_2629:TextField;
      
      private var var_5186:TextField;
      
      private var var_3722:TextField;
      
      private var _progressBar:ProgressBar;
      
      private var var_1231:MovieClip;
      
      public function RocketPopup()
      {
         var_442 = [];
         var_342 = InventoryController.getInstance();
         super("AssetRocketPopup_V3");
      }
      
      private function get hasInventory() : Boolean
      {
         return var_342.getCountForType(1) > 0;
      }
      
      override public function destroy() : void
      {
         var _loc1_:RocketPopupInfo = getPopup();
         if(null != _loc1_)
         {
            _loc1_.hide();
         }
         var_5765 = null;
         destroyRocketButtons();
         GLOBAL.rocketInventory.removeEventListener("updated",handleInventoryUpdate);
         super.destroy();
      }
      
      private function destroyRocketButtons() : void
      {
         if(var_2118)
         {
            var _loc3_:* = 0;
            var _loc2_:* = var_2118;
            for each(var _loc1_ in var_2118)
            {
               _loc1_.destroy();
            }
         }
         var_2118 = null;
      }
      
      override public function centerPopup() : void
      {
         var _loc2_:Number = const_199.width;
         var _loc1_:Number = const_199.height;
         view.x = (GLOBAL.ROOT.stage.stageWidth - _loc2_) / 2;
         view.y = (GLOBAL.ROOT.stage.stageHeight - _loc1_) / 3;
      }
      
      override protected function initialize() : void
      {
         class_277.setTextOn(_popup,["tWindowHeader"],BPResourceManager.getString("bp-flash","rocketpad_popup_headline"));
         var_471 = class_277.getMovieClip(_popup,["display_mc"]);
         var_1337 = class_277.getMovieClip(_popup,["btnSpeedup"]);
         var_1379 = class_277.getMovieClip(_popup,["btnCancel"]);
         var_2767 = class_277.getMovieClip(var_471,["bScrap"]);
         var_5407 = class_277.getMovieClip(_popup,["btnLoadOut"]);
         var_4147 = class_277.getTextField(var_471,["tDetails"]);
         var_2629 = class_277.getTextField(var_471,["tTime"]);
         var_5186 = class_277.getTextField(_popup,["tCounter"]);
         var_3722 = class_277.getTextField(_popup,["tRocketCapacity"]);
         var_3722.selectable = false;
         ButtonManager.attach(var_1337,onButtonClick,BPResourceManager.getString("bp-flash","rocketpad_popup_button_speedup"),"ResearchPopup3.speedUp");
         ButtonManager.attach(var_1379,onButtonClick,BPResourceManager.getString("bp-flash","rocketpad_popup_button_cancel"),"ResearchPopup3.cancel");
         ButtonManager.attach(var_2767,onButtonClick,null,"ResearchPopup3.bScrap","bScrap");
         ButtonManager.attach(var_5407,onButtonClick,BPResourceManager.getString("bp-flash","rocketpad_popup_button_loadout"),"ResearchPopup3.loadout");
         var_1231 = class_277.getMovieClip(var_471,["icon","iconArt"]);
         var_1231.visible = false;
         var_3722.text = BPResourceManager.getString("bp-flash","rocketpad_popup_rocketcapacity");
         class_277.setTextOn(var_2767,["tText"],BPResourceManager.getString("bp-flash","entities_buildingrocketpad_button_scraprocket"));
         _progressBar = new ProgressBar(class_277.getMovieClip(var_471,["progressBar"]));
         _progressBar.setProgress(0,true);
         _list = new List2D(1,1);
         updateRocketInventoryText();
         update();
         centerPopup();
         GLOBAL.rocketInventory.addEventListener("updated",handleInventoryUpdate);
      }
      
      public function update(param1:Boolean = false) : void
      {
         var _loc2_:* = null;
         if(param1)
         {
            setupButtons();
         }
         else
         {
            _loc2_ = GLOBAL.rocketInventory.getBuildingRocket();
            if(_loc2_)
            {
               ShowActivity(_loc2_.itemCode);
            }
            else if(hasInventory)
            {
               showInventory();
            }
            else
            {
               ShowNoActivity();
            }
         }
      }
      
      public function showInfo(param1:int) : void
      {
         var _loc2_:RocketPopupInfo = getPopup();
         if(_loc2_)
         {
            _loc2_.hide();
         }
         var_2142 = new RocketPopupInfo(param1,this.id,GLOBAL.bRocketPad.type).id;
      }
      
      public function hideInfo() : void
      {
         var _loc1_:RocketPopupInfo = getPopup();
         if(null != _loc1_)
         {
            _loc1_.hide();
         }
      }
      
      private function showRocket(param1:IOShipComponent) : void
      {
         var_471.visible = true;
         TweenLite.killTweensOf(this);
         var _loc2_:int = var_471.y;
         var_471.y = _loc2_ + 60;
         TweenLite.to(var_471,0.7,{
            "delay":0.1,
            "y":_loc2_
         });
         class_277.setTextOnTextField(var_4147,param1.desc);
         class_277.setTextOn(var_471,["tContentHeader"],param1.fullName);
         GLOBAL.assets.getImageByURLAsync(param1.iconlarge,onImageLoaded,null,true);
      }
      
      private function showInventory() : void
      {
         var _loc1_:* = null;
         if(var_389 != 3)
         {
            var_389 = 3;
            _loc1_ = var_342.getFirstItemForType(1);
            showRocket(ComponentManager.getInstance().getComponent(_loc1_.io.itemcode));
            var_2629.visible = false;
            _progressBar.setVisibility(false);
            var_2767.visible = true;
            var_1337.visible = true;
            var_1379.visible = true;
            ButtonManager.setEnabled(var_1337,false,true);
            ButtonManager.setEnabled(var_1379,false,true);
            setupButtons();
         }
      }
      
      private function ShowNoActivity() : void
      {
         if(var_389 != 1)
         {
            var_389 = 1;
            var_1337.visible = false;
            var_1379.visible = false;
            ButtonManager.setEnabled(var_1337,false,true);
            ButtonManager.setEnabled(var_1379,false,true);
            class_277.setTextOnTextField(var_2629,"");
            class_277.setTextOnTextField(var_4147,"");
            class_277.setTextOn(var_471,["tContentHeader"],BPResourceManager.getString("bp-flash","rocketpad_currentconstruction"));
            TweenLite.killTweensOf(this);
            if(var_161 && var_161.parent)
            {
               var_161.parent.removeChild(var_161);
            }
            var_161 = null;
            var_471.visible = false;
            setupButtons();
         }
      }
      
      private function ShowActivity(param1:int) : void
      {
         if(var_389 != 2)
         {
            var_389 = 2;
            showRocket(ComponentManager.getInstance().getComponent(param1));
            var_2629.visible = true;
            _progressBar.setVisibility(true);
            var_2767.visible = false;
            var_1337.visible = true;
            var_1379.visible = true;
            ButtonManager.setEnabled(var_1379,true,false);
            ButtonManager.setEnabled(var_1337,true,false);
            setupButtons();
         }
         _progressBar.setProgress(GLOBAL.bRocketPad.rocketPercentageComplete,true);
         class_277.setTextOnTextField(var_2629,class_84.toTime(GLOBAL.bRocketPad.rocketBuildTimeRemaining,true,true));
      }
      
      private function onImageLoaded(param1:Vector.<String>) : void
      {
         var_1231.visible = true;
         if(var_161)
         {
            var_161.parent.removeChild(var_161);
            var_161 = null;
         }
         var_161 = new MovieClip();
         var_161.mask = var_1231;
         var_471.icon.addChild(var_161);
         var _loc2_:BitmapData = GLOBAL.assets.getBitmapData(param1[0]);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         class_277.fitImageToRegion(_loc3_,var_1231.getRect(var_1231));
         var_161.addChild(_loc3_);
      }
      
      private function onButtonClick(param1:String, param2:*, param3:Object = null) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = param1;
         if("researchview" !== _loc5_)
         {
            if("btnCancel" !== _loc5_)
            {
               if("btnSpeedup" !== _loc5_)
               {
                  if("btnLoadOut" !== _loc5_)
                  {
                     if("bScrap" === _loc5_)
                     {
                        hide();
                        _loc4_ = GLOBAL.rocketInventory.getBuildingRocket();
                        GLOBAL.bRocketPad.scrapRocket(_loc4_.itemCode);
                     }
                  }
                  else
                  {
                     class_173.showLoadoutPopup(id);
                  }
               }
               else
               {
                  speedupNew();
               }
            }
            else
            {
               GLOBAL.bRocketPad.cancelRocketBuildConfirmation();
            }
         }
         else
         {
            onResearchViewClick(param3.comp.id);
         }
      }
      
      private function speedupNew() : void
      {
      }
      
      private function speedup() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc5_:* = null;
         var _loc1_:* = null;
         var _loc7_:* = null;
         var _loc3_:* = null;
         BASE.buildingSelect(GLOBAL.bRocketPad,true);
         var _loc6_:RocketLaunchPad = RocketLaunchPad(GLOBAL.bRocketPad);
         if(_loc6_.isBuildingRocket)
         {
            _loc4_ = "rocketbuilt";
            _loc8_ = _loc6_.rocketBuildTimeRemaining;
            _loc9_ = _loc6_.rocketEndTime - _loc6_.rocketStartTime;
            _loc2_ = GLOBAL.rocketInventory.getBuildingRocket();
            _loc1_ = ComponentManager.getInstance().getComponent(_loc2_.itemCode);
            _loc5_ = _loc1_.costs;
         }
         if(_loc4_)
         {
            _loc3_ = new BaseTransactionLogEvent(_loc4_,_loc6_.type,_loc6_.level,"speedup",_loc8_,_loc9_,STORE.costForTime(_loc8_),_loc5_.r1,_loc5_.r2,_loc5_.r3,_loc5_.r4,_loc5_.uraniumCurrency);
            _loc7_ = [_loc3_];
         }
         STORE.show("speedups","LaunchPad",null,id,_loc7_);
      }
      
      private function onResearchViewClick(param1:int) : void
      {
         compId = param1;
         var errorData:Object = class_173.canBuild(compId);
         if(!errorData.error)
         {
            showInfo(compId);
         }
         else
         {
            showCTA = function():void
            {
               hide();
               ctaAction.apply(null,ctaArgs);
            };
            var ctaTextKey:String = "";
            var ctaArgs:Array = null;
            if(errorData.errorResearch)
            {
               ctaTextKey = "rocketpad_research_button";
               var ctaAction:Function = BasicAutomation.getInstance().getFunctionCall("FUNCTION_SHOW_RESEARCH_POPUP");
               ctaArgs = [21,compId];
            }
            else if(errorData.errorPad)
            {
               ctaTextKey = "rocketpad_upgrade_button";
               ctaAction = BasicAutomation.getInstance().getFunctionCall("FUNCTION_SHOW_BUILDING_UPGRADE_POPUP");
               ctaArgs = [73];
            }
            new TwoButtonMessagePopupWithClose(BPResourceManager.getString("bp-flash","generic_popup_title"),errorData.errorMessage,showCTA,BPResourceManager.getString("bp-flash",ctaTextKey),null,null,BPResourceManager.getString("bp-flash","generic_popup_ok"),null,id);
         }
      }
      
      private function setupButtons() : void
      {
         var _loc3_:* = null;
         var _loc11_:* = null;
         var _loc1_:MovieClip = class_277.getMovieClip(_popup,["entryGuide"]);
         _loc1_.mouseChildren = false;
         _loc1_.mouseEnabled = false;
         var _loc6_:MovieClip = class_277.getMovieClip(_popup,["entryGuideSmall"]);
         _loc6_.mouseChildren = false;
         _loc6_.mouseEnabled = false;
         var _loc5_:MovieClip = var_389 == 1?_loc1_:_loc6_;
         var _loc7_:MovieClip = class_277.getMovieClip(_popup,["scroll"]);
         var _loc10_:MovieClip = class_277.getMovieClip(_loc7_,["bg_mc"]);
         var _loc9_:MovieClip = class_277.getMovieClip(_loc7_,["scroller_mc"]);
         _list.view.x = _loc5_.x;
         _list.view.y = _loc5_.y;
         _list.width = _loc5_.width;
         _list.height = _loc5_.height;
         _list.sliderControls.skin = new SimpleSliderSkin(_loc10_,_loc9_);
         _popup.addChildAt(_list.view,_popup.getChildIndex(_loc7_) - 1);
         var _loc8_:Vector.<IOShipComponent> = class_173.getComponents();
         _loc8_.sort(sortRockets);
         var _loc4_:Vector.<class_243> = new Vector.<class_243>(0);
         destroyRocketButtons();
         var_2118 = new Vector.<RocketBuildButton>();
         var _loc13_:* = 0;
         var _loc12_:* = _loc8_;
         for each(var _loc2_ in _loc8_)
         {
            _loc3_ = new RocketBuildButton(_loc2_.id,true,onButtonClick);
            _loc4_.push(_loc3_);
            var_2118.push(_loc3_);
         }
         _list.dataProvider = _loc4_;
         if(_loc8_.length == 0)
         {
            _loc11_ = getPopupAsset("assetResearchButtonSoon");
            _loc11_.gotoAndStop(var_389 != 1?1:2.0);
            _loc5_.addChild(_loc11_);
         }
      }
      
      private function handleInventoryUpdate(param1:RocketInventoryUpdateEvent) : void
      {
         updateRocketInventoryText();
         update(true);
      }
      
      private function updateRocketInventoryText() : void
      {
         var _loc2_:RocketInventoryManager = GLOBAL.rocketInventory;
         var _loc3_:int = _loc2_.numRockets;
         var _loc1_:int = _loc2_.capacity;
         class_277.setTextOnTextField(var_5186,BPResourceManager.getString("bp-flash","rocketpad_popup_ratio",{
            "points":_loc3_,
            "total":_loc1_
         }));
      }
      
      private function sortRockets(param1:IOShipComponent, param2:IOShipComponent) : int
      {
         return param1.sortOrder - param2.sortOrder;
      }
      
      private function getPopup() : RocketPopupInfo
      {
         return PopupManager.getInstance().getPopupById(var_2142) as RocketPopupInfo;
      }
   }
}
