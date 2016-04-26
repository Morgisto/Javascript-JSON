package com.waterworld.managers.store.storeitem
{
   import com.waterworld.datastores.IOBuildingCosts;
   import package_23.ZeroButtonMessagePopup;
   import com.waterworld.entities.BuildingFoundation;
   import package_63.Wall;
   import package_141.WALLUPGRADES;
   import com.waterworld.utils.class_295;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.resources.BPResourceManager;
   import package_59.class_120;
   import com.kixeye.utils.json.ActionJSON;
   import package_10.BaseManager;
   import package_142.AsyncIterator;
   import package_142.AsyncLoopRunner;
   import package_211.BaseSaveQueue;
   import com.waterworld.managers.store.STORE;
   
   public class MultipleWallUpgradeStoreItem extends StoreItem
   {
       
      private var var_5596:int;
      
      private var var_1428:Array;
      
      private var var_1961:int;
      
      private var var_2959:int;
      
      private var var_184:IOBuildingCosts;
      
      private var var_3775:Array;
      
      private var var_2432:ZeroButtonMessagePopup;
      
      public function MultipleWallUpgradeStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:BuildingFoundation, param2:Vector.<Wall>, param3:int, param4:Array = null) : void
      {
         this.var_5596 = param1._id;
         this.var_1961 = param1.type;
         this.var_1428 = [];
         this.var_2959 = param3;
         var_3775 = param4;
         var param2:Vector.<Wall> = WALLUPGRADES.filterWallsByLevel(param2,param3);
         var _loc10_:* = 0;
         var _loc9_:* = param2;
         for each(var _loc8_ in param2)
         {
            var_1428.push(_loc8_._id);
         }
         var _loc7_:int = param2.length;
         var_184 = WALLUPGRADES.buildingCostForGroup(param2,param3);
         var _loc6_:int = var_184.totalCosts;
         var _loc5_:String = class_295.applyTemplateToKey("store_multiplewallupgradestoreitem_description",{
            "numWalls":_loc7_,
            "level":param3,
            "resources":GLOBAL.formatNumber(_loc6_)
         });
         var_87.Set(WALLUPGRADES.instantGroupCostForLevel(Wall(param1),param3));
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_multiplewallupgradestoreitem_title"),_loc5_,_loc6_,"WALLUPGRADES");
         var_833 = true;
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:* = null;
         var _loc2_:Object = super.getAnalyticsData();
         _loc2_.item_id = var_1961;
         _loc2_.item_level = var_2959;
         _loc2_.action = "upgrade";
         _loc2_.speedup_seconds = var_184.time;
         _loc2_.r1 = var_184.r1;
         _loc2_.r2 = var_184.r2;
         _loc2_.r3 = var_184.r3;
         _loc2_.r4 = var_184.r4;
         if(var_3775)
         {
            _loc1_ = [];
            var _loc5_:* = 0;
            var _loc4_:* = var_3775;
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
         this.var_5596 = this.var_41.wallId;
         this.var_2959 = this.var_41.upgradeToLevel;
         this.var_1428 = this.var_41.adjacentWallIdsForLevel;
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc4_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc6_:Vector.<Wall> = new Vector.<Wall>();
         var _loc8_:* = 0;
         var _loc7_:* = this.var_1428;
         for each(var _loc2_ in this.var_1428)
         {
            _loc6_.push(BaseManager.getInstance().getBuildingFoundationByID(_loc2_));
         }
         var _loc5_:AsyncIterator = new AsyncIterator(0,_loc6_.length,upgradeWall,[_loc6_]);
         var _loc3_:AsyncLoopRunner = new AsyncLoopRunner(_loc5_,wallUpgradesDone);
         WALLUPGRADES.hide();
         var_2432 = new ZeroButtonMessagePopup(BPResourceManager.getString("bp-flash","wall_upgrade_progress_title"),BPResourceManager.getString("bp-flash","wall_upgrade_progress_message",{
            "completed":"0",
            "total":var_1428.length.toString()
         }));
         _loc3_.run();
         return _loc4_;
      }
      
      private function hideWarning() : void
      {
         if(var_2432)
         {
            var_2432.hide();
         }
      }
      
      private function wallUpgradesDone(param1:AsyncLoopRunner) : void
      {
         var_2432.updateMessage(BPResourceManager.getString("bp-flash","wall_upgrade_progress_message",{
            "completed":var_1428.length.toString(),
            "total":var_1428.length.toString()
         }) + BPResourceManager.getString("bp-flash","wall_upgrade_progress_saving_message"));
         BaseSaveQueue.add(0,true,delayedBaseSaveDone,false,null,null,false);
      }
      
      private function delayedBaseSaveDone() : void
      {
         hideWarning();
      }
      
      private function upgradeWall(param1:AsyncIterator, param2:Vector.<Wall>) : void
      {
         var _loc3_:* = 0;
         _loc3_ = param2[param1.counter].level;
         while(_loc3_ < this.var_2959)
         {
            param2[param1.counter].upgradeForWallGroup();
            _loc3_++;
         }
         param2[param1.counter].updateWallImage();
         var_2432.updateMessage(BPResourceManager.getString("bp-flash","wall_upgrade_progress_message",{
            "completed":(param1.counter + 1).toString(),
            "total":var_1428.length.toString()
         }));
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      override public function export() : Object
      {
         var_41.wallId = this.var_5596;
         var_41.upgradeToLevel = this.var_2959;
         var_41.adjacentWallIdsForLevel = this.var_1428;
         return super.export();
      }
   }
}
