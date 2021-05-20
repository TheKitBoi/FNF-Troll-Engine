import { Schema, Context, type } from "@colyseus/schema";
import { ChatRoom } from "../ChatRoom";

export class Stuff extends Schema {

  @type("string") mySynchronizedProperty: string = "Hello world";
  //public static stuff: string = string.mySynchronizedProperty;
  @type("string") chatHist: string = "DICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDICKDEIDKDID";

  @type("int32") axY: Number = 0;
}
