import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class Stuff extends Schema {
	@:type("string")
	public var mySynchronizedProperty: String = "";

	@:type("string")
	public var chatHist: String = "";

	@:type("int32")
	public var axY: Int = 0;
}
