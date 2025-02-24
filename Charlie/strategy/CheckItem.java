package charlie;

import jason.JasonException;
import jason.NoValueException;
import jason.asSyntax.*;
import jason.environment.Environment;
import jason.asSemantics.*;
import java.util.ArrayList;
import massim.eismassim.EnvironmentInterface;

import SharedMemory;

public class CheckItem extends DefaultInternalAction {
    
    // @Override
    // public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    //     try {
    //         if (testList == null) {
    //             logger.warning("testList is null.");
    //             return false;
    //         }

    //         String size = testList.size().toString();
    //         System.err.println("HAHAHAHAHAHAHHAHAHAHAHAHAHAHHAHA SIZE: " + size);
            
    //         Term t = new ObjectTermImpl(new String(size));
    //         return un.unifies(args[0], t);
    //     } catch (Exception e) {
    //         System.err.println("Error in internal action: " + e.getMessage());
    //     }
    //     return false;
    // }
}