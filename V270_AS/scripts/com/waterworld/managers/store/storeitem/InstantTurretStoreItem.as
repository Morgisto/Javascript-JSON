package com.waterworld.managers.store.storeitem
{
   import com.waterworld.datastores.IOBuildingCosts;
   import com.waterworld.entities.DefensivePlatform;
   import package_32.ComponentManager;
   import com.waterworld.datastores.IOShipComponent;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import com.waterworld.utils.class_84;
   import package_59.class_120;
   import com.kixeye.utils.json.ActionJSON;
   import package_10.BaseManager;
   import com.waterworld.managers.store.STORE;
   
   public class InstantTurretStoreItem extends StoreItem
   {
       
      private var var_1358:Object;
      
      private var _time:int;
      
      private var var_184:IOBuildingCosts;
      
      private var var_1806:Array;
      
      public function InstantTurretStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:DefensivePlatform, param2:Object, param3:Array = null) : void
      {
         var _loc7_:* = null;
         var _loc4_:* = null;
         var_18 = param1._id;
         var_1358 = param2;
         var_184 = param1.getInstantTurretBuildingCost(param2);
         var_87.Set(param1.getInstantTurretCost(param2));
         _time = param1.getTurretBuildTime(param2);
         var_1806 = param3;
         var _loc5_:IOBuildingCosts = new IOBuildingCosts();
         var _loc9_:* = -1;
         var _loc6_:* = -1;
         var _loc8_:String = "";
         var _loc13_:* = 0;
         var _loc12_:* = var_1358;
         for(_loc8_ in var_1358)
         {
            _loc7_ = var_1358[_loc8_];
            var _loc11_:* = 0;
            var _loc10_:* = _loc7_;
            for each(_loc6_ in _loc7_)
            {
               if(_loc6_ > 0)
               {
                  if(_loc8_ == "w" && _loc9_ == -1)
                  {
                     _loc9_ = _loc6_;
                  }
                  _loc5_.add(ComponentManager.getInstance().getComponent(_loc6_).costs);
               }
            }
         }
         if(_loc9_ < 0 && _loc6_ > 0)
         {
            _loc9_ = _loc6_;
         }
         if(_loc9_ > 0)
         {
            _loc4_ = ComponentManager.getInstance().getComponent(_loc9_);
            setFBCWindowProps(BPResourceManager.getString("bp-flash","store_instantturretstoreitem_title"),class_295.applyTemplateToKey("store_instantturretstoreitem_message",{
               "componentName":_loc4_.name,
               "time":class_84.toTime(_time)
            }),_time + _loc5_.totalCosts,"TurretOptionsPopup");
         }
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc2_:* = null;
         var _loc3_:Object = super.getAnalyticsData();
         var _loc1_:Array = [];
         var _loc10_:* = 0;
         var _loc9_:* = var_1358;
         for each(var _loc6_ in var_1358)
         {
            var _loc8_:* = 0;
            var _loc7_:* = _loc6_;
            for each(var _loc4_ in _loc6_)
            {
               _loc1_.push(_loc4_.toString());
            }
         }
         _loc3_.item_id = _loc1_.join(",");
         _loc3_.action = "turret";
         _loc3_.speedup_seconds = _time;
         _loc3_.r1 = var_184.r1;
         _loc3_.r2 = var_184.r2;
         _loc3_.r3 = var_184.r3;
         _loc3_.r4 = var_184.r4;
         if(var_1806)
         {
            _loc2_ = [];
            var _loc12_:* = 0;
            var _loc11_:* = var_1806;
            for each(var _loc5_ in var_1806)
            {
               _loc2_.push(_loc5_.toObject());
            }
            _loc3_.logging = ActionJSON.encodeJSON(_loc2_);
         }
         return _loc3_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         var_1358 = var_41.compids;
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc2_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc3_:DefensivePlatform = BaseManager.getInstance().getBuildingByIndex("b" + var_18) as DefensivePlatform;
         if(_loc3_)
         {
            _loc3_.buildTurretInstantly(this.var_1358);
         }
         else
         {
            _loc2_ = BPResourceManager.getString("bp-flash","store_instantturretstoreitem_error");
         }
         return _loc2_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      override public function export() : Object
      {
         var_41.compids = var_1358;
         return super.export();
      }
   }
}
