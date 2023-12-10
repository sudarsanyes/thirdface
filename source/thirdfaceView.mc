import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

class thirdfaceView extends WatchUi.WatchFace {

    var bg;
    var t1, t2, f1, f2;
    var faceRadius, viewWidth, viewHeight, viewXCenter, viewYCenter;
    var hrIterator;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        bg = Toybox.WatchUi.loadResource(Rez.Drawables.bgImage);
        t1 = Toybox.WatchUi.loadResource(Rez.Fonts.t1);
        t2 = Toybox.WatchUi.loadResource(Rez.Fonts.t2);
        f1 = Toybox.WatchUi.loadResource(Rez.Fonts.f1);
        f2 = Toybox.WatchUi.loadResource(Rez.Fonts.f2);

        faceRadius = dc.getWidth() / 2;
        viewWidth = dc.getWidth();
        viewHeight = dc.getHeight();
        viewXCenter = viewWidth / 2;
        viewYCenter = viewHeight / 2;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Draw the background image
        dc.drawBitmap(0, 0, bg);

        // Get the time and other field parameters
        var clockTime = System.getClockTime();
        var hourString = Lang.format("$1$", [clockTime.hour.format("%02d")]);
        var minuteString = Lang.format("$1$", [clockTime.min.format("%02d")]);
        var info = ActivityMonitor.getInfo();

        // Steps
        var steps = info.steps;
        var stepsGoal = info.stepGoal;
        var floorsClimbed = info.floorsClimbed;
        var floorsClimbedGoal = info.floorsClimbedGoal;

        // Date
        var dateString = Lang.format("$1$", [Gregorian.info(Time.now(), Time.FORMAT_MEDIUM).day.toString()]);

        // Draw the seconds (left)
        var angle = (getAngleFromTime(clockTime.sec) - 90);
        var x = getXFromAngle(angle, 40);
        var y = getYFromAngle(angle, 40) - 152;
        dc.setColor(0x1C2833, 0x1C2833);
        dc.fillCircle(x, y, 9);

        // Draw the seconds (right)
        x = getXFromAngle(angle - 180, 40);
        y = getYFromAngle(angle -180, 40) + 152;
        dc.setColor(0xD27628, 0xD27628);
        dc.fillCircle(x, y, 9);

        // Draw the time
        dc.setColor(0x1C2833, Graphics.COLOR_TRANSPARENT);
        dc.drawText(viewXCenter - 100, viewYCenter - 180, t1, hourString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(0xD27628, Graphics.COLOR_TRANSPARENT);
        dc.drawText(viewXCenter + 100, viewYCenter - 60, t1, minuteString, Graphics.TEXT_JUSTIFY_CENTER);

        // Date (top)
        dc.setColor(0xD27628, Graphics.COLOR_TRANSPARENT);
        dc.drawText(viewXCenter, viewYCenter - 165, f2, dateString, Graphics.TEXT_JUSTIFY_CENTER);

        // Heart Rate (bottom)
        hrIterator = ActivityMonitor.getHeartRateHistory(null, true);
        var hr = Activity.getActivityInfo().currentHeartRate;
        if (null != hr) {
            dc.setColor(0x1C2833, Graphics.COLOR_TRANSPARENT);
            dc.drawText(viewXCenter, viewYCenter + 139, f2, hr.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Draw the progressbars
        dc.setColor(0xffffff, 0xffffff);
        // Top-Right
        if(stepsGoal != null) {
            var stepsProgress = (steps * 100 ) / stepsGoal;
            if(stepsProgress != 0) {
                drawProgressCW(dc, stepsProgress, viewXCenter + 142, viewYCenter - 77);
            }
        }
        // Bottom-Left
        if(floorsClimbedGoal != null) {
            var floorsProgress = (floorsClimbed * 100 ) / floorsClimbedGoal;
            if(floorsProgress != 0) {
                drawProgressCCW(dc, floorsProgress, viewXCenter - 138, viewYCenter + 82);
            }
        }

        // Draw the weather
        if(Weather.getCurrentConditions() != null && Weather.getCurrentConditions().feelsLikeTemperature != null) {
            var feelLikeTemperature = Lang.format("$1$ DEG C", [Weather.getCurrentConditions().feelsLikeTemperature.toString()]);
            dc.setColor(0x1C2833, Graphics.COLOR_TRANSPARENT);
            dc.drawText(viewXCenter - 120, viewYCenter - 20, f2, feelLikeTemperature, Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(0xD27628, Graphics.COLOR_TRANSPARENT);
            dc.drawText(viewXCenter + 105, viewYCenter - 20, f2, getFriendlyCondition(Weather.getCurrentConditions().condition), Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    function getFriendlyCondition(condition as Number) {
        if (condition == 0) { 
            return "CLEAR SKIES";
        } 
        else if (condition == 1) { 
            return "KIND'A CLOUDY";
        }
        else if (condition == 2) { 
            return "CLOUDY";
        }
        else if (condition == 3) { 
            return "RAIN";
        }
        else if (condition == 4) { 
            return "SNOW";
        }
        else if (condition == 5) { 
            return "WINDY";
        }
        else if (condition == 6) { 
            return "THUNDERSTORMS";
        }
        else if (condition == 7) { 
            return "WINTRY";
        }
        else if (condition == 8) { 
            return "FOG";
        }
        else if (condition == 9) { 
            return "HAZY";
        }
        else if (condition == 10) { 
            return "HAIL";
        }
        else if (condition == 11) { 
            return "SHOWERS";
        }
        else if (condition == 12) { 
            return "THUNDERSTORMS";
        }
        else if (condition == 13) { 
            return "RAIN";
        }
        else if (condition == 14) { 
            return "KIND'A CLOUDY";
        }
        else if (condition == 15) { 
            return "LIGHT RAIN";
        }
        else if (condition == 16) { 
            return "LIGHT SNOW";
        }
        else if (condition == 17) { 
            return "SNOW!!";
        }
        else if (condition == 18) { 
            return "LIGHT SNOW";
        }
        else if (condition == 19) { 
            return "RAIN!!";
        }
        else if (condition == 20) { 
            return "CLOUDY";
        }
        else if (condition == 21) { 
            return "SNOW";
        }
        else if (condition == 22) { 
            return "KIND'A CLEAR";
        }
        else if (condition == 23) { 
            return "CLEAR";
        }
        else if (condition == 24) { 
            return "LIGHT SHOWERS";
        }
        else if (condition == 25) { 
            return "SHOWERS";
        }
        else if (condition == 26) { 
            return "SHOWERS!!";
        }
        else if (condition == 27) { 
            return "SHOWERS?";
        }
        else if (condition == 28) { 
            return "THUNDERSTORM";
        }
        else if (condition == 29) { 
            return "MIST";
        }
        else if (condition == 30) { 
            return "DUST";
        }
        else if (condition == 31) { 
            return "DRIZZLE";
        }
        else if (condition == 32) { 
            return "TORNADO";
        }
        else if (condition == 33) { 
            return "SMOKE";
        }
        else if (condition == 34) { 
            return "ICE";
        }
        else if (condition == 35) { 
            return "SAND";
        }
        else if (condition == 36) { 
            return "GUSTY";
        }
        else if (condition == 37) { 
            return "SAND STORM";
        }
        else if (condition == 38) { 
            return "VOLCANIC ASH";
        }
        else if (condition == 39) { 
            return "HAZE";
        }
        else if (condition == 40) { 
            return "FAIR";
        }
        else if (condition == 41) { 
            return "HURRICANE";
        }
        else if (condition == 42) { 
            return "TROPICAL STORM";
        }
        else if (condition == 43) { 
            return "SNOW?";
        }
        else if (condition == 44) { 
            return "RAIN?";
        }
        else if (condition == 45) { 
            return "RAIN?";
        }
        else if (condition == 46) { 
            return "SNOW?";
        }
        else if (condition == 47) { 
            return "SNOW?";
        }
        else if (condition == 48) { 
            return "FLURRIES";
        }
        else if (condition == 49) { 
            return "FREEZING RAIN";
        }
        else if (condition == 50) { 
            return "SLEET";
        }
        else if (condition == 51) { 
            return "ICE SNOW";
        }
        else if (condition == 52) { 
            return "THIN CLOUDS";
        }
        else if (condition == 53) { 
            return "UNKNOWN";
        }
        else {
            return "UNKNOWN";
        }
    }

    // Draw the progress as an arc oin clockwise direction. dc is Drawing Context. percentage is the progress in %. X for x-asis. Y for y-axis. 
    function drawProgressCW(dc as Dc, percentage as Number, x as Number, y as Number) {
        var endAngle = ((percentage * 360) / 100);
        var actualEndAngle = 360 - (endAngle - 90);
        dc.setPenWidth(4);
        dc.drawArc(x, y, 25, Graphics.ARC_CLOCKWISE, 90, actualEndAngle);
    }

    // Draw the progress as an arc in counter clockwise direction. dc is Drawing Context. percentage is the progress in %. X for x-asis. Y for y-axis. 
    function drawProgressCCW(dc as Dc, percentage as Number, x as Number, y as Number) {
        var endAngle = ((percentage * 360) / 100);
        var actualEndAngle = 360 - (270 - endAngle);
        dc.setPenWidth(4);
        dc.drawArc(x, y, 25, Graphics.ARC_COUNTER_CLOCKWISE, 90, actualEndAngle);
    }

    // Get the angle from time (val is the sec, min, or hour). 
    function getAngleFromTime(val as Number) {
        return (((val * 360) / 60));
    }

    // Gets the X from the angle in degrees. Radius is the radius of the circle to use to find the angle. 
    function getXFromAngle(angle as Number, raidus as Number) {
        var x = ((raidus) * Math.cos(angle * (Math.PI / 180))) + 209;
        return x;
    }

    // Gets the Y from the angle in degrees. Radius is the radius of the circle to use to find the angle. 
    function getYFromAngle(angle as Number, raidus as Number) {
        var y = ((raidus) * Math.sin(angle * (Math.PI / 180))) + 209;
        return y;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
