package package_40
{
   import com.waterworld.core.GlobalProperties;
   
   public class class_301 extends Object
   {
       
      private var _id:int;
      
      private var var_1237:int;
      
      private var var_4064:Number;
      
      private var var_1527:Boolean;
      
      private var var_1748:Number;
      
      private var var_3296:Boolean;
      
      public function class_301()
      {
         super();
      }
      
      public static function example() : class_301
      {
         var _loc1_:class_301 = new class_301();
         _loc1_._id = Math.random() * 100;
         _loc1_.var_1237 = 601 + (Math.random() * 2);
         _loc1_.var_1748 = GlobalProperties.gameTime - 100;
         _loc1_.var_3296 = true;
         return _loc1_;
      }
      
      public function init(param1:class_225) : class_301
      {
         _id = param1.id;
         var_1237 = param1.itemCode;
         var_4064 = param1.completeTime;
         var_1527 = param1.ready;
         var_1748 = param1.startTime;
         var_3296 = param1.buildCompleted;
         return this;
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function get itemCode() : int
      {
         return var_1237;
      }
      
      public function get completeTime() : Number
      {
         return var_4064;
      }
      
      public function get ready() : Boolean
      {
         return var_1527;
      }
      
      public function get startTime() : Number
      {
         return var_1748;
      }
      
      public function get serverMarkedAsCompleted() : Boolean
      {
         return var_3296;
      }
      
      public function get isComplete() : Boolean
      {
         return var_3296 || var_4064 < GlobalProperties.gameTime;
      }
   }
}
