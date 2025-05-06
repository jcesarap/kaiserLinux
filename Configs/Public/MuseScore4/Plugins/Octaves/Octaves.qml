import QtQuick 2.2
import MuseScore 3.0

MuseScore {
   version: "4.0"
   description: "Octaves"
   title: "Octaves"
   thumbnailName: "note_names.png"
   
      // Small note name size is a fraction of the full font size.
      property real fontSizeMini: 0.7;
   
      function renderOctaves(notes, text) {
         var sep = "\n";   // change to "," if you want them horizontally (anybody?)
         for (var i = 0; i < notes.length; i++) {
            if (!notes[i].visible)
               continue; // skip invisible notes
            if (text.text) // only if text isn't empty
               text.text = sep + text.text;
            var oct = (Math.floor(notes[i].pitch / 12) - 1);
            text.text = oct + text.text;
         }
      }
   
      function renderGraceOctaves(cursor, list, text) {
         if (list.length > 0) {     // Check for existence.
            // Now render grace note's octaves...
            for (var chordNum = 0; chordNum < list.length; chordNum++) {
               var chord = list[chordNum];
               renderOctaves(chord.notes, text);
               if (text.text)
                  cursor.add(text);
               text = newElement(Element.STAFF_TEXT); // Make another STAFF_TEXT
            }
         }
         return text;
      }
   
      onRun: {
         curScore.startCmd();
   
         var cursor = curScore.newCursor();
         var startStaff;
         var endStaff;
         var endTick;
         var fullScore = false;
         cursor.rewind(1);
         if (!cursor.segment) { // no selection
            fullScore = true;
            startStaff = 0; // start with 1st staff
            endStaff  = curScore.nstaves - 1; // and end with last
         } else {
            startStaff = cursor.staffIdx;
            cursor.rewind(2);
            if (cursor.tick === 0) {
               endTick = curScore.lastSegment.tick + 1;
            } else {
               endTick = cursor.tick;
            }
            endStaff = cursor.staffIdx;
         }
   
         for (var staff = startStaff; staff <= endStaff; staff++) {
            for (var voice = 0; voice < 4; voice++) {
               cursor.rewind(1); // beginning of selection
               cursor.voice    = voice;
               cursor.staffIdx = staff;
   
               if (fullScore)  // no selection
                  cursor.rewind(0); // beginning of score
               while (cursor.segment && (fullScore || cursor.tick < endTick)) {
                  if (cursor.element && cursor.element.type === Element.CHORD) {
                     var text = newElement(Element.STAFF_TEXT); // Make a STAFF_TEXT
                     var graceChords = cursor.element.graceNotes;
                     var leadingLifo = [];
                     var trailingFifo = [];
   
                     if (graceChords.length > 0) {
                        for (var chordNum = 0; chordNum < graceChords.length; chordNum++) {
                           var noteType = graceChords[chordNum].notes[0].noteType;
                           if (noteType === NoteType.GRACE8_AFTER || noteType === NoteType.GRACE16_AFTER ||
                                 noteType === NoteType.GRACE32_AFTER) {
                              trailingFifo.unshift(graceChords[chordNum]);
                           } else {
                              leadingLifo.push(graceChords[chordNum]);
                           }
                        }
                     }
   
                     // Process the leading grace notes, should they exist...
                     renderGraceOctaves(cursor, leadingLifo, text);
   
                     // Process the main chord octaves...
                     renderOctaves(cursor.element.notes, text);
                     if (text.text)
                        cursor.add(text);
   
                     if (text.text)
                        text = newElement(Element.STAFF_TEXT); // Make another STAFF_TEXT object
   
                     // Process trailing grace notes if they exist...
                     renderGraceOctaves(cursor, trailingFifo, text);
                  }
                  cursor.next();
               }
            }
         }
   
         curScore.endCmd();
         quit();
      }
   }
   