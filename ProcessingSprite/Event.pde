/*
 * Event library
 * @author Stephcraft
 *
 * Usage
 *  - create an Event in the class that triggers the event. Although, events could also be triggered somewhere else.
 *  - pass in the Event(...) constructor the parameter classes that will be passed to the listener functions
 *  - call Event::trigger(...) and pass in the parameters of the event. Must match the types passed in the constructor
 *  - to add listeners create a function with the matching parameters of the specific Event. Then call bind(Object listener, String functionName)
 *
 * class Event
 *    constructor() defines what are the parameter types of the event
 *    bind() will bind a function listener to the event
 *    unbind() will unbind a function listener to the event
 *    bound() returns a boolean representing if the function listener is already bound to the event or not
 */
 
import java.lang.reflect.Method;
import java.util.Arrays;

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
            }
            catch(Exception e) {
                e.printStackTrace();
            }
        }
        
        @Override
        public boolean equals(Object obj) {
            if(obj instanceof EventListener) {
                EventListener other = (EventListener)obj;
                return other.listener.equals(listener) && other.method.equals(method);
            }
            
            return false;
        }
        
        @Override
        public int hashCode() {
            int className = method.getDeclaringClass().getName().hashCode();
            int functionName = method.getName().hashCode();
            int parameters = method.getParameterTypes().hashCode();
            
            return className ^ functionName ^ parameters;
        }
    }
    
    public Event(Class<?>... args) {
        this.args = args;
        this.eventListeners = new ArrayList<EventListener>();
    }
    
    public void trigger(Object... arguments) {
        for(EventListener eventListener : eventListeners) {
            try {
                eventListener.invoke(arguments);
            }
            catch(Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    public void bind(Object listener, String name) {
        Class<?> c = listener.getClass();
        
        try {
            Method method = c.getMethod(name, args);
            EventListener eventListener = new EventListener(listener, method);
            
            if(!eventListeners.contains(eventListener)) {
                eventListeners.add(new EventListener(listener, method));
            }
            else {
                System.err.println("<Error> could not bind event listener \""+name+"\". It is already bound!");
            }
        }
        catch(Exception e) {
            System.err.println("<Error> could not bind event listener \""+name+"\". Make sure the listener and the function is valid. The parameter types must match the ones provided in the Event constructor");
        }
    }
    
    public void unbind(Object listener, String name) {
         Class<?> c = listener.getClass();
         
         try {
             Method method = c.getMethod(name, args);
             EventListener eventListener = new EventListener(listener, method);
             
             if(eventListeners.contains(eventListener)) {
                 eventListeners.remove(eventListener);
             }
             else {
                 System.err.println("<Error> could not unbind event listener \""+name+"\". Make sure the listener is already bound");
             }
         }
         catch(Exception e) {
            System.err.println("<Error> could not unbind event listener \""+name+"\". Make sure the listener and the function is valid. The parameter types must match the ones provided in the Event constructor");
        }
    }
    
    public boolean bound(Object listener, String name) {
        Class<?> c = listener.getClass();
         
         try {
             Method method = c.getMethod(name, args);
             EventListener eventListener = new EventListener(listener, method);
             
             return eventListeners.contains(eventListener);
         }
         catch(Exception e) {
            System.err.println("<Error> Event : invalid function \""+name+"\" provided in bound()");
        }
        
        return false;
    }
}
