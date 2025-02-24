public class CheckItem extends DefaultInternalAction implements instance {
    
    private Logger logger = Logger.getLogger("ObjectTerm." + CheckItem.class.getName());

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        try {
            if (testList == null) {
                logger.warning("testList is null.");
                return false;
            }

            String size = testList.size().toString();
            logger.info("Size of testList: " + size);
            System.err.println("HAHAHAHAHAHAHHAHAHAHAHAHAHAHHAHA SIZE: " + size);
            
            Term t = new ObjectTermImpl(new String(size));
            return un.unifies(args[0], t);
        } catch (Exception e) {
            logger.warning("Error in internal action: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}