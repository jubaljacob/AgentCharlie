package strategy;

public class Map {
    private int xCoordinate;
    private int yCoordinate;
    private String details;
    private String type;
    private String agentName;

    Map(Builder builder) {
        this.xCoordinate = builder.xCoordinate;
        this.yCoordinate = builder.yCoordinate;
        this.details = builder.details;
        this.type = builder.type;
        this.agentName = builder.agentName;
    }

    public int getXCoordinate() {
        return xCoordinate;
    }

    public int getYCoordinate() {
        return yCoordinate;
    }

    public String getDetails() {
        return details;
    }

    public String getType() {
        return type;
    }

    public String getAgentName() {
        return agentName;
    }

    // Builder class
    public static class Builder {
        private int xCoordinate;
        private int yCoordinate;
        private String details;
        private String type;
        private String agentName;

        public Builder setXCoordinate(int xCoordinate) {
            this.xCoordinate = xCoordinate;
            return this;
        }

        public Builder setYCoordinate(int yCoordinate) {
            this.yCoordinate = yCoordinate;
            return this;
        }

        public Builder setDetails(String details) {
            this.details = details;
            return this;
        }

        public Builder setType(String type) {
            this.type = type;
            return this;
        }

        public Builder setAgentName(String agentName) {
            this.agentName = agentName;
            return this;
        }

        public Map build() {
            return new Map(this);
        }
    }
}
