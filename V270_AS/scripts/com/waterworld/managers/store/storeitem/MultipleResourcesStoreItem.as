package com.waterworld.managers.store.storeitem
{
   import com.kixeye.logging.KXLogger;
   import com.kixeye.logging.class_72;
   import com.waterworld.managers.store.STORE;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.core.BASE;
   import com.waterworld.utils.object.class_628;
   
   public class MultipleResourcesStoreItem extends StoreItem
   {
      
      private static var _log:KXLogger = class_72.getLoggerForClass(MultipleResourcesStoreItem);
      
      private static var var_2757:Function;
      
      private static var var_4987:Array;
      
      {
         _log = class_72.getLoggerForClass(MultipleResourcesStoreItem);
      }
      
      private var var_492:Array;
      
      private var var_196:String;
      
      public function MultipleResourcesStoreItem(param1:String, param2:String)
      {
         var_196 = param2;
         super(param1);
      }
      
      public function initToBuy(param1:int, param2:int, param3:int, param4:int, param5:Function = null, param6:Array = null) : void
      {
         var_492 = [param1,param2,param3,param4];
         var_2757 = param5;
         var_4987 = param6;
         var _loc7_:Number = param1 + param2 + param3 + param4;
         if(_loc7_ > 2147483647 || _loc7_ < 0)
         {
            _log.logRemote("ERROR.MultipleResourcesStoreItem.initToBuy.total_value","total:" + _loc7_,"source:" + var_196,"r1:" + param1,"r2:" + param2,"r3:" + param3,"r4:" + param4);
         }
         var_87.Set(STORE.costForResources(_loc7_));
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_multipleresourcesstoreitem_title"),class_295.applyTemplateToKey("store_multipleresourcesstoreitem_message",{"total":GLOBAL.formatNumber(_loc7_)}),_loc7_,"BuildingUpgrade");
         var_833 = true;
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:Object = super.getAnalyticsData();
         _loc1_.action = "resources";
         _loc1_.r1 = var_492[0];
         _loc1_.r2 = var_492[1];
         _loc1_.r3 = var_492[2];
         _loc1_.r4 = var_492[3];
         return _loc1_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         var_492 = var_41.resources;
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc3_:* = null;
         var _loc2_:* = NaN;
         var _loc4_:* = 0;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         try
         {
            _loc2_ = 0.0;
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               BASE.fund(_loc4_ + 1,var_492[_loc4_]);
               _loc2_ = _loc2_ + var_492[_loc4_];
               _loc4_++;
            }
            if(_loc2_ > 2147483647 || _loc2_ < 0)
            {
               _log.logRemote("ERROR.MultipleResourcesStoreItem.doApply.total_value","total:" + _loc2_,"source:" + var_196,"r1:" + var_492[1],"r2:" + var_492[2],"r3:" + var_492[3],"r4:" + var_492[4]);
            }
            else
            {
               BASE.pointsAdd(_loc2_,"resource",{"source":"MultipleResourcesStoreItem.doApply.total"});
            }
         }
         catch(e:Error)
         {
            _loc3_ = BPResourceManager.getString("bp-flash","store_multipleresourcesstoreitem_error_couldntfind");
         }
         GLOBAL.waitHide();
         if(var_2757 != null)
         {
            class_628.applyFunction(var_2757,var_4987);
            var_2757 = null;
         }
         return _loc3_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      override public function export() : Object
      {
         var_41.resources = var_492;
         return super.export();
      }
   }
}
