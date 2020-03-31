package com.examples.functions;

import java.util.*;
import com.microsoft.azure.functions.annotation.*;
import com.microsoft.azure.functions.*;

/**
 * Azure Functions with HTTP Trigger.
 */
public class Function {

    @FunctionName("generateSensorData")
    @EventHubOutput(name = "event", eventHubName = "", connection = "EventHubConnectionString")
    public TelemetryItem generateSensorData(@TimerTrigger(name = "TimerInfo", schedule = "*/10 * * * * *") String timerInfo,
                                            final ExecutionContext context) {

        context.getLogger().info("Java Timer trigger function executed at: "
                + java.time.LocalDateTime.now());
        double temperature = Math.random() * 100;
        double pressure = Math.random() * 50;
        return new TelemetryItem(temperature, pressure);
    }

    @FunctionName("procesSensorData")
    public void processSensorData(
            @EventHubTrigger(name = "msg",
                    eventHubName = "",
                    connection = "EventHubConnectionString") TelemetryItem item,
            @CosmosDBOutput(name = "databaseoutput",
                    databaseName = "TelemetryDb",
                    collectionName = "TelemetryInfo",
                    connectionStringSetting = "CosmosDBConnectionString") OutputBinding<TelemetryItem> document,
            final ExecutionContext context) {

        context.getLogger().info("Event hub message received: " + item.toString());

        if (item.getPressure() > 30) {
            item.setNormalPressure(false);
        } else {
            item.setNormalPressure(true);
        }

        if (item.getTemperature() < 40) {
            item.setTemperatureStatus(TelemetryItem.status.COOL);
        } else if (item.getTemperature() > 90) {
            item.setTemperatureStatus(TelemetryItem.status.HOT);
        } else {
            item.setTemperatureStatus(TelemetryItem.status.WARM);
        }
        document.setValue(item);
    }
}
