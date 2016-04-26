package com.waterworld.entities
{
   import com.kixeye.logging.KXLogger;
   import package_32.ComponentManager;
   import com.waterworld.datastores.IOShipComponent;
   import package_166.OfficerManager;
   import com.waterworld.core.GLOBAL;
   import com.kixeye.logging.class_72;
   import com.waterworld.display.class_212;
   import package_40.class_301;
   import com.waterworld.core.GlobalProperties;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.core.BASE;
   import package_40.RocketSpeedupView;
   import com.waterworld.managers.store.STORE;
   import flash.utils.clearTimeout;
   import gs.TweenLite;
   import flash.utils.setTimeout;
   import com.waterworld.display.AnimatedBuildingLayer;
   import flash.events.Event;
   import com.waterworld.utils.ReturnStatus;
   import com.waterworld.datastores.IOBuildingCosts;
   import package_59.BaseTransactionLogEvent;
   import com.waterworld.resources.ResourceLogEvent;
   import package_43.Player;
   import package_59.class_223;
   import package_23.OneButtonMessagePopup;
   import com.kixeye.popups.PopupManager;
   import com.waterworld.managers.rocketpad.class_173;
   import package_40.RocketInventoryManager;
   import package_10.BaseManager;
   import package_23.TwoButtonMessagePopup;
   import com.waterworld.utils.class_295;
   import com.waterworld.entities.catchup.class_321;
   import package_40.RocketInventoryUpdateEvent;
   import com.waterworld.display.BuildingDisplay;
   import com.waterworld.display.BuildingDisplayEvent;
   import com.waterworld.display.class_162;
   import com.waterworld.display.BuildingDisplayControllerEvent;
   
   public class RocketLaunchPad extends BuildingFoundation
   {
      
      private static const const_927:String = "rocketpad";
      
      private static const const_2182:String = "clamps";
      
      private static const const_4695:String = "box";
      
      private static const LAYER_DECK1:String = "deck";
      
      private static const LAYER_DECK2:String = "deck2";
      
      private static const const_275:Array = ["clamps","box","deck","deck2"];
      
      private static var _log:KXLogger = class_72.getLoggerForClass(RocketLaunchPad);
      
      public static const const_2228:Number = 0.9;
      
      public static const const_2475:Number = 0.75;
      
      {
         _log = class_72.getLoggerForClass(RocketLaunchPad);
      }
      
      private var var_5524:uint = 0;
      
      private var var_1861:Boolean = false;
      
      private var var_416:RocketLayer;
      
      private var var_2207:Boolean = false;
      
      public function RocketLaunchPad()
      {
         super(73);
         init();
      }
      
      public static function getBuildTime(param1:int) : Number
      {
         var _loc2_:* = NaN;
         var _loc3_:IOShipComponent = ComponentManager.getInstance().getComponent(param1);
         if(_loc3_)
         {
            _loc2_ = _loc3_.costs.time;
            _loc2_ = _loc2_ * OfficerManager.getInstance().getBuildingBoost(73);
            _loc2_ = _loc2_ * (1 - GLOBAL.const_1.retrieveBonusEffect("rocketbuild"));
            return _loc2_;
         }
         _log.logRemote("ERROR.RocketLaunchPad.getBuildTime","id: " + param1);
         return 0;
      }
      
      private function init() : void
      {
         var_416 = new RocketLayer(class_212.phase2);
         var_416.addEventListener("eventfinished",playBackwards);
         GLOBAL.bRocketPad = this;
         var_171 = "Research Building";
         _displayController.addEventListener("displaychange",displayChangeHandler,false,0,true);
         _displayController.addEventListener("displaychange",postLoadInit,false,0,true);
         loadDescriptor("rocketpad");
      }
      
      public function getCurrentRocket() : IOShipComponent
      {
         var _loc1_:* = null;
         var _loc2_:class_301 = GLOBAL.rocketInventory.getCurrentRocket();
         if(_loc2_)
         {
            _loc1_ = ComponentManager.getInstance().getComponent(_loc2_.itemCode);
         }
         return _loc1_;
      }
      
      public function get rocketStartTime() : Number
      {
         var _loc1_:class_301 = GLOBAL.rocketInventory.getBuildingRocket();
         if(_loc1_ != null)
         {
            return _loc1_.startTime;
         }
         return 0;
      }
      
      public function get rocketEndTime() : Number
      {
         var _loc1_:class_301 = GLOBAL.rocketInventory.getBuildingRocket();
         if(_loc1_ != null)
         {
            return _loc1_.completeTime;
         }
         return 0;
      }
      
      public function get isBuildingRocket() : Boolean
      {
         return rocketBuildTimeRemaining > 0;
      }
      
      public function get rocketPercentageComplete() : Number
      {
         return 1 - (rocketEndTime - GlobalProperties.gameTime) / (rocketEndTime - rocketStartTime);
      }
      
      public function get rocketBuildTimeRemaining() : int
      {
         return Math.max(0,rocketEndTime - GlobalProperties.gameTime);
      }
      
      override public function get speedUpTimeRemaining() : int
      {
         if(isRepairing || buildingEndTime || upgradeEndTime || upgradeFortificationEndTime)
         {
            return super.speedUpTimeRemaining;
         }
         if(isBuildingRocket)
         {
            return rocketBuildTimeRemaining;
         }
         return 0;
      }
      
      override public function activityTimeRemaining(param1:int) : int
      {
         var _loc2_:int = super.activityTimeRemaining(param1);
         if(_loc2_ == 0)
         {
            _loc2_ = rocketBuildTimeRemaining;
         }
         return _loc2_;
      }
      
      override public function get activityTitle() : String
      {
         var _loc1_:String = super.activityTitle;
         if(_loc1_ == null)
         {
            _loc1_ = BPResourceManager.getString("bp-flash","entities_buildingrocketpad_button_rocket");
         }
         return _loc1_;
      }
      
      override public function get activityDetails() : String
      {
         var _loc2_:String = super.activityDetails;
         var _loc1_:IOShipComponent = getCurrentRocket();
         if(_loc2_ == null)
         {
            _loc2_ = _loc1_?_loc1_.fullName:"";
         }
         return _loc2_;
      }
      
      override public function activitySpeedup(param1:int) : void
      {
         BASE.buildingSelect(this);
         if(!isRepairing && isBuildingRocket)
         {
            new RocketSpeedupView(GLOBAL.rocketInventory.getBuildingRocket());
         }
         else
         {
            STORE.show("speedups");
         }
      }
      
      public function getInstantRocketCost(param1:int) : int
      {
         var _loc2_:IOShipComponent = ComponentManager.getInstance().getComponent(param1);
         if(_loc2_)
         {
            return STORE.costForResources(_loc2_.costs.totalCosts) + STORE.costForTime(getBuildTime(param1));
         }
         return 0;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         clearTimeout(var_5524);
         TweenLite.var_635(var_416.play);
         TweenLite.var_635(onPlayFinished);
         var_416.removeEventListener("eventfinished",playBackwards);
         var_416.destroy();
         var_416 = null;
         GLOBAL.rocketInventory.removeEventListener("updated",setupRocketBuildTime);
      }
      
      override public function updateFoundation(param1:Boolean = false) : void
      {
         if(isBuildingRocket)
         {
            if(GLOBAL.mode == "base" && GLOBAL.baseMode == "build" && _displayController)
            {
               _displayController.showProgressBar(BPResourceManager.getString("bp-flash","entities_buildingfoundation_button_building").toUpperCase(),rocketPercentageComplete);
            }
         }
         else
         {
            super.updateFoundation(false);
         }
      }
      
      private function showHideRocket() : void
      {
         if(!var_1861)
         {
            var_5524 = setTimeout(showHideRocket,500);
            return;
         }
         var_2207 = true;
         updateRocketVisibility();
         TweenLite.var_635(var_416.play);
         var _loc1_:IOShipComponent = getCurrentRocket();
         var _loc2_:* = _loc1_ != null;
         if(_loc2_)
         {
            _displayController.contentContainer.addChild(var_416.view);
         }
         else
         {
            var_416.view.removeFromParent();
         }
         if(_loc2_)
         {
            playForwards();
         }
         else
         {
            playBackwards();
         }
      }
      
      private function playForwards() : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = getCustomLayers();
         for each(var _loc1_ in getCustomLayers())
         {
            _loc1_.reversed = false;
            _loc1_.gotoAndPlay(1);
         }
         TweenLite.delayedCall(1,var_416.play);
      }
      
      private function playBackwards(param1:Event = null) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = getCustomLayers();
         for each(var _loc2_ in getCustomLayers())
         {
            _loc2_.reversed = true;
            _loc2_.gotoAndPlay(1);
         }
         TweenLite.delayedCall(1,onPlayFinished);
      }
      
      private function onPlayFinished() : void
      {
         var_2207 = false;
      }
      
      public function buildRocketInstantly(param1:int) : void
      {
         var _loc4_:ReturnStatus = GLOBAL.rocketInventory.canBuildRocket(param1);
         if(_loc4_.isError)
         {
            showRocketLimitMessage();
            return;
         }
         var _loc6_:int = getBuildTime(param1);
         var _loc8_:int = getInstantRocketCost(param1);
         var _loc5_:IOShipComponent = ComponentManager.getInstance().getComponent(param1);
         var _loc7_:IOBuildingCosts = _loc5_.costs;
         var _loc3_:BaseTransactionLogEvent = new BaseTransactionLogEvent("rocketbuilt",this.type,this.level,"instant",0,_loc6_,_loc8_,_loc7_.r1,_loc7_.r2,_loc7_.r3,_loc7_.r4,_loc7_.uraniumCurrency,param1.toString());
         var _loc2_:ResourceLogEvent = new ResourceLogEvent("rocket",_type.toString(),level.toString(),param1.toString(),_loc7_.r1,_loc7_.r2,_loc7_.r3,_loc7_.r4,_loc7_.uraniumCurrency,BASE.oil,BASE.metal,BASE.energy,BASE.zynthium,Player.getInstance().currentUranium,{});
         class_223.sendThroughJavaScript(_loc2_);
         class_223.sendThroughJavaScript(_loc3_);
         GLOBAL.rocketInventory.buildRocketInstant(param1,GlobalProperties.gameTime + _loc6_,GLOBAL.bRocketPad.getInstantRocketCost(param1));
      }
      
      public function showRocketLimitMessage() : void
      {
      }
      
      protected function rocketLimitMessageClosed() : void
      {
         class_173.hideInfo();
         class_173.tick();
      }
      
      public function startRocketBuild(param1:int, param2:Boolean = true) : void
      {
         compid = param1;
         chargeResources = param2;
         var result:ReturnStatus = GLOBAL.rocketInventory.canBuildRocket(compid);
         if(!result.isError)
         {
            var comp:IOShipComponent = ComponentManager.getInstance().getComponent(compid);
            var costs:IOBuildingCosts = comp.costs;
            if(!chargeResources || BASE.canAffordResourcesForBuild(costs))
            {
               var goldCost:int = 0;
               if(chargeResources)
               {
                  goldCost = getInstantRocketCost(compid);
                  var resourceLogger:ResourceLogEvent = new ResourceLogEvent("organicrocket",_type.toString(),level.toString(),compid.toString(),costs.r1 * -1,costs.r2 * -1,costs.r3 * -1,costs.r4 * -1,costs.uraniumCurrency * -1,BASE.oil,BASE.metal,BASE.energy,BASE.zynthium,Player.getInstance().currentUranium,{});
                  class_223.sendThroughJavaScript(resourceLogger);
                  BASE.chargeAllResourcesFromCosts(costs);
               }
               var timeCost:int = getBuildTime(compid);
               var rocketInventory:RocketInventoryManager = GLOBAL.rocketInventory;
               var completeTime:int = GlobalProperties.gameTime + timeCost;
               if(!chargeResources)
               {
                  completeTime = GlobalProperties.gameTime;
               }
               var rocketPad:RocketLaunchPad = this;
               rocketInventory.buildRocket(comp.id,completeTime,function():void
               {
                  BaseManager.getInstance().activityQueue.addActivity("rock" + _id,rocketPad,12);
                  var _loc2_:String = chargeResources?"start":"instant";
                  var _loc3_:int = chargeResources?timeCost:0;
                  var _loc1_:BaseTransactionLogEvent = new BaseTransactionLogEvent("build",rocketPad.type,rocketPad.level,_loc2_,_loc3_,timeCost,goldCost,costs.r1,costs.r2,costs.r3,costs.r4,costs.uraniumCurrency,compid.toString());
                  class_223.sendThroughJavaScript(_loc1_);
               });
            }
            else
            {
               GLOBAL.createMessagePopup(BPResourceManager.getString("bp-flash","entities_buildingrocketpad_notenoughresources"));
            }
         }
         else
         {
            GLOBAL.createMessagePopup(result.errorMessage);
         }
      }
      
      public function speedUpRocketBuild(param1:int, param2:Boolean = true) : void
      {
         playConstructionSound();
         catchUp(1);
         updateFoundation();
         var _loc4_:RocketInventoryManager = GLOBAL.rocketInventory;
         var _loc3_:class_301 = _loc4_.getBuildingRocket();
         _loc4_.updateRocket(_loc3_.id,GlobalProperties.gameTime + rocketBuildTimeRemaining);
      }
      
      public function cancelRocketBuildConfirmation() : void
      {
      }
      
      public function cancelRocketBuild(param1:Boolean, param2:Boolean) : void
      {
         var _loc5_:* = null;
         var _loc7_:* = null;
         var _loc6_:class_301 = GLOBAL.rocketInventory.getBuildingRocket();
         var _loc4_:IOShipComponent = ComponentManager.getInstance().getComponent(_loc6_.itemCode);
         var _loc9_:IOBuildingCosts = _loc4_.costs;
         if(param1)
         {
            _loc5_ = _loc9_;
            if(rocketBuildTimeRemaining < (this.rocketStartTime - this.rocketEndTime) / 3)
            {
               _loc5_ = _loc9_.clone();
               _loc5_.multiply(0.9);
            }
            _loc7_ = new ResourceLogEvent("cancel",_type.toString(),level.toString(),_loc4_.id.toString(),_loc5_.r1,_loc5_.r2,_loc5_.r3,_loc5_.r4,_loc5_.uraniumCurrency,BASE.oil,BASE.metal,BASE.energy,BASE.zynthium,Player.getInstance().currentUranium,{});
            class_223.sendThroughJavaScript(_loc7_);
            BASE.fund(1,_loc5_.r1,true);
            BASE.fund(2,_loc5_.r2,true);
            BASE.fund(3,_loc5_.r3,true);
            BASE.fund(4,_loc5_.r4,true);
            GLOBAL.debugRequestToSave.push("RocketLaunchPad.cancelRocketBuild");
            BASE.save();
         }
         var _loc8_:int = rocketBuildTimeRemaining;
         var _loc10_:int = getBuildTime(_loc4_.id);
         var _loc3_:BaseTransactionLogEvent = new BaseTransactionLogEvent("rocketbuilt",this.type,this.level,"cancel",_loc8_,_loc10_,0,_loc9_.r1,_loc9_.r2,_loc9_.r3,_loc9_.r4,_loc9_.uraniumCurrency,_loc4_.id.toString());
         class_223.sendThroughJavaScript(_loc3_);
         if(param2)
         {
            GLOBAL.rocketInventory.scrapRocket(_loc6_.id);
         }
         BaseManager.getInstance().activityQueue.removeActivity("rock" + _id);
      }
      
      public function scrapRocket(param1:int, param2:int = -1) : void
      {
         var _loc7_:* = 0;
         var _loc5_:class_301 = GLOBAL.rocketInventory.getRocket(param1);
         if(!_loc5_)
         {
            return;
         }
         var _loc4_:IOShipComponent = ComponentManager.getInstance().getComponent(_loc5_.itemCode);
         if(!_loc4_)
         {
            return;
         }
         var _loc6_:IOBuildingCosts = _loc4_.costs.clone();
         _loc6_.multiply(0.75);
         var _loc3_:String = "";
         _loc7_ = 1;
         while(_loc7_ < 5)
         {
            if(_loc6_["r" + _loc7_])
            {
               _loc3_ = _loc3_ + ("<br><font color =\'#FFFFFF\'>" + GLOBAL.getResourceName(_loc7_) + "</font>: <font color = \'#FFFF00\'>" + GLOBAL.formatNumber(_loc6_["r" + _loc7_]) + "</font>");
            }
            _loc7_++;
         }
         GLOBAL.createMessagePopup(class_295.applyTemplateToKey("entities_buildingrocketpad_scrap_confirmation",{
            "compName":_loc4_.fullName,
            "resources":_loc3_
         }),param2,BPResourceManager.getString("bp-flash","entities_buildingrocketpad_button_scraprocket"),scrapRocketB,[param1,true],BPResourceManager.getString("bp-flash","entities_buildingrocketpad_title_areyousure"));
      }
      
      public function scrapRocketB(param1:int, param2:Boolean = false) : void
      {
         var _loc4_:class_301 = GLOBAL.rocketInventory.getRocket(param1);
         var _loc3_:IOShipComponent = ComponentManager.getInstance().getComponent(_loc4_.itemCode);
         var _loc5_:IOBuildingCosts = _loc3_.costs.clone();
         _loc5_.multiply(0.75);
         BASE.refundCosts(_loc5_);
         GLOBAL.rocketInventory.scrapRocket(_loc4_.id,updateRocketPad,updateRocketPad);
      }
      
      public function updateRocketPad() : void
      {
         showHideRocket();
         class_173.tick();
      }
      
      override protected function processAccruedNonfunctionalTime() : void
      {
         var _loc1_:* = null;
         if(GLOBAL.rocketInventory.initialized)
         {
            _loc1_ = GLOBAL.rocketInventory.getBuildingRocket();
            if(_loc1_ != null)
            {
               GLOBAL.rocketInventory.updateRocket(_loc1_.id,_loc1_.completeTime + accruedNonFunctionalTime);
            }
            super.processAccruedNonfunctionalTime();
         }
      }
      
      override public function catchUp(param1:int) : void
      {
         super.catchUp(param1);
         class_321.catchUp(this,GlobalProperties.gameTime + var_37);
         if(GLOBAL.rocketInventory.initialized && GLOBAL.rocketInventory.getBuildingRocket() == null)
         {
            BaseManager.getInstance().activityQueue.removeActivity("rock" + _id);
         }
      }
      
      override public function export() : Object
      {
         var _loc1_:Object = super.export();
         if(rocketStartTime)
         {
            _loc1_.crS = rocketStartTime;
         }
         return _loc1_;
      }
      
      override public function setup(param1:Object) : void
      {
         super.setup(param1);
         setupRocketBuildTime();
         GLOBAL.rocketInventory.addEventListener("updated",setupRocketBuildTime);
      }
      
      public function setupRocketBuildTime(param1:RocketInventoryUpdateEvent = null) : void
      {
         var _loc2_:* = null;
         var _loc3_:class_301 = GLOBAL.rocketInventory.getBuildingRocket();
         if(_loc3_)
         {
            _loc2_ = ComponentManager.getInstance().getComponent(_loc3_.itemCode);
            if(rocketStartTime > 0 && _loc2_)
            {
               BaseManager.getInstance().activityQueue.addActivity("rock" + _id,this,12);
            }
         }
      }
      
      override public function get upgradeDescription() : String
      {
         if(level < _buildingProps.costs.length)
         {
            return class_295.applyTemplateToKey("entities_buildingrocketpad_upgradedescription") + upgradeSlotsDescription;
         }
         return super.upgradeDescription;
      }
      
      private function postLoadInit(param1:Event = null) : void
      {
         evt = param1;
         var currentDisplay:BuildingDisplay = _displayController.currentDisplay;
         if(null == currentDisplay)
         {
            return;
         }
         if(currentDisplay.isLoaded)
         {
            initFinished();
         }
         else
         {
            _displayController.currentDisplay.addEventListener("loaded",function(param1:BuildingDisplayEvent):void
            {
               param1.target.removeEventListener("loaded",arguments.callee);
               if(null == _displayController)
               {
                  return;
               }
               initFinished();
            });
         }
      }
      
      private function initFinished() : void
      {
         positionRocketLayer();
         var_1861 = true;
         setupRocket();
      }
      
      private function positionRocketLayer() : void
      {
         var _loc1_:Vector.<AnimatedBuildingLayer> = getCustomLayers();
         var _loc4_:* = 0;
         var _loc3_:* = _loc1_;
         for each(var _loc2_ in _loc1_)
         {
            _loc2_.gotoAndStop(1);
            if("deck2" == _loc2_.label)
            {
               var_416.view.x = _loc2_.view.x + _loc2_.view.width - 28;
               var_416.view.y = _loc2_.view.y + 10;
            }
         }
      }
      
      private function setRocketInventoryItem(param1:class_301) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         if(param1)
         {
            _loc3_ = param1.itemCode;
            _loc2_ = "rocket_" + _loc3_;
            var_416.loadRocket(_loc2_);
         }
      }
      
      public function finishRocket(param1:int) : void
      {
         BaseManager.getInstance().activityQueue.removeActivity("rock" + _id);
         showHideRocket();
         GLOBAL.const_16.sendMetricUpdate("rocket_built","inc",1,{"compID":param1});
         class_173.showRocketComplete(param1);
         var _loc3_:IOShipComponent = ComponentManager.getInstance().getComponent(param1);
         var _loc5_:IOBuildingCosts = _loc3_.costs;
         var _loc4_:int = rocketBuildTimeRemaining;
         var _loc6_:int = getBuildTime(_loc3_.id);
         var _loc2_:BaseTransactionLogEvent = new BaseTransactionLogEvent("rocketbuilt",this.type,this.level,"complete",_loc4_,_loc6_,0,_loc5_.r1,_loc5_.r2,_loc5_.r3,_loc5_.r4,_loc5_.uraniumCurrency,_loc3_.id.toString());
         class_223.sendThroughJavaScript(_loc2_);
      }
      
      public function setupRocket() : void
      {
         var _loc1_:class_301 = GLOBAL.rocketInventory.getCurrentRocket();
         if(_loc1_)
         {
            setRocketInventoryItem(_loc1_);
         }
         showHideRocket();
      }
      
      private function getCustomLayers() : Vector.<AnimatedBuildingLayer>
      {
         if(null == _displayController || null == _displayController.currentDisplay)
         {
            return new Vector.<AnimatedBuildingLayer>();
         }
         var _loc1_:Vector.<AnimatedBuildingLayer> = new Vector.<AnimatedBuildingLayer>();
         var _loc2_:Vector.<class_162> = _displayController.currentDisplay.topLayers;
         var _loc5_:* = 0;
         var _loc4_:* = _loc2_;
         for each(var _loc3_ in _loc2_)
         {
            if(_loc3_ is AnimatedBuildingLayer && -1 != const_275.indexOf(AnimatedBuildingLayer(_loc3_).label))
            {
               _loc1_.push(_loc3_);
            }
         }
         return _loc1_;
      }
      
      override protected function displayChangeHandler(param1:BuildingDisplayControllerEvent) : void
      {
         positionRocketLayer();
         updateRocketVisibility();
         super.displayChangeHandler(param1);
      }
      
      private function updateRocketVisibility() : void
      {
         var_416.view.visible = getState() == "Normal";
      }
   }
}
