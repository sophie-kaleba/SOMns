package som.primitives.arrays;

import com.oracle.truffle.api.dsl.GenerateNodeFactory;
import com.oracle.truffle.api.dsl.NodeFactory;
import com.oracle.truffle.api.dsl.Specialization;

import bd.primitives.Primitive;
import bd.primitives.Specializer;
import som.VM;
import som.interpreter.nodes.ExpressionNode;
import som.interpreter.nodes.nary.BinaryExpressionNode;
import som.vm.constants.Classes;
import som.vmobjects.SArray.SImmutableArray;
import som.vmobjects.SArray.SMutableArray;
import som.vmobjects.SArray.STransferArray;
import som.vmobjects.SClass;
import som.vmobjects.SSymbol;
import tools.dym.Tags.NewArray;


@GenerateNodeFactory
@Primitive(primitive = "array:new:", selector = "new:", inParser = false,
    specializer = NewPrim.IsArrayClass.class)
public abstract class NewPrim extends BinaryExpressionNode {
  public static class IsArrayClass extends Specializer<VM, ExpressionNode, SSymbol> {
    public IsArrayClass(final Primitive prim, final NodeFactory<ExpressionNode> fact,
        final VM vm) {
      super(prim, fact, vm);
    }

    @Override
    public boolean matches(final Object[] args, final ExpressionNode[] argNodes) {
      return args[0] instanceof SClass && ((SClass) args[0]).isArray();
    }
  }

  @Override
  protected boolean isTaggedWithIgnoringEagerness(final Class<?> tag) {
    if (tag == NewArray.class) {
      return true;
    } else {
      return super.isTaggedWithIgnoringEagerness(tag);
    }
  }

  protected static final boolean receiverIsArrayClass(final SClass receiver) {
    return receiver == Classes.arrayClass;
  }

  protected static final boolean receiverIsValueArrayClass(final SClass receiver) {
    return receiver == Classes.valueArrayClass;
  }

  protected static final boolean receiverIsTransferArrayClass(final SClass receiver) {
    return receiver == Classes.transferArrayClass;
  }

  @Specialization(guards = "receiverIsArrayClass(receiver)")
  public static final SMutableArray createArray(final SClass receiver, final long length) {
    return new SMutableArray(length, receiver);
  }

  @Specialization(guards = "receiverIsValueArrayClass(receiver)")
  public static final SImmutableArray createValueArray(final SClass receiver,
      final long length) {
    return new SImmutableArray(length, receiver);
  }

  @Specialization(guards = "receiverIsTransferArrayClass(receiver)")
  protected static final STransferArray createTransferArray(
      final SClass receiver, final long length) {
    return new STransferArray(length, receiver);
  }
}
