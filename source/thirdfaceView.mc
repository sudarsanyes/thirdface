import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

class thirdFaceDelegate extends WatchUi.WatchFaceDelegate {

    function initialize() {
        WatchFaceDelegate.initialize();
    }

    function onPress(clickEvent as WatchUi.ClickEvent) {
        var tapCoordinates = clickEvent.getCoordinates();
        var tapX = tapCoordinates[0];
        var tapY = tapCoordinates[1];
        var tapFlag = true;
        System.println("Requesting an app to launch...");
        System.println(tapX + "  "  + tapY + "  " + tapFlag);
        try {
            if (tapX > 171 && tapX < 246 && tapY > 17 && tapY < 88) {
                System.println("Launching the body battery...");
                var app = new Complications.Id(Complications.COMPLICATION_TYPE_BODY_BATTERY);
                Complications.exitTo(app);
            } else if(tapX > 324 && tapX < 380 && tapY > 109 && tapY < 158) {
                System.println("Launching the steps...");
                var app = new Complications.Id(Complications.COMPLICATION_TYPE_STEPS);
                Complications.exitTo(app);
            } else if(tapX > 41 && tapX < 98 && tapY > 262 && tapY < 318) {
                System.println("Launching the floors climbed...");
                var app = new Complications.Id(Complications.COMPLICATION_TYPE_FLOORS_CLIMBED);
                Complications.exitTo(app);
            } else if(tapX > 171 && tapX < 248 && tapY > 324 && tapY < 398) {
                System.println("Launching heart rate...");
                var app = new Complications.Id(Complications.COMPLICATION_TYPE_HEART_RATE);
                Complications.exitTo(app);
            } else if(tapX > 47 && tapX < 127 && tapY > 193 && tapY < 219) {
                System.println("Launching today's weather...");
                var app = new Complications.Id(Complications.COMPLICATION_TYPE_HIGH_LOW_TEMPERATURE);
                Complications.exitTo(app);
            } else if(tapX > 178 && tapX < 237 && tapY > 184 && tapY < 234) {
                System.println("Launching sun rise and set app...");
                var app = new Complications.Id(Complications.COMPLICATION_TYPE_SUNSET);
                Complications.exitTo(app);
            }  else if(tapX > 243 && tapX < 386 && tapY > 188 && tapY < 209) {
                System.println("Launching weather...");
                var app = new Complications.Id(Complications.COMPLICATION_TYPE_FORECAST_WEATHER_3DAY);
                Complications.exitTo(app);
            } else {
                System.println("No app to lauch!");
            }
        } catch (ex) {
            System.println("Unable to launch the specified app.");
        }

        return true;
    }
}

class thirdfaceView extends WatchUi.WatchFace {

    var bg1, bg2, bg3, bg4, bg5, bg6, bg7, bg8, bg9, bgToUse;
    var color1, color2;
    var phase0, phase1, phase2, phase3, phase4, phase5, phase6, phase7, phase8, phase9;
    var t1, t2, f1, f2;
    var faceRadius, viewWidth, viewHeight, viewXCenter, viewYCenter;
    var hrIterator;
    var calInfo;
    var batt;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        
        bg1 = Toybox.WatchUi.loadResource(Rez.Drawables.bg1);
        bg2 = Toybox.WatchUi.loadResource(Rez.Drawables.bg2);
        bg3 = Toybox.WatchUi.loadResource(Rez.Drawables.bg3);
        bg4 = Toybox.WatchUi.loadResource(Rez.Drawables.bg4);
        bg5 = Toybox.WatchUi.loadResource(Rez.Drawables.bg5);
        bg6 = Toybox.WatchUi.loadResource(Rez.Drawables.bg6);
        bg7 = Toybox.WatchUi.loadResource(Rez.Drawables.bg7);
        bg8 = Toybox.WatchUi.loadResource(Rez.Drawables.bg8);
        bg9 = Toybox.WatchUi.loadResource(Rez.Drawables.bg9);

        t1 = Toybox.WatchUi.loadResource(Rez.Fonts.t1);
        t2 = Toybox.WatchUi.loadResource(Rez.Fonts.t2);
        f1 = Toybox.WatchUi.loadResource(Rez.Fonts.f1);
        f2 = Toybox.WatchUi.loadResource(Rez.Fonts.f2);

        phase0 = Toybox.WatchUi.loadResource(Rez.Drawables.phase0);
        phase1 = Toybox.WatchUi.loadResource(Rez.Drawables.phase1);
        phase2 = Toybox.WatchUi.loadResource(Rez.Drawables.phase2);
        phase3 = Toybox.WatchUi.loadResource(Rez.Drawables.phase3);
        phase4 = Toybox.WatchUi.loadResource(Rez.Drawables.phase4);
        phase5 = Toybox.WatchUi.loadResource(Rez.Drawables.phase5);
        phase6 = Toybox.WatchUi.loadResource(Rez.Drawables.phase6);
        phase7 = Toybox.WatchUi.loadResource(Rez.Drawables.phase7);
        phase8 = Toybox.WatchUi.loadResource(Rez.Drawables.phase8);
        phase9 = Toybox.WatchUi.loadResource(Rez.Drawables.phase9);

        faceRadius = dc.getWidth() / 2;
        viewWidth = dc.getWidth();
        viewHeight = dc.getHeight();
        viewXCenter = viewWidth / 2;
        viewYCenter = viewHeight / 2;

        calInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        batt = System.getSystemStats().battery;
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

        var theme = getApp().getProperty("WatchFaceTheme");
        if(theme == 1) {
            bgToUse = bg1;
            color1 = 0x64413D;
            color2 = 0x74C696;
        } else if(theme == 2) {
            bgToUse = bg2;
            color1 = 0x4D3665;
            color2 = 0xC5C170;
        } else if(theme == 3) {
            bgToUse = bg3;
            color1 = 0x234364;
            color2 = 0xC8894E;
        } else if(theme == 4) {
            bgToUse = bg4;
            color1 = 0x094B34;
            color2 = 0xDE7869;
        } else if(theme == 5) {
            bgToUse = bg5;
            color1 = 0x4B443E;
            color2 = 0x4BBBE0;
        } else if(theme == 6) {
            bgToUse = bg6;
            color1 = 0x090C0A;
            color2 = 0x177870;
        } else if(theme == 7) {
            bgToUse = bg7;
            color1 = 0x090C0A;
            color2 = 0x8D908E;
        } else if(theme == 8) {
            bgToUse = bg8;
            color1 = 0x090C0A;
            color2 = 0x21793B;
        } else if(theme == 9) {
            bgToUse = bg9;
            color1 = 0x090C0A;
            color2 = 0x627935;
        }

        // Draw the background image
        dc.drawBitmap(0, 0, bgToUse);

        // Get the time and other field parameters
        var clockTime = System.getClockTime();
        var hourString = Lang.format("$1$", [clockTime.hour.format("%02d")]);
        var minuteString = Lang.format("$1$", [clockTime.min.format("%02d")]);
        var info = ActivityMonitor.getInfo();

        // Draw the moon
        drawMoon(dc, calInfo.day, calInfo.month, calInfo.year, viewXCenter - 45, viewYCenter - 45);

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
        dc.setColor(color1, color1);
        dc.fillCircle(x, y, 9);

        // Draw the seconds (right)
        x = getXFromAngle(angle - 180, 40);
        y = getYFromAngle(angle -180, 40) + 152;
        dc.setColor(color2, color2);
        dc.fillCircle(x, y, 9);

        // Draw the time
        dc.setColor(color1, Graphics.COLOR_TRANSPARENT);
        dc.drawText(viewXCenter - 100, viewYCenter - 180, t1, hourString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(color2, Graphics.COLOR_TRANSPARENT);
        dc.drawText(viewXCenter + 100, viewYCenter - 60, t1, minuteString, Graphics.TEXT_JUSTIFY_CENTER);

        // Date (top)
        dc.setColor(color2, Graphics.COLOR_TRANSPARENT);
        dc.drawText(viewXCenter, viewYCenter - 165, f2, dateString, Graphics.TEXT_JUSTIFY_CENTER);

        // Heart Rate (bottom)
        hrIterator = ActivityMonitor.getHeartRateHistory(null, true);
        var hr = Activity.getActivityInfo().currentHeartRate;
        if (null != hr) {
            dc.setColor(color1, Graphics.COLOR_TRANSPARENT);
            dc.drawText(viewXCenter, viewYCenter + 139, f2, hr.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Draw the progressbars
        dc.setColor(0xffffff, 0xffffff);
        // Top-Right / Steps
        if(stepsGoal != null) {
            var stepsProgress = (steps * 100 ) / stepsGoal;
            if(stepsProgress != 0) {
                drawProgressCW(dc, stepsProgress, 25, 4, viewXCenter + 142, viewYCenter - 77);
            }
        }
        // Bottom-Left / Steps Climbed
        if(floorsClimbedGoal != null) {
            var floorsProgress = (floorsClimbed * 100 ) / floorsClimbedGoal;
            if(floorsProgress != 0) {
                drawProgressCCW(dc, floorsProgress, 25, 4, viewXCenter - 138, viewYCenter + 82);
            }
        }
        // Draw top / Body Battery
        var bb = null;
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)) {
            bb = Toybox.SensorHistory.getBodyBatteryHistory({});
            if (bb != null) {
                bb = bb.next();
            }
            if (bb != null) {
                bb = bb.data;
            }
        }
        if(bb != null) {
            dc.setColor(color1, -1);
            drawProgressCW(dc, bb, 40, 4, 210, 55);
        }

        // Draw the weather
        if(Weather.getCurrentConditions() != null && Weather.getCurrentConditions().feelsLikeTemperature != null) {
            var feelLikeTemperature = Lang.format("$1$ DEG C", [Weather.getCurrentConditions().feelsLikeTemperature.toString()]);
            dc.setColor(color1, Graphics.COLOR_TRANSPARENT);
            dc.drawText(viewXCenter - 120, viewYCenter - 20, f2, feelLikeTemperature, Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(color2, Graphics.COLOR_TRANSPARENT);
            dc.drawText(viewXCenter + 105, viewYCenter - 20, f2, getFriendlyCondition(Weather.getCurrentConditions().condition), Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Draw the battery bar
        dc.setColor(0x000000, -1);
        dc.setPenWidth(9);
        dc.drawCircle(viewXCenter, viewYCenter, (viewWidth / 2));
        dc.setColor(0xffffff, -1);
        drawProgressCW(dc, batt, (viewWidth / 2), 9, viewXCenter, viewYCenter);
    }

    function getJulianDate(d as Number, m as Number, y as Number) { 
        var mm, yy;
        var k1, k2, k3;
        var j;

        yy = y - ((12 - m) / 10);
        mm = m + 9;
        if (mm >= 12) {
            mm = mm - 12;
        }
        k1 = (365.25 * (yy + 4712));
        k2 = (30.6001 * mm + 0.5);
        k3 = (((yy / 100) + 49) * 0.75) - 38;
        // 'j' for dates in Julian calendar:
        j = k1 + k2 + d + 59;
        if (j > 2299160) {
            // For Gregorian calendar:
            j = j - k3; // 'j' is the Julian date at 12h UT (Universal Time)
        }
        return j; 
    }

    function getMoonAge(d as Number, m as Number, y as Number) { 
        var j = getJulianDate(d, m, y);
        var ag;
        //Calculate the approximate phase of the moon
        var ip = (j + 4.867) / 29.53059;
        ip = ip - Math.floor(ip); 
        if(ip < 0.5) {
            ag = ip * 29.53059 + 29.53059 / 2;
        } else {
            ag = ip * 29.53059 - 29.53059 / 2;
        } 
        // Moon's age in days
        ag = Math.floor(ag) + 1;
        return ag;
    }

    // Draws a moon using predefined bitmaps (pngs) that matches the age. dc is Dc; dd is today; mm is this month; yy is this year; x is the x pos; y is the y pos; 
    function drawMoon(dc as Dc, dd, mm, yy, x, y) {
		var A = getMoonAge(dd, mm, yy);
        if(A == 1 || A == 2) {
            dc.drawBitmap(x, y, phase0);
        } else if(A == 3 || A == 4 || A == 5 || A == 6) {
            dc.drawBitmap(x, y, phase1);
        } else if(A == 7 || A == 8 || A == 9) {
            dc.drawBitmap(x, y, phase2);
        } else if(A == 10 || A == 11 || A == 12) {
            dc.drawBitmap(x, y, phase3);
        } else if(A == 13 || A == 14 || A == 15) {
            dc.drawBitmap(x, y, phase4);
        } else if(A == 16 || A == 17 || A == 18) {
            dc.drawBitmap(x, y, phase5);
        } else if(A == 19 || A == 20 || A == 21) {
            dc.drawBitmap(x, y, phase6);
        } else if(A == 22 || A == 23 || A == 24) {
            dc.drawBitmap(x, y, phase7);
        } else if(A == 25 || A == 26 || A == 27) {
            dc.drawBitmap(x, y, phase8);
        } else if(A == 28 || A == 29 || A == 30) {
            dc.drawBitmap(x, y, phase9);
        }
	}

    // Draws a moon as vector that matches the age. dc is Dc; dd is today; mm is this month; yy is this year; x is the x pos; y is the y pos; 
    function drawMoonAsVector(dc as Dc, dd, mm, yy, x, y) {
		var A = getMoonAge(dd, mm, yy);
        if (false) { 
            A = 29.53 - A; 
        }
		var w = 30;
		var F = 14.765, Q = F/2.0, Q2 = F+Q;
		
		var s=A<F ? 0:180;
		dc.setPenWidth(w);
        dc.setColor(0xFFFFFF, -1);
		dc.drawArc(x, y, w/2, Graphics.ARC_CLOCKWISE, 270+s, 90+s);
		var p = w/Q*(A>F ? A-F:A);
        p = w - p;
		var c = A<Q||A>Q2? 0:0xFFFFFF;
		dc.setPenWidth(2);
        dc.setColor(c, -1);
		dc.fillEllipse(x, y, p.abs(), w);
		dc.setColor(0xFFFFFF, -1);
		dc.drawCircle(x, y, w);
    }

    // Gets the forecast condition in a friendlier way. 
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

    // Draw the progress as an arc oin clockwise direction. dc is Drawing Context. percentage is the progress in %. Radius of the arc. pen as Pen Width. X for x-asis. Y for y-axis. 
    function drawProgressCW(dc as Dc, percentage as Number, rad as Number, pen as Number, x as Number, y as Number) {
        var endAngle = ((percentage * 360) / 100);
        var actualEndAngle = 360 - (endAngle - 90);
        dc.setPenWidth(pen);
        dc.drawArc(x, y, rad, Graphics.ARC_CLOCKWISE, 90, actualEndAngle);
    }

    // Draw the progress as an arc in counter clockwise direction. dc is Drawing Context. percentage is the progress in %. Radius of the arc. pen as Pen Width. X for x-asis. Y for y-axis. 
    function drawProgressCCW(dc as Dc, percentage as Number, rad as Number, pen as Number, x as Number, y as Number) {
        var endAngle = ((percentage * 360) / 100);
        var actualEndAngle = 360 - (270 - endAngle);
        dc.setPenWidth(pen);
        dc.drawArc(x, y, rad, Graphics.ARC_COUNTER_CLOCKWISE, 90, actualEndAngle);
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
