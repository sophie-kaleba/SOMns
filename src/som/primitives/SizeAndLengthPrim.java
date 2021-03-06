package som.primitives;

import com.oracle.truffle.api.dsl.GenerateNodeFactory;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.instrumentation.Tag;

import bd.primitives.Primitive;
import som.interpreter.nodes.nary.UnaryBasicOperation;
import som.vmobjects.SArray;
import som.vmobjects.SSymbol;
import tools.dym.Tags.OpLength;


@GenerateNodeFactory
@Primitive(primitive = "arraySize:", selector = "size", receiverType = SArray.class,
    inParser = false)
@Primitive(primitive = "stringLength:", selector = "length", receiverType = String.class,
    inParser = false)
public abstract class SizeAndLengthPrim extends UnaryBasicOperation {

  @Override
  protected boolean hasTagIgnoringEagerness(final Class<? extends Tag> tag) {
    if (tag == OpLength.class) {
      return true;
    } else {
      return super.hasTagIgnoringEagerness(tag);
    }
  }

  @Specialization(guards = "receiver.isEmptyType()")
  public final long doEmptySArray(final SArray receiver) {
    return receiver.getEmptyStorage();
  }

  @Specialization(guards = "receiver.isPartiallyEmptyType()")
  public final long doPartialEmptySArray(final SArray receiver) {
    return receiver.getPartiallyEmptyStorage().getLength();
  }

  @Specialization(guards = "receiver.isObjectType()")
  public final long doObjectSArray(final SArray receiver) {
    return receiver.getObjectStorage().length;
  }

  @Specialization(guards = "receiver.isLongType()")
  public final long doLongSArray(final SArray receiver) {
    return receiver.getLongStorage().length;
  }

  @Specialization(guards = "receiver.isDoubleType()")
  public final long doDoubleSArray(final SArray receiver) {
    return receiver.getDoubleStorage().length;
  }

  @Specialization(guards = "receiver.isBooleanType()")
  public final long doBooleanSArray(final SArray receiver) {
    return receiver.getBooleanStorage().length;
  }

  public abstract long executeEvaluated(Object receiver);

  public abstract long executeEvaluated(SArray receiver);

  @Specialization
  public final long doString(final String receiver) {
    return receiver.length();
  }

  @Specialization
  public final long doSSymbol(final SSymbol receiver) {
    return receiver.getString().length();
  }
}
