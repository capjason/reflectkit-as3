/**
 * Created by JasonFK on 2017/6/6.
 */
package flex.capjason.reflect {
public class ReflectionParameter {
    private var _index:int;
    private var _type:String;
    private var _optional:Boolean;

    public function ReflectionParameter() {

    }

    public static function createFromXML(xml:XML):ReflectionParameter {
        var param:ReflectionParameter = new ReflectionParameter();
        param._type = xml.@type;
        param._index = xml.@index;
        param._optional = xml.@optional;
        return param;
    }


    public function get index():int {
        return _index;
    }

    public function get type():String {
        return _type;
    }

    public function get optional():Boolean {
        return _optional;
    }
}
}
