package package_40
{
   import package_2.class_3;
   import com.waterworld.core.GLOBAL;
   import package_108.class_198;
   
   public class class_66 extends class_3
   {
       
      public function class_66()
      {
         super();
      }
      
      override public function execute() : void
      {
         super.execute();
         GLOBAL.rocketInventory.init(onRocketsLoaded,onRocketsLoadingFailure,false);
         startAsync();
      }
      
      private function onRocketsLoaded() : void
      {
         endAsync();
         dispatchComplete(true);
      }
      
      public function onRocketsLoadingFailure(param1:class_198) : void
      {
         var _loc2_:String = "";
         var _loc3_:String = "";
         GLOBAL.errorMessage(_loc2_,_loc3_,true);
      }
   }
}
