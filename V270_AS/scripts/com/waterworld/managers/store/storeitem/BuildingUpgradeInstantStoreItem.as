package com.waterworld.managers.store.storeitem
{
   import com.waterworld.entities.BuildingFoundation;
   import package_10.BaseManager;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import com.waterworld.utils.class_84;
   import com.waterworld.datastores.IOBuildingCosts;
   import package_59.class_120;
   import com.kixeye.utils.json.ActionJSON;
   import com.waterworld.managers.buildings.class_266;
   import com.waterworld.managers.store.STORE;
   
   public class BuildingUpgradeInstantStoreItem extends StoreItem
   {
       
      private var _building:BuildingFoundation;
      
      private var var_3775:Array;
      
      public function BuildingUpgradeInstantStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:int, param2:Array = null) : void
      {
         var_3775 = param2;
         var_18 = param1;
         _building = BaseManager.getInstance().getBuildingByIndex("b" + param1);
         var_87.Set(_building.instantUpgradeCost());
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_buildingupgradeinstantstoreitem_title"),class_295.applyTemplateToKey("store_buildingupgradeinstantstoreitem_message",{
            "buildingName":_building._buildingProps.name,
            "level":_building.level + 1,
            "time":class_84.toTime(_building._buildingProps.getBuildTime(_building.level + 1))
         }),_building.instantUpgradeCost(),"BuildingOptionsPopup");
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:* = null;
         var _loc2_:Object = super.getAnalyticsData();
         _loc2_.item_id = _building.type;
         _loc2_.item_level = _building.level;
         _loc2_.action = "upgraded";
         _loc2_.speedup_seconds = _building._buildingProps.getBuildTime(_building.level);
         var _loc4_:IOBuildingCosts = _building.clampedUpgradeCost();
         _loc2_.r1 = _loc4_.r1;
         _loc2_.r2 = _loc4_.r2;
         _loc2_.r3 = _loc4_.r3;
         _loc2_.r4 = _loc4_.r4;
         if(var_3775)
         {
            _loc1_ = [];
            var _loc6_:* = 0;
            var _loc5_:* = var_3775;
            for each(var _loc3_ in var_3775)
            {
               _loc1_.push(_loc3_.toObject());
            }
            _loc2_.logging = ActionJSON.encodeJSON(_loc1_);
         }
         return _loc2_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc2_:BuildingFoundation = BaseManager.getInstance().getBuildingByIndex("b" + var_18);
         if(_loc2_)
         {
            _loc5_ = _loc2_.level;
            try
            {
               _loc2_.upgradeB(0,false,true);
               _loc2_.hasWorker();
            }
            catch(e:Error)
            {
               _loc4_ = BPResourceManager.getString("bp-flash","store_buildingupgradeinstantstoreitem_error_upgrade");
            }
            if(!_loc4_)
            {
               try
               {
                  _loc2_.upgradeSpeedUp(_loc2_.upgradeTimeRemaining);
               }
               catch(e:Error)
               {
                  _loc4_ = BPResourceManager.getString("bp-flash","store_buildingupgradeinstantstoreitem_error_speedup");
               }
            }
            _loc3_ = _loc2_.level;
            if(_loc5_ == _loc3_)
            {
               _loc4_ = BPResourceManager.getString("bp-flash","store_buildingupgradeinstantstoreitem_error_unsuccessful");
            }
         }
         else
         {
            _loc4_ = BPResourceManager.getString("bp-flash","store_buildingupgradeinstantstoreitem_error_buildingnotfound");
         }
         class_266.hide();
         return _loc4_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      override public function export() : Object
      {
         var_41.upgradeType = 0;
         var _loc1_:Object = super.export();
         return _loc1_;
      }
   }
}
