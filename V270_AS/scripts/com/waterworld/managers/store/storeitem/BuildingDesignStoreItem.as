package com.waterworld.managers.store.storeitem
{
   import com.waterworld.datastores.IOBuildingCosts;
   import com.waterworld.datastores.IOBuildingDesign;
   import com.waterworld.resources.BPResourceManager;
   import package_10.BaseManager;
   import com.waterworld.entities.BuildingFoundation;
   import com.waterworld.resources.ResourceLogEvent;
   import com.waterworld.core.BASE;
   import package_43.Player;
   import package_59.class_223;
   import com.waterworld.managers.store.STORE;
   import com.kixeye.utils.json.ActionJSON;
   import package_59.class_120;
   
   public class BuildingDesignStoreItem extends StoreItem
   {
       
      private var var_184:IOBuildingCosts;
      
      private var _time:int;
      
      private var var_1806:Array;
      
      public var var_349:int;
      
      public var var_95:IOBuildingDesign;
      
      public function BuildingDesignStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:IOBuildingDesign, param2:int, param3:IOBuildingCosts, param4:int, param5:int, param6:Array = null) : void
      {
         _time = param4;
         var_184 = param3;
         var_87.Set(param2);
         var_95 = param1;
         var_18 = param5;
         var_1806 = param6;
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_instantbuildingdesignitem_title"),BPResourceManager.getString("bp-flash","store_instantbuildingdesignitem_description"),param2,"BuildBuildingDesignInstantly");
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         var_95 = new IOBuildingDesign({"design":var_41.buildingDesign});
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         try
         {
            _loc2_ = BaseManager.getInstance().getBuildingByIndex("b" + var_18);
            if(_loc2_)
            {
               _loc2_.startDesignBuild(var_95,false);
            }
            else
            {
               _loc4_ = BPResourceManager.getString("bp-flash","store_instantshipstoreitem_error_busy");
            }
         }
         catch(e:Error)
         {
            _loc4_ = BPResourceManager.getString("bp-flash","store_instantshipstoreitem_error_couldntstart");
         }
         if(!_loc4_)
         {
            try
            {
               _loc2_.designBuildSpeedUp(_loc2_.designBuildTimeRemaining);
               _loc5_ = _loc2_.type == 40?"turret":"buildingdesignbuildinstantly";
               _loc3_ = new ResourceLogEvent(_loc5_,_loc2_.type.toString(),_loc2_.level.toString(),var_18,var_184.r1 * -1,var_184.r2 * -1,var_184.r3 * -1,var_184.r4 * -1,var_184.uraniumCurrency * -1,BASE.oil,BASE.metal,BASE.energy,BASE.zynthium,Player.getInstance().currentUranium,{});
               class_223.sendThroughJavaScript(_loc3_);
            }
            catch(e:Error)
            {
               _loc4_ = BPResourceManager.getString("bp-flash","store_instantshipstoreitem_error_couldntspeed");
            }
         }
         else
         {
            _loc4_ = BPResourceManager.getString("bp-flash","store_instantshipstoreitem_error_nonefound");
         }
         return _loc4_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         var_41.buildingDesign = var_95.export();
         STORE.purchaseNew(this);
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc2_:* = null;
         var _loc5_:Object = super.getAnalyticsData();
         var _loc4_:Object = {};
         _loc4_.w = [];
         var _loc10_:* = 0;
         var _loc9_:* = var_95.weapons;
         for each(var _loc1_ in var_95.weapons)
         {
            _loc4_.w.push(_loc1_);
         }
         _loc4_.a = [];
         var _loc12_:* = 0;
         var _loc11_:* = var_95.armors;
         for each(var _loc8_ in var_95.armors)
         {
            _loc4_.a.push(_loc8_);
         }
         _loc4_.s = [];
         var _loc14_:* = 0;
         var _loc13_:* = var_95.specials;
         for each(var _loc7_ in var_95.specials)
         {
            _loc4_.s.push(_loc7_);
         }
         _loc4_.t = [];
         var _loc16_:* = 0;
         var _loc15_:* = var_95.tacticalModules;
         for each(var _loc3_ in var_95.tacticalModules)
         {
            _loc4_.t.push(_loc3_);
         }
         _loc5_.description = ActionJSON.encodeJSON(_loc4_);
         _loc5_.action = "design_build";
         _loc5_.item_id = var_95.loggingUnitIds;
         _loc5_.item_level = var_95.buildingLevel;
         _loc5_.speedup_seconds = _time;
         _loc5_.r1 = var_184.r1;
         _loc5_.r2 = var_184.r2;
         _loc5_.r3 = var_184.r3;
         _loc5_.r4 = var_184.r4;
         if(var_1806)
         {
            _loc2_ = [];
            var _loc18_:* = 0;
            var _loc17_:* = var_1806;
            for each(var _loc6_ in var_1806)
            {
               _loc2_.push(_loc6_.toObject());
            }
            _loc5_.logging = ActionJSON.encodeJSON(_loc2_);
         }
         return _loc5_;
      }
   }
}
