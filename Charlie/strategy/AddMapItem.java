package strategy;

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
            Integer xCoordinate = (int) ((NumberTerm) args[0]).solve();
            Integer yCoordinate = (int) ((NumberTerm) args[1]).solve();
            String details = args[2].toString();
            String type = args[3].toString();
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
