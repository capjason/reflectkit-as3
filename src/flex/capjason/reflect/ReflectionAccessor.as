/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect {
public class ReflectionAccessor extends ReflectionObject {
    private var _access:int;
    private var _type:String;
    private var _declaredBy:String;
    public function ReflectionAccessor() {

    }

    public static function  createFromXML(xml:XML):ReflectionAccessor {
        var accessor:ReflectionAccessor = new ReflectionAccessor();
        accessor._name = xml.@name;
        accessor._type = xml.@type;
        accessor._declaredBy = xml.@declaredBy;
        var accessStr:String = xml.@access;
        accessor._access = AccessType.fromStr(accessStr);
        accessor.parseMetadata(xml.@metadata);
        return accessor;
    }

    public function get access():int {
        return _access;
    }

    public function get type():String {
        return _type;
    }

    public function get declaredBy():String {
        return _declaredBy;
    }
}
}
