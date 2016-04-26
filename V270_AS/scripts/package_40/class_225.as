package package_40
{
   class class_225 extends Object
   {
       
      private var _id:int;
      
      private var var_1237:int;
      
      private var var_4064:Number;
      
      private var var_1748:Number;
      
      private var var_1527:Boolean;
      
      private var var_5172:Boolean;
      
      function class_225()
      {
         super();
      }
      
      function init(param1:Object) : class_225
      {
         _id = param1.rocketId;
         var_1237 = param1.itemCode;
         var_4064 = param1.completeTime;
         var_1527 = param1.ready;
         var_1748 = param1.startTime;
         var_5172 = param1.completed;
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
      
      public function get buildCompleted() : Boolean
      {
         return var_5172;
      }
   }
}
