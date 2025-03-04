package mypackage;

import jason.asSemantics.*;
import jason.asSyntax.*;
import java.util.ArrayList;
import java.util.Random;
import java.util.*;


public class MyAction extends DefaultInternalAction {
    ArrayList<String[]> map = new ArrayList<>();
    ArrayList<String[]> tasks = new ArrayList<>();
    int properlength = 0;
    int tasklength = 0;
    int state = -1; // To decide what stage of things the agent is on, and the next step to take
    private int targetX = 0, targetY = 0;
    int dir = 0;
    int attached = 0;
    String type = "";
    String name = "";
    int x1 = 0;
    int y1 = 0;
    int x2 = 0;
    int y2 = 0;
    int attempt = 0;
    boolean attemptsubmit = false;
    int direction = 0;
    int stepstaken = 0;
    int priorstate = 0;
    boolean rotation = false;
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        
        String termAsString = args[0].toString();
        int function = Integer.valueOf(termAsString);
        
        
        if (function == 1) {

            

            int action = 0;
            String lastaction = args[6].toString();
            String lastresult = args[5].toString();

            if(lastaction.equals("rotate") && lastresult.equals("failed") ){ 
                if (rotation == false) {
                    rotation = true;
                } else if (rotation == false)  {
                    rotation = false;
                }
            }
            
            if (state == -1) {
                action = 0;
                state = 0;
            }
            else if (state == 0) {
                int distancetoclosestdispenser = 1000;
                int timeforpickup = 0;
                
                int x = 0;
                int y = 0;
                for(int i = 0; i < map.size(); i++) {
                    String[] entry = map.get(i);
                    
                    
                    if (entry[2].equals("dispenser")) {
                        x = Integer.valueOf(entry[0]);
                        y = Integer.valueOf(entry[1]);

                        int sum = Math.abs(x) + Math.abs(y);
                        
                        if (sum < distancetoclosestdispenser) {
                            distancetoclosestdispenser = sum;
                            targetX = x;
                            targetY = y;
                        }
                    }
                }
                //System.out.println("closest Dispenser is " + distancetoclosestdispenser + " far away at X:" + targetX + " Y:" + targetY);

                if (distancetoclosestdispenser > 100){
                    action = 100;
                } else{
                    state = 1;
                }

            } else if (state == 1) { 
                boolean targetReached = (Math.abs(targetX) == 1 && targetY == 0) || (Math.abs(targetY) == 1 && targetX == 0);
                //System.out.println("closest Dispenser at X:" + targetX + " Y:" + targetY);
                if (!targetReached) {
                    if (Math.abs(targetX) > 0) {
                        action = targetX > 0 ? 4 : 3; // Move East/West
                        targetX += (targetX > 0) ? -1 : 1;
                    } else if (Math.abs(targetY) > 0) {
                        action = targetY > 0 ? 2 : 1; // Move South/North
                        targetY += (targetY > 0) ? -1 : 1;
                    } else if (targetX == 0 && targetY == 0) {
                        action = 1;
                        state = 0;
                    }
                } else if (targetReached){
                    state = 2; // Arrived at correct position
                    action = 0;
                }
            } else if (state == 2) { 
                boolean targetReached = (Math.abs(targetX) == 1 && targetY == 0) || (Math.abs(targetY) == 1 && targetX == 0);
                int distancetoclosestdispenser = 1000;
                int x = 0;
                int y = 0;
                for(int i = 0; i < map.size(); i++) {
                    String[] entry = map.get(i);
                    
                    if (entry[2].equals("dispenser")) {
                        x = Integer.valueOf(entry[0]);
                        y = Integer.valueOf(entry[1]);

                        int sum = Math.abs(x) + Math.abs(y);
                        
                        if (sum < distancetoclosestdispenser) {
                            distancetoclosestdispenser = sum;
                            targetX = x;
                            targetY = y;
                            type = entry[3];
                            
                        }
                    }
                }
                //System.out.println("Distance is: " + distancetoclosestdispenser);
                if (distancetoclosestdispenser != 1){
                    state = 0;
                } else {
                    if (targetX == -1 && targetY == 0) {
                        action = 7; // Request block from East
                        dir = 4;
                        state = 3;
                    } else if (targetX == 1 && targetY == 0) {
                        action = 8; // Request block from West
                        dir = 3;
                        state = 3;
                    } else if (targetX == 0 && targetY == 1) {
                        action = 6; // Request block from South
                        dir = 2;
                        state = 3;
                    } else if (targetX == 0 && targetY == -1) {
                        dir = 1;
                        action = 5; // Request block from North
                        state = 3;
                    }
                }
            } else if (state == 3) { 
                if(dir == 1){
                    action = 9;
                    state = 4;
                } else if(dir == 2){
                    action = 10;
                    state = 4;
                } else if(dir == 3){
                    action = 12;
                    state = 4;
                } else if(dir == 4){
                    action = 11;
                    state = 4;
                } 
            } else if (state == 4) { 
                if (rotation == false) { 
                    action = 13;
                } else if (rotation == true) { 
                    action = 14;
                }
                state = 2;
                attached = attached + 1;
                if(attached > 3){
                    state = 5;
                }
            } else if (state == 5) { 
                int distancetoclosestgoal = 1000;
                int timeforpickup = 0;
                int entityx = 0;
                int entityy = 0; 
                int x = 0;
                int y = 0;
                boolean checkentity = false;
                for(int i = 0; i < map.size(); i++) {
                    String[] entry = map.get(i);
                    //System.out.println("Checking " + entry[2] + " far away at X:" + entry[0] + " Y:" + entry[1]);
                    
                    if (entry[2].equals("Goal")) {
                        x = Integer.valueOf(entry[0]);
                        y = Integer.valueOf(entry[1]);

                        int sum = Math.abs(x) + Math.abs(y);
                        
                        if (sum < distancetoclosestgoal) {
                            distancetoclosestgoal = sum;
                            targetX = x;
                            targetY = y;
                        }
                    } else if (entry[2].equals("entity")) { 
                        entityx = Integer.valueOf(entry[0]);
                        entityy = Integer.valueOf(entry[1]);

                        if (entityx != 0 || entityy != 0){
                            checkentity = true;
                        }
                    }
                }
                //System.out.println("closest Goal is " + distancetoclosestgoal + " far away at X:" + targetX + " Y:" + targetY);

                if (distancetoclosestgoal > 100){
                    action = 100;
                } else{
                    state = 6;
                }

                if(checkentity == true) { 
                    if ((Math.abs(entityx - x) <= 1 && Math.abs(entityy - y) <= 1) && distancetoclosestgoal < 100) {
                        priorstate = 5;
                        state = 20;
                        action = 0;
                    }
                }


                
            } else if (state == 6) {
                boolean targetReached = (Math.abs(targetX) == 0 && targetY == 0);
                //System.out.println("closest Dispenser at X:" + targetX + " Y:" + targetY);
                if (!targetReached) {
                    if (Math.abs(targetX) > 0) {
                        action = targetX > 0 ? 4 : 3; // Move East/West
                        targetX += (targetX > 0) ? -1 : 1;
                        if (action == 4){
                            dir = 4;
                        } else if (action == 3){
                            dir = 3;
                        }
                    } else if (Math.abs(targetY) > 0) {
                        action = targetY > 0 ? 2 : 1; // Move South/North
                        targetY += (targetY > 0) ? -1 : 1;
                        if (action == 2){
                            dir = 2;
                        } else if (action == 1){
                            dir = 1;
                        }
                    } 
                } else if (targetReached){
                    boolean cont = false;
                    for(int i = 0; i < map.size(); i++) {
                        String[] entry = map.get(i);
                        //System.out.println("Checking " + entry[2] + " far away at X:" + entry[0] + " Y:" + entry[1]);
                        
                        if (entry[2].equals("Goal")) {
                            int x = Integer.valueOf(entry[0]);
                            int y = Integer.valueOf(entry[1]);
    
                            int sum = Math.abs(x) + Math.abs(y);
                            
                            if (sum < 1) {
                                cont = true;
                            }
                        } 
                    }

                    if (cont == true) {
                        state = 8; // Arrived at correct position
                        action = 0; 
                    } else {
                        state = 5; // Arrived at correct position
                        action = 0; 
                    }

                    
                }


                
            } else if (state == 7) {  
                boolean checkentity = false; 
                int x = 0;
                int y = 0;
                
                for(int i = 0; i < map.size(); i++) {
                    String[] entry = map.get(i);
                    
                    
                    //System.out.println("Checking " + entry[2] + " far away at X:" + entry[0] + " Y:" + entry[1]);
                    
                    if (entry[2].equals("Goal")) {
                        x = Integer.valueOf(entry[0]);
                        y = Integer.valueOf(entry[1]);
                        if (x == 1 && y == 0) {
                            action = 4;
                            state = 8;
                        } else if (x == -1 && y == 0){
                            action = 3;
                            state = 8;
                        } else if (x == 0 && y == 1){
                            action = 2;
                            state = 8;
                        } else if (x == 0 && y == -1){
                            action = 1;
                            state = 8;
                        }
                    } 
                }
                

                
            } else if (state == 8) {
                for(int i = 0; i < tasks.size(); i++) {
                    String[] entry = tasks.get(i);
                    if (entry[5].equals(type)) {
                        x1 = Integer.valueOf(entry[3]);
                        y1 = Integer.valueOf(entry[4]);
                        name = entry[0];  
                    }
                }
                un.unifies(args[3], new StringTermImpl(name));

                boolean progress = false;
                for(int i = 0; i < map.size(); i++) {
                    String[] entry = map.get(i);
                    
                    
                    //System.out.println("Checking " + entry[2] + " far away at X:" + entry[0] + " Y:" + entry[1]);
                    
                    if (entry[2].equals("Goal")) {
                        int x = Integer.valueOf(entry[0]);
                        int y = Integer.valueOf(entry[1]);
                        if (x == 0 || y == 0) {
                            
                            progress = true;
                        } 
                    } 
                }

                if(progress == true) { 
                    action = 0;
                    state = 9;
                } else if (progress == false) { 
                    action = 0;
                    state = 5;
                }
                
            } else if (state == 9) {
                un.unifies(args[3], new StringTermImpl(name));
                action = 0;
                
                int connectedblocks = 0;
                Set<String> printedBlocks = new HashSet<>();
                for (int i = 0; i < map.size(); i++) {
                    String[] entry = map.get(i);
                    if (entry[2].equals("block") && entry[3].equals(type)) {
                        String blockKey = entry[0] + "," + entry[1] + "," + type;
                        if (!printedBlocks.contains(blockKey)) {
                            printedBlocks.add(blockKey);
                            x2 = Integer.valueOf(entry[0]);
                            y2 = Integer.valueOf(entry[1]);
                            if((x2 == 0 && y2 == 1) || (x2 == 0 && y2 == -1) || (x2 == 1 && y2 == 0) || (x2 == -1 && y2 == 0)) {
                                connectedblocks = connectedblocks + 1;
                            }
                        }
                    }
                }
                //System.out.println("Task asks for Blocks at X:" + x1 + " Y:" + y1 + " of type: " + type);
                //System.out.println("Past Attempt Last Turn: " + attemptsubmit + " Number of attempts: " + attempt);
                if(attemptsubmit == false){
                    action = 15;
                    attempt = attempt + 1;
                    attemptsubmit = true;
                } else if (attemptsubmit == true) { 
                    if (rotation == false) { 
                        action = 13;
                    } else if (rotation == true) { 
                        action = 14;
                    }
                    attemptsubmit = false;
                }
                if (attempt > 4) {
                    state = 8;
                    attempt = 0;
                }

                if (connectedblocks < 1) {
                    state = 0;
                    action = 0;
                    attached = 0;
                }
            }   else if (state == 20) { 
                if(direction == 0){
                    Random random = new Random();
                    direction = random.nextInt(4) + 1;
                } else if (direction == 1) {
                    action = 1;
                    stepstaken = stepstaken + 1;
                } else if (direction == 2) {
                    action = 2;
                    stepstaken = stepstaken + 1;
                } else if (direction == 3) {
                    action = 3;
                    stepstaken = stepstaken + 1;
                } else if (direction == 4) {
                    action = 4;
                    stepstaken = stepstaken + 1;
                } 

                if (stepstaken > 5) {
                    action = 0;
                    stepstaken = 0;
                    if(priorstate == 3){
                        state = 0;
                    } else if (priorstate == 5) {
                        state = 5;
                    }
                }
            }

            if(lastaction.equals("move") && (lastresult.equals("failed_path") || lastresult.equals("failed_forbidden"))){
                if(action == 1){ 
                    action = 3;
                } else if (action == 2) {
                    action = 4;
                } else if (action == 3) {
                    action = 1;
                } else if (action == 4) {
                    action = 2;
                }
            } 

    

            if(state == 3) {
                boolean shouldntattach = false;
                int x = 0;
                int y = 0;
                for (int i = 0; i < map.size(); i++) {
                    String[] entry = map.get(i);
                    if (entry[2].equals("entity")) {
                        x = Integer.valueOf(entry[0]);
                        y = Integer.valueOf(entry[1]);

                        int sum = Math.abs(x) + Math.abs(y);
                        
                        if(sum < 3 && sum > 0){
                            shouldntattach = true;
                        }
                        
                    }
                }
                if (shouldntattach == true) {
                    action = 0;
                    state = 20;
                    priorstate = 3;
                }
            }

            
            
            
            tasks.clear();
            map.clear();
            properlength = 0;
            //System.out.println("Current State: " + state);
            un.unifies(args[2], new NumberTermImpl(state));
            
            if(action == 0){
                //Stays stationary and does nothing
                return un.unifies(args[1], new NumberTermImpl(0));
            } else if(action == 1){
                //Moves north
                return un.unifies(args[1], new NumberTermImpl(1));
            } else if(action == 2){
                //Moves south
                return un.unifies(args[1], new NumberTermImpl(2));
            } else if(action == 3){
                //Moves west
                return un.unifies(args[1], new NumberTermImpl(3));
            } else if(action == 4){
                //Moves East
                return un.unifies(args[1], new NumberTermImpl(4));
            } else if(action == 5){
                //Requests a block northward
                return un.unifies(args[1], new NumberTermImpl(5));
            } else if(action == 6){
                //Requests a block southward
                return un.unifies(args[1], new NumberTermImpl(6));
            } else if(action == 7){
                //Requests a block westward
                return un.unifies(args[1], new NumberTermImpl(7));
            } else if(action == 8){
                //Requests a block eastward
                return un.unifies(args[1], new NumberTermImpl(8));
            } else if(action == 9){
                //Connects a block northward
                return un.unifies(args[1], new NumberTermImpl(9));
            } else if(action == 10){
                //Connects a block southward
                return un.unifies(args[1], new NumberTermImpl(10));
            } else if(action == 11){
                //Connects a block westward
                return un.unifies(args[1], new NumberTermImpl(11));
            } else if(action == 12){
                //Connects a block eastward
                return un.unifies(args[1], new NumberTermImpl(12));
            } else if(action == 13){
                //Rotate CW
                return un.unifies(args[1], new NumberTermImpl(13));
            } else if(action == 14){
                //Rotate CCW
                return un.unifies(args[1], new NumberTermImpl(14));
            } else if(action == 15){
                //Rotate CCW
                return un.unifies(args[1], new NumberTermImpl(15));
            } else if(action == 100){
                return un.unifies(args[1], new NumberTermImpl(100));
            }
            
        } else if (function == 2) {
            // Coordinates of the object
            String X = args[1].toString();
            String Y = args[2].toString();
            
            // Details on the object (Is it a dispenser, an entity, a block, etc)
            String Details = args[3].toString();
            // Further details, such as if dispenser is b0 or b1
            String Type = args[4].toString();
            String[] entry = {X, Y, Details, Type};
            map.add(entry);
            properlength = properlength + 1;
        } else if (function == 3) {
            String X = args[1].toString();
            String Y = args[2].toString();
            String Details = "Goal";
            String Type = "Goal";

            String[] entry = {X, Y, Details, Type};
            map.add(entry);
            properlength = properlength + 1;
        } else if (function == 4) {
            String taskname = args[1].toString();
            String stepsleft = args[2].toString();
            String reward = args[3].toString();
            String input = args[4].toString();
            
            List<List<String>> extractedData = new ArrayList<>();

            if (input.startsWith("[") && input.endsWith("]")) {
                input = input.substring(1, input.length() - 1); // Remove outer brackets
            }

            String[] parts = input.split("\\),req\\(");

            for (int i = 0; i < parts.length; i++) {
                parts[i] = parts[i].replace("req(", "").replace(")", ""); // Clean up "req(" and ")"
                String[] values = parts[i].split(","); // Split by ","

                List<String> parsedValues = Arrays.asList(values[0], values[1], values[2]);
                extractedData.add(parsedValues);
            }

            String tX = "";
            String tY = "";
            String ttype = "";

            if (extractedData.size() == 1) {
                tX = extractedData.get(0).get(0);
                tY = extractedData.get(0).get(1);
                ttype = extractedData.get(0).get(2);

                //System.out.println("X: " + tX + " Y:" + tY + " Type:" + ttype);
            } 
            String[] entry = {taskname, stepsleft, reward, tX, tY, ttype};
            tasks.add(entry);
            tasklength = tasklength + 1;
        } else  {
            System.out.println("Not workin");
        }

        return true;
    }
}
