/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect {
public class ReflectionVariable extends ReflectionObject {
    private var _type;String;
    public function ReflectionVariable() {

    }

    public static function createFromXML(xml:XML): ReflectionVariable {
        var variable:ReflectionVariable = new ReflectionVariable();
        variable._name = xml.@name;
        variable._type = xml.@type;
        variable.parseMetadata(xml.metadata);
        return variable;
    }


    public function get type():String{
        return _type;
    }
}
}
