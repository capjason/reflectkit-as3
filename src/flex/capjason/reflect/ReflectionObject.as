/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect {
public class ReflectionObject {
    protected var _name:String;
    protected var _metadatas:Vector.<ReflectionMetadata> = new Vector.<ReflectionMetadata>();
    public function ReflectionObject() {

    }

    protected function parseMetadata(metatags:XMLList):void {
        for(var i:int = 0;i < metatags.length(); ++i) {
            var tag:XML = metatags[i];
            var metadata:ReflectionMetadata = ReflectionMetadata.createFromXML(tag);
            _metadatas.push(metadata);
        }
    }

    public function get name():String {
        return _name;
    }

    public function get metadatas():Vector.<ReflectionMetadata> {
        return _metadatas;
    }

    public function getMetadata(name:String):ReflectionMetadata {
        for(var i:int = 0;i < metadatas.length; ++i) {
            if(metadatas[i].name == name) {
                return metadatas[i];
            }
        }
        return null;
    }

    public function hasMetadata(name:String):Boolean {
        return getMetadata(name) != null;
    }
}
}
