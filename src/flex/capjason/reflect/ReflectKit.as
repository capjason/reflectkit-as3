/**
 * Created by Jason on 2017/6/4.
 */
package flex.capjason.reflect {
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class ReflectKit {
    public function ReflectKit() {

    }

    /**
     * clone a value object,any public property is cloned to the returned object.
     * if deepClone is set to true,any clonable property is recursively cloned.
     * @param value
     * @param deepClone
     * @return
     */
    public static function cloneValueObject(object:Clonable,deepClone:Boolean = true):Clonable {
        var clazz:Class = getClassDefinition(object);
        var res = new clazz();
        var reflection:ReflectionClass = new ReflectionClass(object);
        var i:int;

        var clonableProps:Vector.<String> = new Vector.<String>();
        var variables:Vector.<ReflectionVariable> = reflection.variables;
        for(i = 0;i < variables.length; ++i) {
            clonableProps.push(variables[i].name);
        }

        var accessors:Vector.<ReflectionAccessor> = reflection.accessors;
        for(i = 0;i < accessors.length; ++i) {
            var accessor:ReflectionAccessor = accessors[i];
            if(accessor.access != AccessType.READWRITE) {
                continue;
            }
            clonableProps.push(accessor.name);
        }
        for(i = 0;i < clonableProps.length; ++i) {
            var prop:String = clonableProps[i];
            var value:* = object[prop];
            if(!deepClone) {
                res[prop] = value;
            } else {
                res[prop] = cloneValue(value);
            }
        }
        return res;
    }

    private static function cloneValue(value:*):* {
        if(isPrimitiveType(value)) {
            return value;
        }
        if(value is Clonable) {
            return cloneValueObject(value,true);
        }

        if(value is Array) {
            var arr:Array = [];
            var valueArr:Array = value as Array;
            for(var i:int = 0;i < valueArr.length; ++i) {
                arr.push(cloneValue(valueArr[i]));
            }
            return arr;
        }

        if(value is Vector) {
            return (value as Vector).concat();
        }
        return value;
    }

    /**
     * serialize an class to JSON,
     * variables and accessors support metadata below
     *      JSON
     *           args transient, no value
     *           args name, name of json object property,default use class property name
     *           args nullValue, specify a value which is regarded as null value for this property.
     *                          used when keepNullValue set to true, default is null.
     * @param serializable
     * @param keepNullValue if set to true, any property whose value is nullValue will be ignored
     * @return
     */
    public static function jsonSerialize(serializable:JSONSerializable,keepNullValue:Boolean = true):Object {
        var obj:Object = {};
        var reflection:ReflectionClass = new ReflectionClass(serializable);

        var accessibleVariables:Vector.<ReflectionObject> = new Vector.<ReflectionObject>();
        var i:int;
        for(i = 0;i < reflection.variables.length; ++i) {
            accessibleVariables.push(reflection.variables[i]);
        }

        for(i = 0;i < reflection.accessors.length; ++i) {
            if(reflection.accessors[i].access != AccessType.READWRITE) {
                continue;
            }
            accessibleVariables.push(reflection.accessors[i]);
        }
        for(i = 0;i < accessibleVariables.length; ++i) {
            var variable:ReflectionObject = accessibleVariables[i];
            var metadata:ReflectionMetadata = variable.getMetadata("JSON");
            //check null value
            if(!keepNullValue) {
                var nullValue:* = null;
                if(metadata && metadata.hasArgument("nullValue")) {
                    nullValue = metadata.getArgument("nullValue").value;
                }
                if(serializable[variable.name] == nullValue) {
                    continue;
                }
            }

            //check transient and property name
            var property:String = variable.name;
            if(metadata) {
                if(metadata.hasArgument("transient") || metadata.hasDirectArgValue("transient")) {
                    continue;
                }
                var arg:ReflectionArgument = metadata.getArgument("name");
                if(arg != null) {
                    property = String(arg.value);
                }
            }
            obj[property]  = value2Json(serializable[variable.name],keepNullValue);
        }
        return obj;
    }


    public static function json2ClassObject(json:Object,value:JSONSerializable):void {
        if(value == null) {
            return ;
        }
        var reflection:ReflectionClass = new ReflectionClass(value);
        var accessibleVariables:Vector.<ReflectionObject> = new Vector.<ReflectionObject>();
        var i:int;
        for(i = 0;i < reflection.variables.length; ++i) {
            accessibleVariables.push(reflection.variables[i]);
        }

        for(i = 0;i < reflection.accessors.length; ++i) {
            if(reflection.accessors[i].access != AccessType.READWRITE) {
                continue;
            }
            accessibleVariables.push(reflection.accessors[i]);
        }

        for each (var variable:ReflectionObject in accessibleVariables) {
            var jsonMetadata:ReflectionMetadata = variable.getMetadata("JSON");
            var propertyName:String = variable.name;
            if(jsonMetadata) {
                if(jsonMetadata.hasDirectArgValue("transient") || jsonMetadata.hasArgument("transient")) {
                    continue;
                }
                var arg:ReflectionArgument = jsonMetadata.getArgument("name");
                if(arg != null) {
                    propertyName = String(arg.value);
                }
            }

            if(json.hasOwnProperty(propertyName)) {
                var jsonValue:* = json[propertyName];
                if(isPrimitiveType(jsonValue) || jsonValue == null) {
                    value[variable.name] = jsonValue;
                } else if(jsonValue is Array) {
                    var jsonArray:Array = jsonValue as Array;
                    var arr:Array = [];
                    var typeArg:ReflectionArgument = jsonMetadata ? jsonMetadata.getArgument("arrayDataType") : null;
                    var clss:Class = typeArg ?  getDefinitionByName(String(typeArg.value)) as Class : null;
                    for(i = 0;i < jsonArray.length; ++i) {
                        var arrItemValue:* = clss ? new clss() : null;
                        if(!(arrItemValue is JSONSerializable)) {
                            arr.push(jsonArray[i]);
                        } else {
                            json2ClassObject(jsonArray[i],arrItemValue as JSONSerializable)
                            arr.push(arrItemValue);
                        }
                    }
                    value[variable.name] = arr;
                } else if( jsonValue is Object) {
                    if(value[variable.name] == null) {
                        var type:String = null;
                        var accessor:ReflectionAccessor = variable as ReflectionAccessor;
                        if(accessor) {
                            type = accessor.type;
                        } else {
                            var rv:ReflectionVariable = variable as ReflectionVariable;
                            if(rv) {
                                type = rv.type;
                            }
                        }
                        var clazz:Class = type != null ? getDefinitionByName(type) as Class : null;
                        if(clazz != null) {
                            value[variable.name] = new clazz();
                        } else {
                            throw new Error("Cannot determine class type of property " + variable.name);
                        }
                    }
                    if(value[variable.name] is JSONSerializable) {
                        json2ClassObject(jsonValue,value[variable.name]);
                    } else if(type == 'Object') {
                        value[variable.name] = jsonValue;
                    } else {
                        throw new Error("Any Object property must implements JSONSerializable");
                    }
                }
            }
        }

    }

    private static function value2Json(value:*,keepNullValue:Boolean = true):Object {
        var i:int;
        if(value is Array) {
            var arr:Array = [];
            var valueArr:Array = value as Array;
            for(i = 0;i < valueArr.length; ++i) {
                arr.push(value2Json(valueArr[i],keepNullValue));
            }
            return arr;
        }

        if(isPrimitiveType(value) || value == null) {
            return value;
        }

        if(value is JSONSerializable) {
            return jsonSerialize(value,keepNullValue);
        }
        var clss:String = getQualifiedClassName(value);
        if(clss == 'Object') {
            return value;
        } else {
            throw new Error("Object must implements JSONSerializable.");
        }
        return value;
    }

    private static function isPrimitiveType(value:*):Boolean {
        return value is String || value is Number
                || value is int || value is uint
                || value is Boolean;
    }


    public static function getClassDefinition(value:*):Class {
        return getDefinitionByName(getQualifiedClassName(value)) as Class;
    }

}
}
