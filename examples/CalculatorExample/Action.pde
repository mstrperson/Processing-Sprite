/**
 * A functional interface that represents a single executable action.
 *
 * A <em>functional interface</em> is an interface with exactly one method.
 * That makes it compatible with Java <em>lambda expressions</em> — a compact
 * way to write a small piece of code that can be passed around as a value:
 *
 * <pre>
 *   () -> digitPressed("7")
 * </pre>
 *
 * The {@code ()} means "no parameters" and {@code ->} separates them from the
 * body.  The whole expression creates an {@code Action} whose {@link #execute()}
 * method calls {@code digitPressed("7")}.
 *
 * This is the foundation of the <em>Strategy pattern</em> used in
 * {@link Button}: each button is told <em>what to do</em> when clicked by
 * handing it an {@code Action}, rather than hardcoding that logic inside the
 * button itself.
 */
interface Action {

  /**
   * Executes this action.
   * The body is supplied by whoever creates the {@code Action} — typically
   * via a lambda expression passed to {@link Button#onClicked(Action)}.
   */
  void execute();
}
