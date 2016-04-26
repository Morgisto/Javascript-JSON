package com.waterworld.managers.store.storeitem
{
   import com.waterworld.entities.BuildingFoundation;
   import package_10.BaseManager;
   import package_171.FORTIFICATION;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import com.waterworld.utils.class_84;
   import com.waterworld.datastores.IOBuildingCosts;
   import package_59.class_120;
   import com.kixeye.utils.json.ActionJSON;
   import com.waterworld.managers.store.STORE;
   
   public class BuildingFortificationStoreItem extends StoreItem
   {
       
      private var _building:BuildingFoundation;
      
      private var var_3775:Array;
      
      public function BuildingFortificationStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:int, param2:Array = null) : void
      {
         var_3775 = param2;
         var_18 = param1;
         _building = BaseManager.getInstance().getBuildingByIndex("b" + param1);
         var_87.Set(FORTIFICATION.instantUpgradeCost(_building.fortificationLevel + 1));
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_buildfortificationstoreitem_title"),class_295.applyTemplateToKey("store_buildfortificationstoreitem_message",{
            "level":_building.fortificationLevel + 1,
            "time":class_84.toTime(FORTIFICATION.timeForLevel(_building.fortificationLevel + 1))
         }),FORTIFICATION.instantUpgradeCost(_building.fortificationLevel + 1),"FortificationPopup");
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:* = null;
         var _loc2_:Object = super.getAnalyticsData();
         _loc2_.item_id = _building.type;
         _loc2_.item_level = _building.fortificationLevel + 1;
         _loc2_.action = "fortified";
         _loc2_.speedup_seconds = FORTIFICATION.timeForLevel(_building.fortificationLevel);
         var _loc4_:IOBuildingCosts = FORTIFICATION.costForLevel(_building.level);
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
         var _loc3_:* = null;
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc5_:BuildingFoundation = BaseManager.getInstance().getBuildingByIndex("b" + var_18);
         if(_loc5_)
         {
            _loc4_ = _loc5_.fortificationLevel;
            try
            {
               _loc5_.upgradeB(1,false,true);
               _loc5_.hasWorker();
            }
            catch(e:Error)
            {
               _loc3_ = BPResourceManager.getString("bp-flash","store_buildfortificationstoreitem_error_upgrade");
            }
            if(!_loc3_)
            {
               try
               {
                  _loc5_.upgradeFortificationSpeedUp(_loc5_.upgradeFortificationTimeRemaining);
               }
               catch(e:Error)
               {
                  _loc3_ = BPResourceManager.getString("bp-flash","store_buildfortificationstoreitem_error_speedup");
               }
            }
            _loc2_ = _loc5_.fortificationLevel;
            if(_loc4_ == _loc2_)
            {
               _loc3_ = BPResourceManager.getString("bp-flash","store_buildfortificationstoreitem_error_unsuccessful");
            }
         }
         else
         {
            _loc3_ = BPResourceManager.getString("bp-flash","store_buildfortificationstoreitem_error_notfound");
         }
         FORTIFICATION.hide();
         return _loc3_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      override public function export() : Object
      {
         var_41.upgradeType = 1;
         var _loc1_:Object = super.export();
         return _loc1_;
      }
   }
}
