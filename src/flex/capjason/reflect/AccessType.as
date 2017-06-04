/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect {
public class AccessType {
    public static const READONLY:int = 0x1;
    public static const WRITEONLY:int = 0x2;
    public static const READWRITE:int = READONLY | WRITEONLY;
    public function AccessType() {
    }

    public static function fromStr(str:String):int {
        switch (str) {
            case "readonly":
                return READONLY;
            case "writeonly":
                return WRITEONLY;
            case "readwrite":
            default:
                return READWRITE;
        }
        return READWRITE;
    }
}
}
