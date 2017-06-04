/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect.bean {
public class Child extends Base{
    public var childName:String = "child name";
    public var gender:int = 0;
    public var school:School = new School("Nanjing");
    public function Child() {
    }
}
}
