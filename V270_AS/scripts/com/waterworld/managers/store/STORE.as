package com.waterworld.managers.store
{
   import com.kixeye.logging.KXLogger;
   import com.waterworld.core.GlobalProperties;
   import com.waterworld.core.BASE;
   import package_10.BaseManager;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.utils.class_295;
   import com.waterworld.entities.BuildingFoundation;
   import com.waterworld.entities.ShipDock;
   import com.waterworld.entities.ShipYard;
   import com.waterworld.entities.BuildingGenericResearch;
   import com.waterworld.entities.DefensivePlatform;
   import com.waterworld.entities.RocketLaunchPad;
   import com.waterworld.core.PurchaseManager;
   import com.waterworld.managers.popups.POPUPS;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.javascript.class_46;
   import package_11.class_22;
   import package_11.StoreEvent;
   import com.waterworld.managers.tutorial.TutorialRunner;
   import com.waterworld.managers.store.storeitem.StoreItem;
   import com.kixeye.popups.PopupManager;
   import package_45.class_312;
   import com.waterworld.ui.class_68;
   import com.waterworld.managers.update.UpdateManager;
   import com.kixeye.utils.json.ActionJSON;
   import package_108.AbstractRemoteProcedureCall;
   import com.kixeye.logging.class_72;
   
   public class STORE extends Object
   {
      
      public static const const_1293:Number = 5.555555555555556E-4;
      
      public static const const_3872:Number = 0.1;
      
      public static const const_1671:Number = 0.1;
      
      public static const const_2604:int = 300;
      
      public static const const_3887:uint = 3;
      
      public static const const_3956:int = 0;
      
      public static const const_4277:String = "StorePopup";
      
      public static const const_4389:String = "Shipdock";
      
      public static const const_1095:String = "ContextMenu";
      
      public static const const_730:String = "ResearchButtonSpeedup";
      
      private static var _log:KXLogger = class_72.getLoggerForClass(STORE);
      
      public static var var_283:Boolean;
      
      public static var var_104:Object;
      
      public static var var_146:Object;
      
      public static var var_879:String;
      
      public static var var_2855:Number;
      
      private static var var_5189:String;
      
      private static var var_2497:Function;
      
      private static var var_2142:int = -1;
      
      private static var var_932:Function;
      
      private static var var_1165:Array;
      
      private static var var_1342:Boolean = false;
      
      private static var var_1230:String;
      
      private static var var_201:Object;
      
      private static var var_5316:Number = 0;
      
      {
         _log = class_72.getLoggerForClass(STORE);
      }
      
      public function STORE()
      {
         super();
      }
      
      public static function data(param1:Object, param2:Object) : void
      {
         var_104 = param1;
         var _loc5_:* = 0;
         var _loc4_:* = var_104;
         for each(var _loc3_ in var_104)
         {
            _loc3_.unitCost = _loc3_.cost[0];
         }
         var_146 = param2;
         initStoreItems();
         processPurchases();
      }
      
      public static function currencyForCost(param1:int) : String
      {
         if(GlobalProperties.currency == "gold")
         {
            return "gold";
         }
         if(BASE.credits >= param1)
         {
            return "gold";
         }
         return "fbc";
      }
      
      public static function initStoreItems() : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc1_:* = 0;
         var _loc2_:* = null;
         StoreManager.getInstance().refreshStoreGroupings();
         _loc4_ = 1;
         while(_loc4_ <= 4)
         {
            _loc1_ = BaseManager.getInstance().getResourceMaxCapacity(_loc4_) * 0.1;
            _loc3_ = var_104["BR" + _loc4_ + "1"];
            _loc3_.title = GLOBAL.formatNumber(_loc1_) + " extra " + GLOBAL.getResourceName(_loc4_) + ".";
            if(BaseManager.getInstance().getResource(_loc4_) + BaseManager.getInstance().getResourceMaxCapacity(_loc4_) * 0.1 < BaseManager.getInstance().getResourceMaxCapacity(_loc4_))
            {
               _loc3_.cost = [costForResources(_loc1_)];
               _loc3_.description = class_295.applyTemplateToKey("store_item_description",{
                  "resource":GLOBAL.getResourceName(_loc4_),
                  "amount":GLOBAL.formatNumber(BaseManager.getInstance().getResource(_loc4_) + _loc1_)
               });
               _loc3_.quantity = _loc1_;
            }
            else
            {
               _loc3_.description = class_295.applyTemplateToKey("store_item_description_noroom",{"resource":GLOBAL.getResourceName(_loc4_)});
               _loc3_.cost = [0];
               _loc3_.quantity = 0;
            }
            _loc1_ = BaseManager.getInstance().getResourceMaxCapacity(_loc4_) * 0.5;
            _loc3_ = var_104["BR" + _loc4_ + "2"];
            _loc3_.title = class_295.applyTemplateToKey("store_item_title",{
               "amount":GLOBAL.formatNumber(_loc1_),
               "resource":GLOBAL.getResourceName(_loc4_)
            });
            if(BaseManager.getInstance().getResource(_loc4_) + BaseManager.getInstance().getResourceMaxCapacity(_loc4_) * 0.5 < BaseManager.getInstance().getResourceMaxCapacity(_loc4_))
            {
               _loc3_.cost = [costForResources(_loc1_)];
               _loc3_.description = class_295.applyTemplateToKey("store_item_description_fifty",{
                  "resource":GLOBAL.getResourceName(_loc4_),
                  "amount":GLOBAL.formatNumber(BaseManager.getInstance().getResource(_loc4_) + _loc1_)
               });
               _loc3_.quantity = _loc1_;
            }
            else
            {
               _loc3_.description = class_295.applyTemplateToKey("store_item_description_noroom_fifty",{"resource":GLOBAL.getResourceName(_loc4_)});
               _loc3_.cost = [0];
               _loc3_.quantity = 0;
            }
            _loc3_ = var_104["BR" + _loc4_ + "3"];
            _loc3_.title = class_295.applyTemplateToKey("store_item_title_full",{"resource":GLOBAL.getResourceName(_loc4_)});
            if(BaseManager.getInstance().getResourceMaxCapacity(_loc4_) > BaseManager.getInstance().getResource(_loc4_))
            {
               _loc1_ = BaseManager.getInstance().getResourceMaxCapacity(_loc4_) - BaseManager.getInstance().getResource(_loc4_);
               _loc3_.cost = [costForResources(_loc1_)];
               _loc3_.description = class_295.applyTemplateToKey("store_item_description_full",{
                  "amount":GLOBAL.formatNumber(_loc1_),
                  "resource":GLOBAL.getResourceName(_loc4_)
               });
               _loc3_.quantity = _loc1_;
            }
            else
            {
               _loc3_.description = class_295.applyTemplateToKey("store_item_description_noroom_full",{"resource":GLOBAL.getResourceName(_loc4_)});
               _loc3_.cost = [0];
               _loc3_.quantity = 0;
            }
            _loc4_++;
         }
         if(GLOBAL.selectedBuilding)
         {
            _loc2_ = GLOBAL.selectedBuilding;
            if(_loc2_.buildingRepairTimeRemaining > 0)
            {
               var_104.SP4.cost = [costForTime(_loc2_.buildingRepairTimeRemaining)];
            }
            else if(_loc2_.buildTimeRemaining > 0)
            {
               var_104.SP4.cost = [costForTime(_loc2_.buildTimeRemaining)];
            }
            else if(_loc2_ is ShipDock && var_879 == "Shipdock" || ShipDock(_loc2_).repairTimeRemainingTotal > 0 && _loc2_.designBuildTimeRemaining == 0 && _loc2_.upgradeTimeRemaining == 0 && _loc2_.upgradeFortificationTimeRemaining == 0)
            {
               var_104.SP4.cost = [costForTime((_loc2_ as ShipDock).repairTimeRemainingTotal)];
            }
            else if(_loc2_.designBuildTimeRemaining > 0)
            {
               var_104.SP4.cost = [costForTime(_loc2_.designBuildTimeRemaining)];
            }
            else if(_loc2_.upgradeTimeRemaining > 0 && var_879 != "Shipdock")
            {
               var_104.SP4.cost = [costForTime(_loc2_.upgradeTimeRemaining)];
            }
            else if(_loc2_.upgradeFortificationTimeRemaining > 0 && var_879 != "Shipdock")
            {
               var_104.SP4.cost = [costForTime(_loc2_.upgradeFortificationTimeRemaining)];
            }
            else if(_loc2_.type == 5)
            {
               var_104.SP4.cost = [costForTime((_loc2_ as ShipYard).shipBuildTimeRemaining)];
            }
            else if(_loc2_ is BuildingGenericResearch)
            {
               var_104.SP4.cost = [costForTime((_loc2_ as BuildingGenericResearch).researchTimeRemaining)];
            }
            else if(_loc2_ is DefensivePlatform)
            {
               var_104.SP4.cost = [costForTime(_loc2_.speedUpTimeRemaining)];
            }
            else if(_loc2_ is RocketLaunchPad)
            {
               var_104.SP4.cost = [costForTime(_loc2_.speedUpTimeRemaining)];
            }
         }
      }
      
      public static function costForResources(param1:Number) : int
      {
         var param1:Number = Math.sqrt(param1 * 0.5);
         param1 = Math.pow(param1,0.75);
         param1 = Math.ceil(param1 * 0.1);
         return param1;
      }
      
      public static function costForVXP(param1:Number, param2:uint = 1) : int
      {
         var _loc3_:Number = param2 == 1?0.1:0.1;
         return Math.ceil(param1 * _loc3_);
      }
      
      public static function costForTime(param1:Number) : int
      {
         if(param1 < 300)
         {
            return 0;
         }
         return Math.ceil(param1 * 5.555555555555556E-4);
      }
      
      public static function show(param1:String, param2:String = null, param3:Function = null, param4:int = -1, param5:Array = null) : void
      {
         var _loc6_:* = null;
         var_879 = param2;
         var_2497 = param3;
         if(GLOBAL.baseMode == "build")
         {
            if(!open)
            {
               if(GLOBAL.selectedBuilding && (GLOBAL.selectedBuilding._moving || !(GLOBAL.selectedBuilding is ShipDock) && !(GLOBAL.selectedBuilding is RocketLaunchPad) && GLOBAL.selectedBuilding.speedUpTimeRemaining == 0 && !GLOBAL.selectedBuilding.isRepairing && !GLOBAL.selectedBuilding.designBuildEndTime))
               {
                  BASE.buildingDeselect();
               }
               var_2142 = new StoresPopup(param4,param5,param1).id;
               if(GLOBAL.newBuilding)
               {
                  GLOBAL.newBuilding.cancel();
               }
            }
            _loc6_ = getPopup();
            if(_loc6_ != null)
            {
               _loc6_.refreshCategory();
            }
         }
      }
      
      private static function update() : void
      {
         var _loc1_:StoresPopup = getPopup();
         if(_loc1_)
         {
            _loc1_.update();
         }
      }
      
      public static function hide() : void
      {
         var_2497 = null;
         var_932 = null;
         var_1165 = null;
         var _loc1_:StoresPopup = getPopup();
         if(_loc1_)
         {
            _loc1_.hide();
         }
      }
      
      public static function get open() : Boolean
      {
         return null != getPopup();
      }
      
      public static function get canBuy() : Boolean
      {
         return !(!BASE.canSave || PurchaseManager.hasPendingPurchase() || var_283);
      }
      
      public static function buy(param1:String) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = false;
         if(canBuy || param1 == "SP1")
         {
            var_1342 = !(param1 == "SP1" || param1 == "SP4");
            _loc3_ = var_104[param1];
            _loc2_ = _loc3_.cost;
            _loc4_ = _loc2_[0];
            if(BASE.credits < _loc4_ && GlobalProperties.currency == "fbc")
            {
               _loc5_ = true;
            }
            if(var_146[param1] && !_loc3_.inf)
            {
               _loc4_ = _loc2_[var_146[param1].q];
            }
            if(_loc5_)
            {
               facebookCreditPurchase(param1,_loc4_,null);
            }
            else if(BASE.credits >= _loc4_)
            {
               buyB(param1);
            }
            else
            {
               POPUPS.getInstance().showNoMoney();
            }
         }
      }
      
      public static function buyB(param1:String, param2:Boolean = true) : void
      {
         var _loc9_:* = 0;
         var _loc14_:* = null;
         var _loc11_:* = false;
         var _loc19_:* = 0;
         var _loc6_:* = null;
         var _loc13_:* = 0;
         var _loc7_:* = null;
         var _loc4_:* = null;
         var _loc8_:* = null;
         var _loc3_:* = null;
         var _loc10_:* = null;
         var _loc12_:* = null;
         var _loc17_:Object = var_104[param1];
         var _loc18_:int = _loc17_.quantity;
         _loc14_ = _loc17_.cost;
         _loc9_ = _loc14_[0];
         _loc11_ = !((BASE.credits >= _loc9_ || GlobalProperties.currency != "fbc") && param2);
         if(var_146[param1] && !_loc17_.inf)
         {
            _loc9_ = _loc14_[var_146[param1].q];
         }
         if(var_146[param1] && var_146[param1].q >= _loc17_.cost.length && !_loc17_.inf)
         {
            GLOBAL.createMessagePopup(BPResourceManager.getString("bp-flash","store_alreadyhave_message"));
            return;
         }
         var _loc16_:int = _loc17_.quantity;
         if(_loc16_ == 0)
         {
            _loc16_ = 1;
         }
         if(param1.substr(0,2) == "BR" || param1 == "SP4")
         {
            _loc16_ = _loc9_;
         }
         var _loc5_:* = _loc16_;
         if(!_loc11_)
         {
            BASE.addCredits(-_loc9_);
         }
         if(GlobalProperties.currency == "fbc")
         {
            class_46.CallJS("cc.fbcGetBalance");
         }
         if(param1.substr(0,2) == "BR")
         {
            BASE.fund(param1.substr(2,1),_loc18_);
            BASE.pointsAdd(_loc18_,"resource",{"source":"STORE.BuyB.quantity"});
            GLOBAL.debugRequestToSave.push("STORE.BuyB");
            BASE.save();
         }
         if(param1.substr(0,2) == "SP")
         {
            _loc6_ = GLOBAL.selectedBuilding;
            _loc13_ = 0;
            if(param1.substr(2,1) == "1")
            {
               _loc13_ = 300;
            }
            if(param1.substr(2,1) == "2")
            {
               _loc13_ = 1800;
            }
            if(param1.substr(2,1) == "3")
            {
               _loc13_ = 3600;
            }
            _loc7_ = "";
            if(_loc6_.isRepairing || _loc6_.hp < _loc6_.hpMax)
            {
               _loc19_ = 0;
               _loc7_ = "buildingRepair";
               if(!_loc6_.isRepairing)
               {
                  _loc6_.repair();
               }
               if(_loc6_.buildingRepairTimeRemaining > 0 && param1.substr(2,1) == "4")
               {
                  _loc19_ = 1;
                  _loc13_ = _loc6_.buildingRepairTimeRemaining;
                  _loc6_.repairSpeedUp(_loc13_);
               }
               else
               {
                  _loc6_.repairSpeedUp(_loc13_);
               }
            }
            else if(_loc6_.buildTimeRemaining)
            {
               _loc19_ = 0;
               _loc7_ = "buildingConstruction";
               if(_loc6_.buildTimeRemaining > 0 && param1.substr(2,1) == "4")
               {
                  _loc19_ = 1;
                  _loc13_ = _loc6_.buildTimeRemaining;
                  _loc6_.buildSpeedUp(_loc13_);
               }
               else
               {
                  _loc6_.buildSpeedUp(_loc13_);
               }
            }
            else if(_loc6_.upgradeTimeRemaining && var_879 != "Shipdock")
            {
               _loc7_ = "buildingUpgrade";
               _loc19_ = 0;
               if(_loc6_.upgradeTimeRemaining > 0 && param1.substr(2,1) == "4")
               {
                  _loc19_ = 1;
                  _loc13_ = _loc6_.upgradeTimeRemaining;
                  _loc6_.upgradeSpeedUp(_loc13_);
               }
               else
               {
                  _loc6_.upgradeSpeedUp(_loc13_);
               }
            }
            else if(_loc6_.upgradeFortificationTimeRemaining && var_879 != "Shipdock")
            {
               _loc7_ = "buildingFortificationUpgrade";
               _loc19_ = 0;
               if(_loc6_.upgradeFortificationTimeRemaining > 0 && param1.substr(2,1) == "4")
               {
                  _loc19_ = 1;
                  _loc13_ = _loc6_.upgradeFortificationTimeRemaining;
                  _loc6_.upgradeFortificationSpeedUp(_loc13_);
               }
               else
               {
                  _loc6_.upgradeFortificationSpeedUp(_loc13_);
               }
            }
            else if(_loc6_.type == 5)
            {
               _loc19_ = 0;
               _loc7_ = "shipConstruction";
               _loc4_ = _loc6_ as ShipYard;
               if(_loc4_.shipBuildTimeRemaining > 0)
               {
                  if(param1.substr(2,1) == "4")
                  {
                     _loc19_ = 1;
                     _loc13_ = _loc4_.shipBuildTimeRemaining;
                     _loc4_.shipBuildSpeedUp(_loc13_);
                  }
                  else
                  {
                     _loc4_.shipBuildSpeedUp(_loc13_);
                  }
               }
            }
            else if(_loc6_ is BuildingGenericResearch)
            {
               _loc19_ = 0;
               _loc8_ = _loc6_ as BuildingGenericResearch;
               _loc7_ = "research";
               if(_loc8_.researchTimeRemaining > 0)
               {
                  if(param1.substr(2,1) == "4")
                  {
                     _loc19_ = 1;
                     _loc13_ = _loc8_.researchTimeRemaining;
                     _loc8_.researchSpeedUp(_loc13_);
                  }
                  else
                  {
                     _loc8_.researchSpeedUp(_loc13_);
                  }
               }
            }
            else if(_loc6_ is RocketLaunchPad)
            {
               _loc19_ = 0;
               _loc7_ = "launchPad";
               _loc3_ = RocketLaunchPad(_loc6_);
               if(_loc3_.rocketBuildTimeRemaining > 0)
               {
                  if(param1.substr(2,1) == "4")
                  {
                     _loc19_ = 1;
                     _loc13_ = _loc3_.rocketBuildTimeRemaining;
                     _loc3_.speedUpRocketBuild(_loc13_);
                  }
                  else
                  {
                     _loc3_.speedUpRocketBuild(_loc13_);
                  }
               }
            }
            else if(_loc6_.type == 7)
            {
               _loc10_ = _loc6_ as ShipDock;
               _loc7_ = "fleetRepair";
               if(param1.substr(2,1) == "4")
               {
                  _loc13_ = _loc10_.repairTimeRemainingTotal;
                  _loc10_.repairFleetSpeedUp(_loc13_);
               }
               else
               {
                  _loc10_.repairFleetSpeedUp(_loc13_);
               }
            }
            else if(_loc6_.type == 40)
            {
               _loc7_ = "turretConstruction";
               _loc12_ = _loc6_ as DefensivePlatform;
               if(param1.substr(2,1) == "4")
               {
                  _loc13_ = _loc12_.turretBuildTimeRemaining;
                  _loc12_.turretBuildSpeedUp(_loc13_);
               }
               else
               {
                  _loc12_.turretBuildSpeedUp(_loc13_);
               }
            }
         }
         _loc16_ = 1;
         if(_loc17_.inf)
         {
            _loc16_ = _loc18_;
         }
         if(var_146[param1])
         {
            var_146[param1].q = var_146[param1].q + _loc16_;
            if(_loc17_.duration > 0)
            {
               var_146[param1].s = GlobalProperties.gameTime;
               var_146[param1].e = GlobalProperties.gameTime + _loc17_.duration;
            }
         }
         else
         {
            var_146[param1] = {"q":_loc16_};
            if(_loc17_.duration > 0)
            {
               var_146[param1].s = GlobalProperties.gameTime;
               var_146[param1].e = GlobalProperties.gameTime + _loc17_.duration;
            }
         }
         BASE.calcResources();
         processPurchases();
         if(param1 == "BIP")
         {
            BASE.calcResources();
         }
         if(_loc11_)
         {
            GLOBAL.debugRequestToSave.push("STORE.BuyB");
            BASE.save(0,true);
         }
         else
         {
            PurchaseManager.purchase(param1,_loc5_,"store");
         }
         var _loc15_:StoresPopup = getPopup();
         if(_loc17_.autoclose)
         {
            hide();
         }
         else if(_loc17_ && _loc15_)
         {
            _loc15_.refreshCategory();
         }
         if(var_2497 != null)
         {
            var_2497();
         }
         buyC(param1,_loc9_);
         var_2855 = 0;
         class_22.instance.dispatchEvent(new StoreEvent("purchasecomplete",param1));
      }
      
      public static function buyC(param1:String, param2:int) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         if(param1.lastIndexOf("PRO") != -1 && !TutorialRunner.getInstance().isTutorialActive)
         {
            _loc4_ = [BPResourceManager.getString("bp-flash","store_time_24hours"),BPResourceManager.getString("bp-flash","store_time_7days"),BPResourceManager.getString("bp-flash","store_time_28days")][param1.substr(3,1) - 1];
            POPUPS.getInstance().showDPPurchased(_loc4_);
         }
         else if((param2 > 0 && GlobalProperties.currency != "fbc" || var_1342) && !TutorialRunner.getInstance().isTutorialActive)
         {
            _loc3_ = var_104[param1].title;
            if(_loc3_.charAt(_loc3_.length - 1) == ".")
            {
               _loc3_ = _loc3_.substr(0,_loc3_.length - 1);
            }
            GLOBAL.createMessagePopup(class_295.applyTemplateToKey("store_receipt_message",{"content":(var_1230?var_1230:_loc3_)}));
         }
         var_1342 = false;
         var_1230 = null;
      }
      
      public static function purchaseNew(param1:StoreItem) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc2_:int = PopupManager.getInstance().currentParentId;
         if(param1.requireRealCurrency)
         {
            class_312.const_7.showFBPurchaseScreen(param1);
            return;
         }
         if(currencyForCost(param1.cost) == "gold" && !StoreItem(param1).isFree && !class_312.const_7.canAffordCost(param1.cost))
         {
            class_312.const_7.showCurrencyTopoffOptions(param1);
            return;
         }
         if(!canBuy && !StoreItem(param1).isFree)
         {
            GLOBAL.createMessagePopup(BPResourceManager.getString("bp-flash","store_basebusy_message"),_loc2_);
            return;
         }
         var_1230 = "";
         if(GLOBAL.flagManager.getFlagInt("blockrespurch") > 0)
         {
            GLOBAL.createMessagePopup(BPResourceManager.getString("bp-flash","store_disabled_message"),_loc2_);
            return;
         }
         if(param1.isFree)
         {
            param1.applyFree();
         }
         else if(currencyForCost(param1.cost) == "fbc")
         {
            class_68.showTransparent();
            var_283 = true;
            _loc3_ = param1.exportHashed();
            if(GLOBAL.ROOT.stage.displayState != "normal")
            {
               GLOBAL.toggleFullScreen();
            }
            class_46.CallJS("cc.fbcBuyItem",[_loc3_]);
            UpdateManager.getInstance().startPollingForUpdates();
         }
         else
         {
            _loc4_ = param1.getAnalyticsData();
            BASE.blockSave = true;
            param1.applyGold();
            BASE.blockSave = false;
            PurchaseManager.purchaseGold(param1.storeCode,param1.goldQuantity,_loc4_);
            param1.postGoldPurchase();
         }
      }
      
      public static function purchase(param1:String, param2:int = 0, param3:Function = null, param4:Array = null, param5:Object = null, param6:Boolean = false, param7:Boolean = true) : void
      {
         if(!canBuy)
         {
            GLOBAL.createMessagePopup(BPResourceManager.getString("bp-flash","store_basebusy_message"));
            return;
         }
         var_1230 = "";
         var _loc9_:Object = var_104[param1];
         var _loc10_:Boolean = BASE.credits < param2 || GlobalProperties.currency == "fbc";
         var _loc8_:Boolean = param1 == "RTOPUP" || param1 == "IUP" || param1 == "IFUP" || param1 == "ISHIP" || param1 == "IREP" || param1 == "IRES" || param1 == "ITUR" || param1 == "IRANK" || param1 == "IROC" || param1 == "RENAME" || param1 == "IBLUEPRINT";
         if(GLOBAL.flagManager.getFlagInt("blockrespurch") > 0 && _loc8_)
         {
            GLOBAL.createMessagePopup(BPResourceManager.getString("bp-flash","store_disabled_message"));
            return;
         }
         if(param5.title)
         {
            var_1230 = param5.title;
         }
         if(_loc9_ && !_loc8_)
         {
            if(_loc10_ && BASE.credits < param2)
            {
               facebookCreditPurchase(param1,param2,param5);
               var_932 = param3;
               var_1165 = param4;
            }
            else
            {
               buy(param1);
            }
         }
         else if(_loc10_ && BASE.credits < param2 || param6)
         {
            var_932 = param3;
            var_1165 = param4;
            facebookCreditPurchase(param1,param2,param5);
         }
         else if(BASE.credits >= param2)
         {
            if(param3 != null)
            {
               if(param4)
               {
                  param3(param4);
               }
               else
               {
                  param3();
               }
            }
            PurchaseManager.purchase(param1,param2,"store");
         }
      }
      
      public static function facebookCreditPurchase(param1:String, param2:int, param3:Object) : void
      {
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc8_:* = null;
         var _loc7_:* = false;
         try
         {
            _loc6_ = var_104[param1];
            _loc4_ = "";
            _loc5_ = "";
            var_201 = {
               "itemid":param1,
               "cost":param2
            };
            if(_loc6_)
            {
               _loc4_ = _loc6_.title;
               _loc5_ = _loc6_.description;
               if(param3)
               {
                  if(param3.description)
                  {
                     _loc5_ = param3.description;
                  }
                  if(param3.title)
                  {
                     _loc4_ = param3.title;
                  }
                  var_201.quantity = param3.quantity;
                  var_201.referrer = param3.referrer;
               }
               else
               {
                  var_201.store = true;
               }
            }
            _loc8_ = ActionJSON.encodeJSON(AbstractRemoteProcedureCall.getHashedObject("Y9U653YU641VUU3U1U6Z497075076655",[["itemid",param1],["callback","fbcBuyItem"],["cost",param2],["title",_loc4_],["description",_loc5_]]));
            var_5189 = param1;
         }
         catch(e:Error)
         {
            _log.logRemote("ERROR.STORE.FacebookCreditPurchase.A","itemCode: ",param1," cost: ",param2," purchaseProps: ",param3," error name: ",e.name," message: ",e.message," stack: ",e.getStackTrace());
            _loc7_ = true;
         }
         if(!_loc7_)
         {
            try
            {
               class_68.showTransparent();
               if(GLOBAL.ROOT.stage.displayState != "normal")
               {
                  GLOBAL.toggleFullScreen();
               }
               class_46.CallJS("cc.fbcBuyItem",[_loc8_]);
               var_283 = true;
               var_5316 = GlobalProperties.gameTime;
               return;
            }
            catch(e:Error)
            {
               _log.logRemote("ERROR.STORE.FacebookCreditPurchase.B","itemCode: ",param1," cost: ",param2," purchaseProps: ",param3," error name: ",e.name," message: ",e.message," stack: ",e.getStackTrace());
               return;
            }
         }
      }
      
      public static function set busy(param1:Boolean) : void
      {
         var_283 = param1;
      }
      
      public static function facebookCreditPurchaseB(param1:String) : void
      {
         var _loc2_:* = null;
         try
         {
            class_68.hide();
            var_283 = false;
            if(param1)
            {
               _loc2_ = ActionJSON.decodeJSON(param1,"STORE.FacebookCreditPurchaseB()");
               _log.logRemote("STATISTIC.STORE.FacebookCreditPurchaseB","Transaction callback received, transaction length: ",GlobalProperties.gameTime - var_5316," callback data: ",param1);
            }
            else
            {
               return;
            }
         }
         catch(e:Error)
         {
            _log.logRemote("ERROR.STORE.FacebookCreditPurchaseB.A","obj: ",param1," error name: ",e.name," message: ",e.message," stack: ",e.getStackTrace());
         }
         if(_loc2_.success == 1)
         {
            var_2855 = _loc2_.order_id;
            if(_loc2_.frictionless && _loc2_.frictionless == 1)
            {
               var_1342 = !(var_201 && var_201.itemid && (var_201.itemid == "SP4" || var_201.itemid == "SP1" || var_201.itemid == "IUP" || var_201.itemid == "IFUP" || var_201.itemid == "ISHIP" || var_201.itemid == "IREP" || var_201.itemid == "IRES" || var_201.itemid == "IRANK" || var_201.itemid == "RENAME" || var_201.itemid == "IROC" || var_201.itemid == "IBLUEPRINT"));
            }
            else
            {
               var_1342 = false;
            }
            try
            {
               if(var_932 != null)
               {
                  if(var_1165)
                  {
                     var_932(var_1165);
                  }
                  else
                  {
                     var_932();
                  }
               }
            }
            catch(e:Error)
            {
               _log.logRemote("ERROR.STORE.FacebookCreditPurchaseB.B","name: ",e.name," message: ",e.message," stack: ",e.getStackTrace());
            }
            if(var_201)
            {
               GLOBAL.statSet("FBCSpend",var_201.cost);
            }
            try
            {
               if(BaseManager.getInstance().isSaving)
               {
                  _log.logRemote("ERROR.STORE.FacebookCreditPurchaseB.C","Saving Problem - BASE already saving!");
               }
               buyB(var_5189,false);
               if(!BaseManager.getInstance().isSaving)
               {
                  _log.logRemote("ERROR.STORE.FacebookCreditPurchaseB.D","Save Problem - GLOBAL.halt: ",GLOBAL.halt," GLOBAL.catchup: ",GLOBAL.isCatchup," GLOBAL.baseMode: ",GLOBAL.baseMode," BASE._loading: ",BaseManager.getInstance().isLoading);
               }
            }
            catch(e:Error)
            {
               _log.logRemote("ERROR.STORE.FacebookCreditPurchaseB.E","name: ",e.name," message: ",e.message," stack: ",e.getStackTrace());
            }
         }
         else if(_loc2_.jserror)
         {
            GLOBAL.createMessagePopup(BPResourceManager.getString("bp-flash","store_error_restart"));
            _log.logRemote("ERROR.STORE.FacebookCreditPurchaseB.JSERROR","response object: ",param1);
         }
         else if(!(_loc2_.canceled && _loc2_.canceled == 1))
         {
            GLOBAL.createMessagePopup(BPResourceManager.getString("bp-flash","store_error_retry"));
            _log.logRemote("ERROR.STORE.FacebookCreditPurchaseB.F","Facebook Purchase Error!");
         }
         var_201 = null;
         var_932 = null;
         var_1165 = null;
      }
      
      public static function processPurchases() : void
      {
         update();
      }
      
      public static function checkUpgrade(param1:String) : Object
      {
         return var_146[param1];
      }
      
      public static function isShowing(param1:Class) : Boolean
      {
         return open && GLOBAL.selectedBuilding is param1;
      }
      
      private static function getPopup() : StoresPopup
      {
         return PopupManager.getInstance().getPopupById(var_2142) as StoresPopup;
      }
   }
}
