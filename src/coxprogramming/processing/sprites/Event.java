package coxprogramming.processing.sprites;

/*
 * Original author: Stephcraft
 */

import java.lang.reflect.Method;
import java.util.ArrayList;

/**
 * A flexible event system that lets different parts of your game
 * communicate with each other without needing to be directly connected.
 *
 * <p>The idea is simple: one object <em>triggers</em> an event (something
 * happened), and any number of other objects that have been <em>bound</em>
 * to that event will have one of their methods called automatically.</p>
 *
 * <p>This pattern is sometimes called the <em>Observer</em> pattern — the
 * event is the thing being watched, and the bound functions are the observers.</p>
 *
 * <p>Example — a "coin collected" event that takes no arguments:
 * <pre>
 *   Event onCoinCollected = new Event();
 *
 *   // In setup():
 *   onCoinCollected.bind(scoreBoard, "incrementScore");
 *
 *   // When a coin is collected:
 *   onCoinCollected.trigger();
 * </pre></p>
 *
 * <p>Example — an event that passes the number of points earned:
 * <pre>
 *   Event onScore = new Event(Integer.class);
 *   onScore.bind(hud, "showPoints");   // hud must have: void showPoints(int n)
 *   onScore.trigger(100);
 * </pre></p>
 */
public class Event {

    private Class<?>[] args;
    private ArrayList<EventListener> eventListeners;

    private class EventListener {
        public Method method;
        public Object listener;

        public EventListener(Object listener, Method method) {
            this.listener = listener;
            this.method = method;
        }

        public void invoke(Object[] arguments) {
            try {
                method.invoke(listener, arguments);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public boolean equals(Object obj) {
            if (obj instanceof EventListener) {
                EventListener other = (EventListener) obj;
                return other.listener.equals(listener) && other.method.equals(method);
            }
            return false;
        }

        @Override
        public int hashCode() {
            int className    = method.getDeclaringClass().getName().hashCode();
            int functionName = method.getName().hashCode();
            int parameters   = method.getParameterTypes().hashCode();
            return className ^ functionName ^ parameters;
        }
    }

    /**
     * Creates a new Event and declares what types of values it will pass
     * to its listeners when triggered.
     *
     * <p>Use Java wrapper types to describe the parameter types
     * (e.g. {@code Integer.class} for an int, {@code Float.class} for a float).
     * If the event passes no values, call with no arguments:
     * {@code new Event()}.</p>
     *
     * @param args the parameter types that will be passed when this event fires
     */
    public Event(Class<?>... args) {
        this.args = args;
        this.eventListeners = new ArrayList<EventListener>();
    }

    /**
     * Fires the event, calling every bound listener function and passing
     * {@code arguments} to each one.
     * The types and order of {@code arguments} must match what was declared
     * in the constructor.
     *
     * @param arguments the values to pass to each listener
     */
    public void trigger(Object... arguments) {
        for (EventListener el : eventListeners) {
            try {
                el.invoke(arguments);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Attaches a listener function to this event so it will be called
     * whenever {@link #trigger(Object...)} is invoked.
     *
     * <p>{@code listener} is the object that owns the function, and
     * {@code name} is the exact name of the method as a String.
     * The method's parameter types must match the types declared in the
     * Event's constructor.</p>
     *
     * <p>The same function cannot be bound more than once — a warning is
     * printed to the console if you try.</p>
     *
     * @param listener the object that contains the method to call
     * @param name     the name of the method to call
     */
    public void bind(Object listener, String name) {
        Class<?> c = listener.getClass();
        try {
            Method method = c.getMethod(name, args);
            EventListener el = new EventListener(listener, method);
            if (!eventListeners.contains(el)) {
                eventListeners.add(el);
            } else {
                System.err.println("[Event] already bound: \"" + name + "\"");
            }
        } catch (Exception e) {
            System.err.println("[Event] could not bind \"" + name + "\": check parameter types match Event constructor");
        }
    }

    /**
     * Detaches a previously bound listener function from this event so it
     * will no longer be called when the event fires.
     * A warning is printed if the function was not already bound.
     *
     * @param listener the object that owns the method
     * @param name     the name of the method to remove
     */
    public void unbind(Object listener, String name) {
        Class<?> c = listener.getClass();
        try {
            Method method = c.getMethod(name, args);
            EventListener el = new EventListener(listener, method);
            if (eventListeners.contains(el)) {
                eventListeners.remove(el);
            } else {
                System.err.println("[Event] not bound: \"" + name + "\"");
            }
        } catch (Exception e) {
            System.err.println("[Event] could not unbind \"" + name + "\": check parameter types match Event constructor");
        }
    }

    /**
     * Returns {@code true} if the given function is currently bound to
     * this event, or {@code false} if it is not.
     * Use this to avoid binding the same function twice.
     *
     * @param listener the object that owns the method
     * @param name     the name of the method to check
     * @return {@code true} if bound, {@code false} if not
     */
    public boolean bound(Object listener, String name) {
        Class<?> c = listener.getClass();
        try {
            Method method = c.getMethod(name, args);
            return eventListeners.contains(new EventListener(listener, method));
        } catch (Exception e) {
            System.err.println("[Event] invalid function \"" + name + "\" in bound()");
        }
        return false;
    }
}
