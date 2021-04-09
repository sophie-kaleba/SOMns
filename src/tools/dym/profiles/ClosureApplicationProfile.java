package tools.dym.profiles;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import com.oracle.truffle.api.source.SourceSection;

import som.interpreter.Invokable;
import som.interpreter.objectstorage.ClassFactory;
import tools.dym.nodes.TypeProfileNode;


public class ClosureApplicationProfile extends Counter implements CreateCounter {

  private final Map<Invokable, ActivationCounter> callTargetMap;

  @SuppressWarnings("unused") private TypeProfileNode typeProfile;


  public ClosureApplicationProfile(final SourceSection source) {
    super(source);
    callTargetMap = new HashMap<>();
  }

  // TODO: remove code duplication with CallsiteProfile

  public ActivationCounter createCounter(final Invokable invokable) {
    ActivationCounter c = callTargetMap.get(invokable);
    if (c != null) {
      return c;
    }
    c = new ActivationCounter();
    callTargetMap.put(invokable, c);
    return c;
  }

  @Override
  public ReadValueProfile.ProfileCounter createCounter(final ClassFactory type) {
    ReadValueProfile.ProfileCounter counter = new ReadValueProfile.ProfileCounter(type);
    //receiverCounters.add(counter);
    return counter;
  }

  public Map<Invokable, Integer> getCallTargets() {
    HashMap<Invokable, Integer> result = new HashMap<>();
    for (Entry<Invokable, ActivationCounter> e : callTargetMap.entrySet()) {
      result.put(e.getKey(), e.getValue().val);
    }
    return result;
  }

  public void setReceiverProfile(final TypeProfileNode rcvrProfile) {
    this.typeProfile = rcvrProfile;
  }

  public static final class ActivationCounter {
    private int val;

    public void inc() {
      val += 1;
    }
  }
}
