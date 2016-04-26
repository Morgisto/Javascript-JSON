package com.waterworld.managers.store.storeitem
{
   import com.kixeye.logging.KXLogger;
   import com.kixeye.logging.class_72;
   import com.waterworld.entities.BuildingFoundation;
   import com.waterworld.entities.BuildingGenericResearch;
   import com.waterworld.entities.RocketLaunchPad;
   import com.waterworld.managers.store.STORE;
   import com.waterworld.core.GLOBAL;
   import package_10.BaseManager;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.entities.ShipYard;
   import com.waterworld.datastores.IOShipDesign;
   import package_59.ShipTransactionLogEvent;
   import com.kixeye.utils.json.ActionJSON;
   import package_59.AbstractLogEvent;
   import package_59.class_223;
   import com.waterworld.entities.RetrofitLab;
   import com.waterworld.datastores.ComponentRetrofitGroup;
   import package_32.ComponentManager;
   import package_64.InventoryController;
   import com.waterworld.datastores.IOShipComponent;
   import package_97.RESEARCH;
   import com.waterworld.core.GlobalProperties;
   import com.waterworld.datastores.class_118;
   import package_59.ResearchLogEvent;
   import com.waterworld.entities.ShipDock;
   import com.waterworld.datastores.IOShip;
   import com.waterworld.entities.DefensivePlatform;
   import com.waterworld.datastores.IOBuildingCosts;
   import package_59.BaseTransactionLogEvent;
   
   public class CommonSpeedupStoreItem extends StoreItem
   {
      
      protected static const const_3164:int = 1;
      
      protected static const const_3832:int = 2;
      
      protected static const const_4522:int = 3;
      
      protected static const const_828:int = 4;
      
      protected static const const_3079:int = 5;
      
      protected static const const_2212:int = 6;
      
      protected static const const_2031:int = 7;
      
      protected static const const_2337:int = 8;
      
      protected static const const_3486:int = 9;
      
      protected static const const_2646:int = 10;
      
      private static var _log:KXLogger = class_72.getLoggerForClass(CommonSpeedupStoreItem);
      
      {
         _log = class_72.getLoggerForClass(CommonSpeedupStoreItem);
      }
      
      protected var _time:int;
      
      protected var var_117:int;
      
      protected var var_165:String;
      
      protected var var_1806:Array;
      
      public function CommonSpeedupStoreItem(param1:String)
      {
         super(param1);
      }
      
      protected function setModeFromFoundation(param1:BuildingFoundation, param2:Boolean) : void
      {
         if(param1.isRepairing || param1.hp < param1.hpMax)
         {
            var_117 = 1;
            var_165 = "buildingRepair";
         }
         else if(param1.buildTimeRemaining)
         {
            var_117 = 2;
            var_165 = "buildingConstruction";
         }
         else if(param1.upgradeTimeRemaining && !param2)
         {
            var_117 = 3;
            var_165 = "buildingUpgrade";
         }
         else if(param1.upgradeFortificationTimeRemaining && !param2)
         {
            var_117 = 4;
            var_165 = "buildingFortificationUpgrade";
         }
         else if(param1.designBuildTimeRemaining && !param2)
         {
            var_117 = 10;
            var_165 = "buildingDesignBuild";
         }
         else if(param1.type == 5)
         {
            var_117 = 5;
            var_165 = "shipConstruction";
         }
         else if(param1 is BuildingGenericResearch)
         {
            var_117 = 6;
            var_165 = "research";
         }
         else if(param1 is RocketLaunchPad)
         {
            var_117 = 7;
            var_165 = "launchPad";
         }
         else if(param1.type == 7 && param2)
         {
            var_117 = 8;
            var_165 = "fleetRepair";
         }
         else if(param1.type == 40)
         {
            var_117 = 9;
            var_165 = "turretConstruction";
         }
      }
      
      protected function isBuildingRepairingFleet(param1:BuildingFoundation) : Boolean
      {
         var _loc2_:* = false;
         if(param1.type == 7)
         {
            if((param1.isUpgrading || param1.isFortificationUpgrading || param1.isRepairing || param1.isBuilding || param1.isDesignBuilding) && STORE.var_879 != "Shipdock")
            {
               _loc2_ = false;
            }
            else
            {
               _loc2_ = true;
               if(var_57 == "SP4")
               {
                  _time = GLOBAL.bShipDock.repairTimeRemainingTotal;
               }
            }
         }
         return _loc2_;
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc19_:* = null;
         var _loc10_:* = null;
         var _loc16_:* = null;
         var _loc6_:* = 0;
         var _loc8_:* = 0;
         var _loc17_:* = null;
         var _loc23_:* = NaN;
         var _loc20_:* = NaN;
         var _loc21_:* = null;
         var _loc15_:* = 0;
         var _loc3_:* = null;
         var _loc12_:* = null;
         var _loc11_:* = null;
         var _loc9_:* = null;
         var _loc22_:* = 0;
         var _loc4_:* = null;
         var _loc13_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc18_:String = "";
         var _loc5_:BuildingFoundation = BaseManager.getInstance().getBuildingByIndex("b" + var_18);
         if(!_loc5_)
         {
            _log.logRemote("ERROR.CommonSpeedupStoreItem.doApply","Couldn\'t find building");
            return BPResourceManager.getString("bp-flash","store_speedupstoreitem_error_couldntfind");
         }
         var _loc14_:int = this.var_57 == "SP1"?_loc5_.speedUpTimeRemaining:_time;
         try
         {
            switch(this.var_117 - 1)
            {
               case 0:
                  _loc19_ = "repair";
                  _loc20_ = _loc5_.buildingRepairTimeRemaining;
                  sendBuildingTransaction(_loc19_,_loc20_,_loc5_);
                  _loc5_.repairSpeedUp(_time);
                  break;
               case 1:
                  _loc19_ = "build";
                  _loc20_ = _loc5_.buildTimeRemaining;
                  sendBuildingTransaction(_loc19_,_loc20_,_loc5_);
                  _loc5_.buildSpeedUp(_time);
                  break;
               case 2:
                  _loc19_ = "upgraded";
                  _loc20_ = _loc5_.upgradeTimeRemaining;
                  sendBuildingTransaction(_loc19_,_loc20_,_loc5_);
                  _loc5_.upgradeSpeedUp(_time);
                  break;
               case 3:
                  _loc19_ = "fortified";
                  _loc20_ = _loc5_.upgradeFortificationTimeRemaining;
                  sendBuildingTransaction(_loc19_,_loc20_,_loc5_);
                  _loc5_.upgradeFortificationSpeedUp(this._time);
                  break;
               case 4:
                  _loc16_ = ShipYard(_loc5_);
                  if(!_loc16_)
                  {
                     _log.logRemote("ERROR.CommonSpeedupStoreItem.doApply","Shipyard found to be null for ship speedup.");
                  }
                  if(_loc16_.isRefittingShip)
                  {
                     _loc19_ = this.var_57 == "SP1"?"refit_speedup_free":"refit_speedup";
                  }
                  else
                  {
                     _loc19_ = this.var_57 == "SP1"?"build_speedup_free":"build_speedup";
                  }
                  _loc6_ = _loc16_.getCurrentDesignHullId();
                  _loc8_ = _loc16_.refitShipFleetID;
                  _loc17_ = _loc16_.getCurrentDesign();
                  if(!_loc17_)
                  {
                     _log.logRemote("ERROR.CommonSpeedupStoreItem.doApply","shipDesign found to be null for ship speedup.");
                  }
                  _loc23_ = _loc16_.buildEndTime - _loc16_.buildStartTime;
                  _loc20_ = Math.max(_loc16_.speedUpTimeRemaining - _loc14_,0);
                  _loc10_ = new ShipTransactionLogEvent(_loc19_,_loc6_.toString(),_loc17_.hullID.toString(),ActionJSON.encodeJSON(_loc17_.analyticExport()),_loc17_.weight.toString(),_loc17_.armorPoints.toString(),_loc8_.toString(),_loc23_.toString(),_loc14_.toString(),_loc20_.toString());
                  _loc10_ = mutateLogData(_loc10_);
                  class_223.sendThroughJavaScript(_loc10_);
                  _loc16_.shipBuildSpeedUp(this._time);
                  break;
               case 5:
                  _loc21_ = BuildingGenericResearch(_loc5_);
                  _loc15_ = 0;
                  if(_loc21_ is RetrofitLab && _loc21_.researchID)
                  {
                     if(ComponentRetrofitGroup.isValidID(_loc21_.researchID))
                     {
                        _loc3_ = ComponentManager.getInstance().getCRGroupById(_loc21_.researchID);
                        _loc15_ = InventoryController.getInstance().getItemLevelForCompID(_loc3_.id) + 1;
                     }
                     else
                     {
                        _loc12_ = ComponentManager.getInstance().getComponent(_loc21_.researchID);
                        _loc11_ = _loc12_.prevRetrofitId.toString();
                        _loc9_ = RESEARCH.researchTime(_loc12_).toString();
                        _loc19_ = this.var_57 == "SP1"?"retrofit_speedup_free":"retrofit_speedup";
                        _loc10_ = new ShipTransactionLogEvent(_loc19_,"0",_loc11_,"","","","",_loc9_,_loc14_.toString(),(_loc21_.researchTimeRemaining - _loc14_).toString(),"",_loc11_);
                        _loc10_ = mutateLogData(_loc10_);
                        class_223.sendThroughJavaScript(_loc10_);
                     }
                  }
                  _loc22_ = _loc21_.researchEndTime - GlobalProperties.gameTime - _loc14_;
                  _loc23_ = _loc21_.researchEndTime - _loc21_.researchStartTime;
                  _loc4_ = RESEARCH.getResearchComp(_loc21_.researchID);
                  _loc13_ = _loc4_?_loc4_.type:"componentRetrofit";
                  _loc19_ = this.var_57 == "SP1"?"speedup_free":"speedup";
                  _loc10_ = new ResearchLogEvent(_loc19_,_loc21_._buildingProps.id,_loc21_.researchID,_loc13_,_loc15_,_loc22_,_loc23_,_loc14_,cost,0,0,0,0,0);
                  _loc10_ = mutateLogData(_loc10_);
                  class_223.sendThroughJavaScript(_loc10_);
                  _loc21_.researchSpeedUp(this._time);
                  break;
               case 6:
                  RocketLaunchPad(_loc5_).speedUpRocketBuild(this._time);
                  break;
               case 7:
                  _loc2_ = ShipDock(_loc5_);
                  _loc7_ = _loc2_.getShipByUID(_loc2_.repairUID);
                  if(var_57 == "SP1")
                  {
                     _loc14_ = _loc2_.repairTimeRemaining;
                  }
                  else
                  {
                     _loc14_ = _time;
                  }
                  if(var_57 == "SP1")
                  {
                     _loc19_ = "repair_speedup_free";
                  }
                  else
                  {
                     _loc19_ = "repair_speedup";
                  }
                  _loc10_ = new ShipTransactionLogEvent(_loc19_,_loc7_.id.toString(),_loc7_.hullID.toString(),ActionJSON.encodeJSON(_loc7_.analyticExport()),_loc7_.weight.toString(),_loc7_.armorPoints.toString(),_loc7_.fleetId.toString(),_loc2_.repairTimeTotalForCurrentShip.toString(),_loc14_.toString(),Math.max(_loc2_.repairTimeRemaining - _time,0).toString());
                  _loc10_ = mutateLogData(_loc10_);
                  class_223.sendThroughJavaScript(_loc10_);
                  _loc2_.repairFleetSpeedUp(this._time);
                  break;
               case 8:
                  DefensivePlatform(_loc5_).turretBuildSpeedUp(this._time);
                  break;
               case 9:
                  _loc19_ = "design_build";
                  _loc20_ = _loc5_.designBuildTimeRemaining;
                  sendBuildingTransaction(_loc19_,_loc20_,_loc5_,false);
                  _loc5_.designBuildSpeedUp(this._time);
                  break;
            }
         }
         catch(e:Error)
         {
            _loc18_ = BPResourceManager.getString("bp-flash","store_speedupstoreitem_error_generic");
            _log.logRemote("ERROR.CommonSpeedupStoreItem.doApply","Uncaught error: Error ID: " + e.errorID + ", Error name: " + e.name + ", Error message: " + e.message + ", _mode = " + this.var_117.toString());
         }
         return _loc18_;
      }
      
      protected function sendBuildingTransaction(param1:String, param2:int, param3:BuildingFoundation, param4:Boolean = true) : void
      {
         var _loc10_:* = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc9_:* = 0;
         var _loc11_:* = 0;
         var _loc5_:* = 0;
         if(param4)
         {
            _loc10_ = param3.clampedUpgradeCost();
            if(_loc10_ == null)
            {
               _log.logRemote("ERROR.CommonSpeedupStoreItem.sendBuildingTransaction","costs is null");
               return;
            }
            _loc6_ = _loc10_.r1;
            _loc7_ = _loc10_.r2;
            _loc9_ = _loc10_.r3;
            _loc11_ = _loc10_.r4;
            _loc5_ = _loc10_.uraniumCurrency;
         }
         var _loc8_:AbstractLogEvent = new BaseTransactionLogEvent(param1,param3._id,param3.level,"speedup",param2 - _time,param2,STORE.costForTime(param2),_loc6_,_loc7_,_loc9_,_loc11_,_loc5_);
         _loc8_ = mutateLogData(_loc8_);
         class_223.sendThroughJavaScript(_loc8_);
      }
      
      protected function mutateLogData(param1:AbstractLogEvent) : AbstractLogEvent
      {
         return param1;
      }
   }
}
