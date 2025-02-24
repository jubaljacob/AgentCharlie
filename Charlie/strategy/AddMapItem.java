package charlie;

import jason.JasonException;
import jason.NoValueException;
import jason.asSyntax.*;
import jason.environment.Environment;
import jason.asSemantics.*;
import java.util.ArrayList;
import massim.eismassim.EnvironmentInterface;

import SharedMemory;
import Map;

public class AddMapItem extends DefaultInternalAction {

    private ArrayList<Map> mapList = SharedMemory.getLocationList();

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        try {
            Integer xCoordinate = args[0];
            Integer yCoordinate = args[1];
            String details = args[2];
            String type = args[3];
            String agentName = ts.getUserAgArch().getAgName();
            
            Map newMemory = new Map.Builder()
                            .setXCoordinate(xCoordinate)
                            .setYCoordinate(yCoordinate)
                            .setDetails(details)
                            .setType(type)
                            .setAgentName(agentName)
                            .build();

            mapList.add(newMemory);
            
            System.out.println("From Agent: " + agentName + "Size: " + mapList.size());
            // Term t = new ObjectTermImpl(new String(size));
            return true;
        } catch (Exception e) {
            System.err.println("Error ininternal action.");
        }
        return false;
    }

}
