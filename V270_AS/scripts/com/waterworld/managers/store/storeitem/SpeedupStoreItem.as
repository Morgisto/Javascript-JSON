package com.waterworld.managers.store.storeitem
{
   import com.waterworld.entities.BuildingFoundation;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.managers.store.STORE;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import com.waterworld.utils.class_84;
   import com.waterworld.entities.BuildingGenericResearch;
   import com.waterworld.datastores.ComponentRetrofitGroup;
   import package_32.ComponentManager;
   import com.waterworld.datastores.IOShipComponent;
   import com.battlepirates.repairspecialists.RepairSpecialistVO;
   import com.waterworld.entities.ShipYard;
   import com.waterworld.entities.DefensivePlatform;
   import package_10.BaseManager;
   import com.waterworld.datastores.IOShipDesign;
   import com.kixeye.utils.json.ActionJSON;
   import com.waterworld.entities.RetrofitLab;
   import package_64.InventoryController;
   import com.waterworld.datastores.IOBuildingCosts;
   import package_59.class_223;
   import package_59.ShipTransactionLogEvent;
   import package_97.RESEARCH;
   import package_40.class_301;
   import package_59.class_120;
   import package_11.class_22;
   import package_11.StoreEvent;
   import package_59.ShipRefitTransactionLogEvent;
   import com.waterworld.core.GlobalProperties;
   import com.waterworld.datastores.class_118;
   import package_59.ResearchLogEvent;
   import com.waterworld.entities.RocketLaunchPad;
   import com.waterworld.entities.ShipDock;
   import com.waterworld.datastores.IOShip;
   
   public class SpeedupStoreItem extends CommonSpeedupStoreItem
   {
      
      private static const const_909:int = 300;
      
      private static const const_2155:int = 1800;
      
      private static const const_1055:int = 3600;
      
      private static const const_32:Object = {};
      
      {
         const_32[1] = "repaired";
         const_32[2] = "build";
         const_32[3] = "upgraded";
         const_32[4] = "fortified";
         const_32[5] = "shipbuilt";
         const_32[6] = "researched";
         const_32[7] = "rocketbuilt";
         const_32[8] = "repaired";
         const_32[9] = "turret";
         const_32[10] = "buildingDesignBuilt";
      }
      
      public function SpeedupStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:BuildingFoundation = null, param2:Array = null) : void
      {
         var _loc15_:* = null;
         var _loc12_:* = null;
         var _loc18_:* = null;
         var _loc8_:* = 0;
         var _loc14_:* = null;
         var _loc19_:* = null;
         var _loc3_:* = null;
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc10_:* = null;
         var _loc9_:* = null;
         var_1806 = param2;
         if(param1 == null)
         {
            var param1:BuildingFoundation = GLOBAL.selectedBuilding;
         }
         var _loc4_:* = param1;
         var_18 = _loc4_._id;
         var _loc20_:* = var_57.charAt(2);
         if("1" !== _loc20_)
         {
            if("2" !== _loc20_)
            {
               if("3" !== _loc20_)
               {
                  if("4" === _loc20_)
                  {
                     _time = _loc4_.speedUpTimeRemaining;
                  }
               }
               else
               {
                  _time = 3600;
               }
            }
            else
            {
               _time = 1800;
            }
         }
         else
         {
            _time = 300;
         }
         var _loc11_:Boolean = isBuildingRepairingFleet(_loc4_);
         var_87.Set(STORE.costForTime(_time));
         var _loc17_:Object = STORE.var_104[var_57];
         var _loc13_:String = BPResourceManager.getString("bp-flash","store_speedupstoreitem_title");
         var _loc5_:String = "";
         if(var_57 != "SP4")
         {
            _loc5_ = class_295.applyTemplateToKey("store_speedupstoreitem_description_time",{"time":class_84.toTime(_time)});
         }
         else
         {
            _loc15_ = "";
            if(_loc11_)
            {
               _loc15_ = "store_speedupstoreitem_description_task_repair_fleet";
               _loc12_ = {};
            }
            else if(param1.isBuilding)
            {
               _loc15_ = "store_speedupstoreitem_description_task_built_building";
               _loc12_ = {"building":param1.name};
            }
            else if(param1.isRepairing)
            {
               _loc15_ = "store_speedupstoreitem_description_task_repair_building";
               _loc12_ = {"building":param1.name};
            }
            else if(param1.isUpgrading)
            {
               _loc15_ = "store_speedupstoreitem_description_task_upgrading_building";
               _loc12_ = {"building":param1.name};
            }
            else if(param1.isDesignBuilding)
            {
               _loc15_ = "store_speedupstoreitem_description_task_upgrading_building";
               _loc12_ = {"building":param1.name};
            }
            else if(param1.isFortificationUpgrading)
            {
               _loc15_ = "store_speedupstoreitem_description_task_fortifying_building";
               _loc12_ = {"building":param1.name};
            }
            else if(param1 is BuildingGenericResearch)
            {
               _loc18_ = BuildingGenericResearch(param1);
               if(_loc18_.isResearching)
               {
                  _loc8_ = _loc18_.getResearchId();
                  if(ComponentRetrofitGroup.isValidID(_loc8_))
                  {
                     _loc19_ = ComponentManager.getInstance().getCRGroupById(_loc8_);
                     _loc14_ = _loc19_.fullName();
                  }
                  else
                  {
                     _loc3_ = ComponentManager.getInstance().getComponent(_loc18_.getResearchId());
                     if(_loc3_)
                     {
                        _loc14_ = _loc3_.fullName;
                     }
                     else
                     {
                        _loc7_ = GLOBAL.const_9.getRepairSpecialistByID(_loc18_.getResearchId());
                        _loc14_ = _loc7_.name;
                     }
                  }
                  _loc15_ = "store_speedupstoreitem_description_task_researching";
                  _loc12_ = {"item":_loc14_};
               }
            }
            else if(param1 is ShipYard)
            {
               _loc6_ = ShipYard(param1);
               if(_loc6_.isBuildingShip)
               {
                  _loc15_ = "store_speedupstoreitem_description_task_building";
                  _loc12_ = {"item":_loc6_.currentBuild.hullName};
               }
            }
            else if(param1 is DefensivePlatform)
            {
               _loc10_ = param1 as DefensivePlatform;
               _loc9_ = ComponentManager.getInstance().getComponent(_loc10_.getBuildingCompId());
               _loc15_ = "store_speedupstoreitem_description_task_turret";
               _loc12_ = {"turret":_loc9_.fullName};
            }
            else
            {
               _loc15_ = "store_speedupstoreitem_description_task_default";
               _loc12_ = {"building":param1.name};
            }
            _loc5_ = class_295.applyTemplateToKey(_loc15_,_loc12_);
         }
         var _loc16_:int = var_87.Get() / _loc17_.cost[0];
         var_165 = "StorePopup";
         setModeFromFoundation(_loc4_,_loc11_);
         this.setFBCWindowProps(_loc13_,_loc5_,_loc16_,var_165);
         if(this.var_57 == "SP2" || this.var_57 == "SP3")
         {
            var_833 = true;
         }
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc16_:* = null;
         var _loc14_:* = null;
         var _loc17_:* = null;
         var _loc19_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = 0;
         var _loc11_:* = null;
         var _loc12_:* = null;
         var _loc15_:* = null;
         var _loc10_:* = null;
         var _loc13_:* = null;
         var _loc4_:* = false;
         var _loc5_:* = null;
         var _loc6_:Object = super.getAnalyticsData();
         _loc6_.action = const_32[var_117];
         _loc6_.speedup_seconds = _time;
         var _loc3_:BuildingFoundation = BaseManager.getInstance().getBuildingByIndex("b" + var_18);
         if(_loc3_)
         {
            switch(var_117 - 1)
            {
               case 0:
               case 1:
               case 2:
                  _loc6_.item_id = _loc3_.type;
                  _loc6_.item_level = _loc3_.level;
                  break;
               case 3:
                  _loc6_.item_id = _loc3_.type;
                  _loc6_.item_level = _loc3_.fortificationLevel + 1;
                  break;
               case 4:
                  _loc16_ = ShipYard(_loc3_);
                  if(_loc16_.isRefittingShip)
                  {
                     _loc6_.action = _time < GLOBAL.bShipyard.shipBuildTimeRemaining?"refitspeedup":"shiprefit";
                  }
                  else
                  {
                     _loc6_.action = _time < GLOBAL.bShipyard.shipBuildTimeRemaining?"shipspeedup":"shipbuilt";
                  }
                  _loc6_.item_id = _loc16_.getCurrentDesignHullId();
                  _loc14_ = _loc16_.currentBuild;
                  _loc17_ = {};
                  _loc17_.h = _loc6_.item_id;
                  _loc17_.w = [];
                  if(_loc14_)
                  {
                     var _loc24_:* = 0;
                     var _loc23_:* = _loc14_.weapons;
                     for each(var _loc1_ in _loc14_.weapons)
                     {
                        _loc17_.w.push(_loc1_);
                     }
                     _loc17_.a = [];
                     var _loc26_:* = 0;
                     var _loc25_:* = _loc14_.armors;
                     for each(var _loc21_ in _loc14_.armors)
                     {
                        _loc17_.a.push(_loc21_);
                     }
                     _loc17_.s = [];
                     var _loc28_:* = 0;
                     var _loc27_:* = _loc14_.specials;
                     for each(var _loc9_ in _loc14_.specials)
                     {
                        _loc17_.s.push(_loc9_);
                     }
                     _loc17_.t = [];
                     var _loc30_:* = 0;
                     var _loc29_:* = _loc14_.tacticalModules;
                     for each(var _loc18_ in _loc14_.tacticalModules)
                     {
                        _loc17_.t.push(_loc18_);
                     }
                  }
                  _loc6_.description = ActionJSON.encodeJSON(_loc17_);
                  break;
               case 5:
                  _loc19_ = BuildingGenericResearch(_loc3_);
                  _loc6_.item_id = _loc19_.researchID;
                  if(_loc19_ is RetrofitLab && _loc6_.item_id)
                  {
                     if(ComponentRetrofitGroup.isValidID(_loc6_.item_id))
                     {
                        _loc2_ = ComponentManager.getInstance().getCRGroupById(_loc6_.item_id);
                        _loc7_ = InventoryController.getInstance().getItemLevelForCompID(_loc2_.id);
                        _loc11_ = _loc2_.calcIOBuildingCosts(_loc7_);
                        class_223.sendThroughJavaScript(new ShipTransactionLogEvent("retrofit_speedup","0",_loc7_.toString(),"","","","",_loc11_.time.toString(),_time.toString(),_loc19_.researchTimeRemaining.toString(),"",_loc2_.id.toString()));
                     }
                     else
                     {
                        _loc12_ = ComponentManager.getInstance().getComponent(_loc6_.item_id);
                        class_223.sendThroughJavaScript(new ShipTransactionLogEvent("retrofit_speedup","0",_loc12_.prevRetrofitId.toString(),"","","","",RESEARCH.researchTime(_loc12_).toString(),_time.toString(),_loc19_.researchTimeRemaining.toString(),"",_loc12_.id.toString()));
                     }
                  }
                  break;
               case 6:
                  _loc15_ = GLOBAL.rocketInventory.getBuildingRocket();
                  _loc6_.item_id = _loc15_.itemCode;
                  break;
               case 7:
                  break;
               case 8:
               case 9:
                  _loc10_ = DefensivePlatform(_loc3_);
                  _loc13_ = "";
                  _loc4_ = false;
                  var _loc34_:* = 0;
                  var _loc33_:* = _loc10_.componentsBuilding;
                  for each(var _loc22_ in _loc10_.componentsBuilding)
                  {
                     var _loc32_:* = 0;
                     var _loc31_:* = _loc22_;
                     for each(var _loc20_ in _loc22_)
                     {
                        if(_loc4_)
                        {
                           _loc13_ = _loc13_ + ",";
                        }
                        else
                        {
                           _loc4_ = true;
                        }
                        _loc13_ = _loc13_ + _loc20_.toString();
                     }
                  }
                  _loc6_.item_id = _loc13_;
                  break;
            }
         }
         else
         {
            _loc6_.item_id = var_18;
         }
         if(var_1806)
         {
            _loc5_ = [];
            var _loc36_:* = 0;
            var _loc35_:* = var_1806;
            for each(var _loc8_ in var_1806)
            {
               _loc5_.push(_loc8_.toObject());
            }
            _loc6_.logging = ActionJSON.encodeJSON(_loc5_);
         }
         return _loc6_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
         class_22.instance.dispatchEvent(new StoreEvent("purchasecomplete"));
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         this._time = this.var_41.time;
         this.var_117 = this.var_41.mode;
         return this.doApply();
      }
      
      override public function applyFree() : String
      {
         if(this.var_57 == "SP1")
         {
            if(var_1806)
            {
               var _loc3_:* = 0;
               var _loc2_:* = var_1806;
               for each(var _loc1_ in var_1806)
               {
                  class_223.sendThroughJavaScript(_loc1_);
               }
            }
            onApplyComplete();
            return this.doApply("free");
         }
         return BPResourceManager.getString("bp-flash","store_speedupstoreitem_error_nonfree");
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc12_:* = null;
         var _loc18_:* = null;
         var _loc22_:* = null;
         var _loc4_:* = 0;
         var _loc17_:* = 0;
         var _loc23_:* = null;
         var _loc25_:* = NaN;
         var _loc13_:* = NaN;
         var _loc11_:* = null;
         var _loc14_:* = null;
         var _loc10_:* = 0;
         var _loc3_:* = null;
         var _loc20_:* = null;
         var _loc8_:* = null;
         var _loc19_:* = null;
         var _loc15_:* = 0;
         var _loc16_:* = null;
         var _loc21_:* = null;
         var _loc7_:* = null;
         var _loc2_:* = null;
         var _loc6_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc24_:String = "";
         var _loc5_:BuildingFoundation = BaseManager.getInstance().getBuildingByIndex("b" + var_18);
         if(!_loc5_)
         {
            return BPResourceManager.getString("bp-flash","store_speedupstoreitem_error_couldntfind");
         }
         var _loc9_:int = this.var_57 == "SP1"?_loc5_.speedUpTimeRemaining:_time;
         try
         {
            switch(this.var_117 - 1)
            {
               case 0:
                  _loc5_.repairSpeedUp(this._time);
                  break;
               case 1:
                  _loc5_.buildSpeedUp(this._time);
                  break;
               case 2:
                  _loc5_.upgradeSpeedUp(this._time);
                  break;
               case 3:
                  _loc5_.upgradeFortificationSpeedUp(this._time);
                  break;
               case 4:
                  _loc22_ = ShipYard(_loc5_);
                  _loc4_ = _loc22_.getCurrentDesignHullId();
                  _loc17_ = _loc22_.refitShipFleetID;
                  _loc23_ = _loc22_.getCurrentDesign();
                  _loc25_ = _loc22_.buildEndTime - _loc22_.buildStartTime;
                  _loc13_ = Math.max(_loc22_.speedUpTimeRemaining - _loc9_,0);
                  if(_loc22_.isRefittingShip)
                  {
                     _loc12_ = this.var_57 == "SP1"?"refit_speedup_free":"refit_speedup";
                     _loc11_ = _loc22_.refitShip.refitAnalyticExport(_loc22_.designCurrent);
                     _loc18_ = new ShipRefitTransactionLogEvent(_loc12_,_loc4_.toString(),_loc23_.hullID.toString(),ActionJSON.encodeJSON(_loc23_.analyticExport()),_loc23_.weight.toString(),_loc23_.armorPoints.toString(),_loc17_.toString(),_loc25_.toString(),_loc9_.toString(),_loc13_.toString(),ActionJSON.encodeJSON(_loc11_.finalShipConfig),ActionJSON.encodeJSON(_loc11_.refitRemoved),ActionJSON.encodeJSON(_loc11_.refitAdded),ActionJSON.encodeJSON(_loc11_.refitNoChange),ActionJSON.encodeJSON(_loc11_.refitAddTimeCost),ActionJSON.encodeJSON(_loc11_.refitRemoveTimeCost));
                  }
                  else
                  {
                     _loc12_ = this.var_57 == "SP1"?"build_speedup_free":"build_speedup";
                     _loc18_ = new ShipTransactionLogEvent(_loc12_,_loc4_.toString(),_loc23_.hullID.toString(),ActionJSON.encodeJSON(_loc23_.analyticExport()),_loc23_.weight.toString(),_loc23_.armorPoints.toString(),_loc17_.toString(),_loc25_.toString(),_loc9_.toString(),_loc13_.toString());
                  }
                  class_223.sendThroughJavaScript(_loc18_);
                  _loc22_.shipBuildSpeedUp(this._time);
                  break;
               case 5:
                  _loc14_ = BuildingGenericResearch(_loc5_);
                  _loc10_ = 0;
                  if(_loc14_ is RetrofitLab && _loc14_.researchID)
                  {
                     if(ComponentRetrofitGroup.isValidID(_loc14_.researchID))
                     {
                        _loc3_ = ComponentManager.getInstance().getCRGroupById(_loc14_.researchID);
                        _loc10_ = InventoryController.getInstance().getItemLevelForCompID(_loc3_.id) + 1;
                     }
                     else
                     {
                        _loc20_ = ComponentManager.getInstance().getComponent(_loc14_.researchID);
                        _loc8_ = _loc20_.prevRetrofitId.toString();
                        _loc19_ = RESEARCH.researchTime(_loc20_).toString();
                        _loc12_ = this.var_57 == "SP1"?"retrofit_speedup_free":"retrofit_speedup";
                        class_223.sendThroughJavaScript(new ShipTransactionLogEvent(_loc12_,"0",_loc8_,"","","","",_loc19_,_loc9_.toString(),(_loc14_.researchTimeRemaining - _loc9_).toString(),"",_loc8_));
                     }
                  }
                  _loc15_ = _loc14_.researchEndTime - GlobalProperties.gameTime - _loc9_;
                  _loc25_ = _loc14_.researchEndTime - _loc14_.researchStartTime;
                  _loc16_ = RESEARCH.getResearchComp(_loc14_.researchID);
                  _loc21_ = _loc16_?_loc16_.type:"componentRetrofit";
                  _loc12_ = this.var_57 == "SP1"?"speedup_free":"speedup";
                  _loc7_ = new ResearchLogEvent(_loc12_,_loc14_._buildingProps.id,_loc14_.researchID,_loc21_,_loc10_,_loc15_,_loc25_,_loc9_,cost,0,0,0,0,0);
                  class_223.sendThroughJavaScript(_loc7_);
                  _loc14_.researchSpeedUp(this._time);
                  break;
               case 6:
                  RocketLaunchPad(_loc5_).speedUpRocketBuild(this._time);
                  break;
               case 7:
                  _loc2_ = ShipDock(_loc5_);
                  _loc6_ = _loc2_.getShipByUID(_loc2_.repairUID);
                  if(var_57 == "SP1")
                  {
                     _loc9_ = _loc2_.repairTimeRemaining;
                  }
                  else
                  {
                     _loc9_ = _time;
                  }
                  if(var_57 == "SP1")
                  {
                     _loc12_ = "repair_speedup_free";
                  }
                  else
                  {
                     _loc12_ = "repair_speedup";
                  }
                  _loc18_ = new ShipTransactionLogEvent(_loc12_,_loc6_.id.toString(),_loc6_.hullID.toString(),ActionJSON.encodeJSON(_loc6_.analyticExport()),_loc6_.weight.toString(),_loc6_.armorPoints.toString(),_loc6_.fleetId.toString(),_loc2_.repairTimeTotalForCurrentShip.toString(),_loc9_.toString(),Math.max(_loc2_.repairTimeRemaining - _time,0).toString());
                  class_223.sendThroughJavaScript(_loc18_);
                  _loc2_.repairFleetSpeedUp(this._time);
                  break;
               case 8:
                  DefensivePlatform(_loc5_).turretBuildSpeedUp(this._time);
                  break;
               case 9:
                  _loc5_.designBuildSpeedUp(this._time);
                  break;
            }
         }
         catch(e:Error)
         {
            _loc24_ = BPResourceManager.getString("bp-flash","store_speedupstoreitem_error_generic");
         }
         return _loc24_;
      }
      
      override public function export() : Object
      {
         var_41.time = _time;
         var_41.mode = var_117;
         return super.export();
      }
   }
}
