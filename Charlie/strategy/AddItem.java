
public class AddItem extends DefaultInternalAction implements instance{
    
    private Logger logger = Logger.getLogger("ObjectTerm."+CheckItem.class.getName());

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        try {
            String termAsString = args[0].toString();
            testList.add("a");
            
            String size = testList.size().toString();
            System.err.println("HAHAHAHAHAHAHHAHAHAHAHAHAHAHHAHA SIZE: " + size);
            Term t = new ObjectTermImpl(new String(size));
            return true;

            return un.unifies(args[0], t);
        } catch (Exception e) {
            logger.warning("Error ininternal action.");
        }
        return false;
    }

}
