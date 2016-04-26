package com.waterworld.managers.store.storeitem
{
   import package_32.ComponentManager;
   import com.waterworld.datastores.IOShipComponent;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.entities.RocketLaunchPad;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import package_59.class_120;
   import com.kixeye.utils.json.ActionJSON;
   import com.waterworld.managers.rocketpad.class_173;
   import com.waterworld.managers.store.STORE;
   
   public class InstantRocketStoreItem extends StoreItem
   {
       
      private var _time:int;
      
      private var var_3775:Array;
      
      public function InstantRocketStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:int, param2:Array = null) : void
      {
         var_3775 = param2;
         var_18 = param1;
         var _loc3_:IOShipComponent = ComponentManager.getInstance().getComponent(param1);
         var_87.Set(GLOBAL.bRocketPad.getInstantRocketCost(param1));
         _time = RocketLaunchPad.getBuildTime(param1);
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_instantrocketstoreitem_title"),class_295.applyTemplateToKey("store_instantrocketstoreitem_message",{
            "componentName":_loc3_.fullName,
            "time":RocketLaunchPad.getBuildTime(param1)
         }),_time + _loc3_.costs.totalCosts,"BuildRocketInstantly");
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc2_:* = null;
         var _loc3_:Object = super.getAnalyticsData();
         _loc3_.item_id = var_18;
         _loc3_.action = "rocketbuilt";
         var _loc1_:IOShipComponent = ComponentManager.getInstance().getComponent(var_18);
         _loc3_.speedup_seconds = _time;
         _loc3_.r1 = _loc1_.costs.r1;
         _loc3_.r2 = _loc1_.costs.r2;
         _loc3_.r3 = _loc1_.costs.r3;
         _loc3_.r4 = _loc1_.costs.r4;
         if(var_3775)
         {
            _loc2_ = [];
            var _loc6_:* = 0;
            var _loc5_:* = var_3775;
            for each(var _loc4_ in var_3775)
            {
               _loc2_.push(_loc4_.toObject());
            }
            _loc3_.logging = ActionJSON.encodeJSON(_loc2_);
         }
         return _loc3_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc3_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc2_:IOShipComponent = ComponentManager.getInstance().getComponent(var_18);
         var _loc4_:RocketLaunchPad = GLOBAL.bRocketPad;
         if(!_loc2_)
         {
            _loc3_ = BPResourceManager.getString("bp-flash","store_instantrocketstoreitem_error_norocket");
         }
         if(!_loc4_)
         {
            _loc3_ = BPResourceManager.getString("bp-flash","store_instantrocketstoreitem_error_norocketbuilding");
         }
         if(!_loc3_)
         {
            _loc4_.startRocketBuild(var_18,false);
            _loc4_.speedUpRocketBuild(_loc4_.rocketBuildTimeRemaining,false);
         }
         class_173.hide();
         class_173.hideInfo();
         class_173.tick();
         GLOBAL.isoViewport.lookAt(_loc4_.x,_loc4_.y);
         return _loc3_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
   }
}
