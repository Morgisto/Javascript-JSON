package com.waterworld.managers.store.storeitem
{
   import com.kixeye.logging.KXLogger;
   import com.kixeye.logging.class_72;
   import com.waterworld.datastores.IOBuildingCosts;
   import com.waterworld.datastores.IOShipDesign;
   import com.waterworld.datastores.IOShip;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import com.kixeye.utils.json.ActionJSON;
   import package_59.class_120;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.entities.ShipYard;
   import package_59.ShipRefitTransactionLogEvent;
   import package_59.ShipTransactionLogEvent;
   import package_59.class_223;
   import com.waterworld.resources.ResourceLogEvent;
   import com.waterworld.managers.shipyard.class_334;
   import com.waterworld.core.BASE;
   import package_43.Player;
   import com.waterworld.managers.store.STORE;
   
   public class InstantShipStoreItem extends StoreItem
   {
      
      public static const const_1695:int = 1;
      
      public static const const_2499:int = 2;
      
      private static var _log:KXLogger = class_72.getLoggerForClass(InstantShipStoreItem);
      
      {
         _log = class_72.getLoggerForClass(InstantShipStoreItem);
      }
      
      private var var_184:IOBuildingCosts;
      
      private var _time:int;
      
      private var var_1806:Array;
      
      public var var_349:int;
      
      public var var_95:IOShipDesign;
      
      private var var_1512:IOShip;
      
      public function InstantShipStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:IOShipDesign, param2:int, param3:int, param4:IOBuildingCosts, param5:int, param6:IOShip = null, param7:Array = null) : void
      {
         _time = param5;
         var_184 = param4;
         var_87.Set(param3);
         var_349 = param2;
         var_95 = param1;
         var_1512 = param6;
         var_1806 = param7;
         var _loc8_:String = var_349 == 1?BPResourceManager.getString("bp-flash","store_instantshipstoreitem_verb_refit"):BPResourceManager.getString("bp-flash","store_instantshipstoreitem_verb_build");
         setFBCWindowProps(class_295.applyTemplateToKey("store_instantshipstoreitem_title",{"verb":_loc8_}),class_295.applyTemplateToKey("store_instantshipstoreitem_description",{
            "verb":_loc8_,
            "hullName":param1.hullName
         }),param3,"BuildShipInstantly");
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc2_:* = null;
         var _loc5_:int = null != var_95?var_95.hullID:0;
         var _loc6_:Object = super.getAnalyticsData();
         var _loc4_:Object = {};
         _loc4_.h = _loc5_;
         _loc4_.w = [];
         var _loc11_:* = 0;
         var _loc10_:* = var_95.weapons;
         for each(var _loc1_ in var_95.weapons)
         {
            _loc4_.w.push(_loc1_);
         }
         _loc4_.a = [];
         var _loc13_:* = 0;
         var _loc12_:* = var_95.armors;
         for each(var _loc9_ in var_95.armors)
         {
            _loc4_.a.push(_loc9_);
         }
         _loc4_.s = [];
         var _loc15_:* = 0;
         var _loc14_:* = var_95.specials;
         for each(var _loc8_ in var_95.specials)
         {
            _loc4_.s.push(_loc8_);
         }
         _loc4_.t = [];
         var _loc17_:* = 0;
         var _loc16_:* = var_95.tacticalModules;
         for each(var _loc3_ in var_95.tacticalModules)
         {
            _loc4_.t.push(_loc3_);
         }
         _loc6_.description = ActionJSON.encodeJSON(_loc4_);
         _loc6_.action = 2 == var_349?"shipbuyout":"refitbuyout";
         _loc6_.item_id = _loc5_;
         _loc6_.speedup_seconds = _time;
         _loc6_.r1 = var_184.r1;
         _loc6_.r2 = var_184.r2;
         _loc6_.r3 = var_184.r3;
         _loc6_.r4 = var_184.r4;
         if(var_1806)
         {
            _loc2_ = [];
            var _loc19_:* = 0;
            var _loc18_:* = var_1806;
            for each(var _loc7_ in var_1806)
            {
               _loc2_.push(_loc7_.toObject());
            }
            _loc6_.logging = ActionJSON.encodeJSON(_loc2_);
         }
         return _loc6_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         var_349 = var_41.buildType;
         var_95 = new IOShipDesign(var_41.ship);
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc9_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = 0;
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc8_:* = null;
         var _loc7_:* = null;
         var _loc10_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc2_:ShipYard = GLOBAL.bShipyard;
         if(_loc2_)
         {
            try
            {
               if(!_loc2_.isBuildingShip)
               {
                  if(var_349 == 2)
                  {
                     _loc2_.shipBuildStart(var_95,false);
                  }
                  else if(var_349 == 1 && var_1512 != null)
                  {
                     _loc2_.shipRefitStart(var_1512,var_95,false);
                  }
               }
               else
               {
                  _log.logRemote("ERROR.InstantShipStoreItem.doApply","shipyard busy");
                  _loc9_ = BPResourceManager.getString("bp-flash","store_instantshipstoreitem_error_busy");
               }
            }
            catch(e:Error)
            {
               _log.logRemote("ERROR.InstantShipStoreItem.doApply","Could not start repair, uncaught error, error ID: " + e.errorID.toString() + ",error name: " + e.name.toString() + ", error message: " + e.message);
               _loc9_ = BPResourceManager.getString("bp-flash","store_instantshipstoreitem_error_couldntstart");
            }
            if(var_349 == 1 && var_1512 == null)
            {
               _log.logRemote("ERROR.InstantShipStoreItem.doApply","_refitIOShip is null");
            }
            else if(var_349 == 2 && var_95 == null)
            {
               _log.logRemote("ERROR.InstantShipStoreItem.doApply","_io is null");
            }
            _loc5_ = var_349 == 1?"refit":"shipbuilt";
            _loc3_ = var_349 == 1?var_1512.id:var_95.hullID;
            _loc6_ = var_349 == 1?var_1512.fleetId:-1;
            _loc4_ = var_349 == 1?var_1512:var_95;
            if(var_349 == 1)
            {
               _loc7_ = var_1512.refitAnalyticExport(_loc2_.designCurrent);
               _loc8_ = new ShipRefitTransactionLogEvent("refit_instant",_loc3_.toString(),_loc4_.hullID.toString(),ActionJSON.encodeJSON(_loc4_.analyticExport()),_loc4_.weight.toString(),_loc4_.armorPoints.toString(),_loc6_.toString(),_time.toString(),_time.toString(),"0",ActionJSON.encodeJSON(_loc7_.finalShipConfig),ActionJSON.encodeJSON(_loc7_.refitRemoved),ActionJSON.encodeJSON(_loc7_.refitAdded),ActionJSON.encodeJSON(_loc7_.refitNoChange),ActionJSON.encodeJSON(_loc7_.refitAddTimeCost),ActionJSON.encodeJSON(_loc7_.refitRemoveTimeCost));
            }
            else
            {
               _loc8_ = new ShipTransactionLogEvent("build_instant",_loc3_.toString(),_loc4_.hullID.toString(),ActionJSON.encodeJSON(_loc4_.analyticExport()),_loc4_.weight.toString(),_loc4_.armorPoints.toString(),_loc6_.toString(),_time.toString(),_time.toString(),"0");
            }
            class_223.sendThroughJavaScript(_loc8_);
            _loc10_ = new ResourceLogEvent(_loc5_,class_334.getBuilding().type.toString(),class_334.getBuilding().level.toString(),_loc3_.toString(),var_184.r1,var_184.r2,var_184.r3,var_184.r4,var_184.uraniumCurrency,BASE.oil,BASE.metal,BASE.energy,BASE.zynthium,Player.getInstance().currentUranium,{});
            class_223.sendThroughJavaScript(_loc10_);
            if(!_loc9_)
            {
               try
               {
                  _loc2_.shipBuildSpeedUp(_loc2_.shipBuildTimeRemaining);
               }
               catch(e:Error)
               {
                  _log.logRemote("ERROR.InstantShipStoreItem.doApply","Could not speed up, uncaught error, error ID: " + e.errorID.toString() + ",error name: " + e.name.toString() + ", error message: " + e.message);
                  _loc9_ = BPResourceManager.getString("bp-flash","store_instantshipstoreitem_error_couldntspeed");
               }
            }
         }
         else
         {
            _log.logRemote("ERROR.InstantShipStoreItem.doApply","null shipyard");
            _loc9_ = BPResourceManager.getString("bp-flash","store_instantshipstoreitem_error_nonefound");
         }
         return _loc9_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         var_41.ship = var_95.export();
         var_41.buildType = var_349;
         STORE.purchaseNew(this);
      }
   }
}
