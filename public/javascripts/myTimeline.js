var Mytimeline

var theme = Timeline.ClassicTheme.create(); // create the theme
            theme.event.bubble.width = 350;   // modify it
            theme.event.bubble.height = 300;
            theme.event.track.height = 15;
            theme.event.tape.height = 4;
			theme.event.impreciseOpacity = 80;
			theme.event.tape.impreciseOpacity = 80;
			theme.impreciseOpacity = 80;

function setupTimeline(timeline_data_url) {
   var eventSource = new Timeline.DefaultEventSource();
   var bandInfos = [
	   Timeline.createBandInfo({
	       eventSource:    eventSource,
	       date:           "Jan 28 2009 00:00:00 GMT",
	       width:          "80%",
           theme:          theme, 
	       intervalUnit:   Timeline.DateTime.HOUR, 
	       intervalPixels: 500
	   }),
     Timeline.createBandInfo({
         eventSource:    eventSource,
         date:           "Jan 28 2009 00:00:00 GMT",
         width:          "10%",
         theme:          theme,
         intervalUnit:   Timeline.DateTime.DAY, 
         intervalPixels: 100
     }),
     Timeline.createBandInfo({
         eventSource:    eventSource,
         date:           "Jan 28 2009 00:00:00 GMT",
         width:          "10%", 
         theme:          theme,
         intervalUnit:   Timeline.DateTime.MONTH, 
         intervalPixels: 50
     }),
   ];


   bandInfos[1].syncWith = 0;
   bandInfos[1].highlight = true;
   bandInfos[2].syncWith = 1;
   bandInfos[2].highlight = true;
   Mytimeline = Timeline.create(document.getElementById("my_timeline"), bandInfos);
   Timeline.loadXML(timeline_data_url, function(xml, url) { eventSource.loadXML(xml, url); });
}

Timeline.OriginalEventPainter.prototype._showBubble = function(x, y, evt) {
    document.location.href=evt.getLink();
}

function to_time(date) {
    Mytimeline.getBand(0).setCenterVisibleDate(Timeline.DateTime.parseGregorianDateTime(date)); 
}

