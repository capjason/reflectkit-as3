/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect.bean {
import flex.capjason.reflect.Clonable;
import flex.capjason.reflect.ReflectKit;

public class Base implements Clonable{
    public var name:String = "name";
    public var test:int = 1;
    public function Base() {

    }

    public function clone():Clonable {
        return ReflectKit.cloneValueObject(this);
    }
}
}
