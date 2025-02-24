package charlie;

import Map;

public class SharedMemory {

    private static ArrayList<Map> mapList = new ArrayList<Map>();

    public static ArrayList<Map> getLocationList() {
        return this.mapList;
    }
    
    public static void addItem(Map item) {
        this.mapList.add(item);
    }

    public static Integer getCount() {
        this.mapList.size();
    }

}
