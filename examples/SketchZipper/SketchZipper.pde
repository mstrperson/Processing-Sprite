/**
 * SketchZipper
 *
 * Lists the sketches in your Processing sketchbook. Click a sketch, then
 * click "Save to Zip" to put a .zip copy of it on your Desktop, ready to
 * upload to Canvas.
 */

import java.io.*;
import java.util.*;
import java.util.zip.*;

// Layout
final int MARGIN = 20;
final int ROW_H = 28;
final int LIST_TOP = 70;
final int BUTTON_W = 160;
final int BUTTON_H = 40;

File sketchbook;            // where the sketches live
File desktop;               // where the zip goes
File[] sketches = new File[0];
int selected = -1;          // index into sketches, -1 = nothing chosen
int scroll = 0;             // first visible row

String status = "Choose a sketch, then click Save to Zip.";
boolean busy = false;       // true while a zip is being written

void setup() {
  size(600, 520);
  surface.setTitle("Sketch Zipper");
  textFont(createFont("SansSerif", 15));

  sketchbook = findSketchbook();
  desktop = findDesktop();
  sketches = listSketches(sketchbook);

  if (sketches.length == 0) {
    status = "No sketches found in " + sketchbook.getAbsolutePath();
  }
}

void draw() {
  background(245);

  // Header
  fill(30);
  textAlign(LEFT, TOP);
  textSize(20);
  text("Pick a sketch to zip", MARGIN, MARGIN);
  textSize(12);
  fill(110);
  text(sketchbook.getAbsolutePath(), MARGIN, MARGIN + 28);
  textSize(15);

  drawList();
  drawButton();

  // Status line
  fill(60);
  textAlign(LEFT, CENTER);
  text(status, MARGIN, height - MARGIN - BUTTON_H / 2, width - BUTTON_W - 3 * MARGIN, BUTTON_H);
}

// ---------------------------------------------------------------- drawing

void drawList() {
  int listH = listHeight();
  int rows = visibleRows();

  fill(255);
  stroke(200);
  rect(MARGIN, LIST_TOP, width - 2 * MARGIN, listH);
  noStroke();

  for (int i = 0; i < rows && scroll + i < sketches.length; i++) {
    int index = scroll + i;
    int y = LIST_TOP + i * ROW_H;

    if (index == selected) {
      fill(60, 120, 220);
      rect(MARGIN + 1, y + 1, width - 2 * MARGIN - 1, ROW_H - 1);
      fill(255);
    } else if (overRow(i)) {
      fill(230, 238, 252);
      rect(MARGIN + 1, y + 1, width - 2 * MARGIN - 1, ROW_H - 1);
      fill(30);
    } else {
      fill(30);
    }

    textAlign(LEFT, CENTER);
    text(sketches[index].getName(), MARGIN + 10, y + ROW_H / 2);
  }

  // A thin scroll indicator when the list is longer than the box
  if (sketches.length > rows) {
    float barH = listH * rows / (float) sketches.length;
    float barY = LIST_TOP + listH * scroll / (float) sketches.length;
    fill(180);
    rect(width - MARGIN - 6, barY, 4, barH, 2);
  }
}

void drawButton() {
  boolean enabled = selected >= 0 && !busy;
  int x = width - MARGIN - BUTTON_W;
  int y = height - MARGIN - BUTTON_H;

  if (!enabled) fill(190);
  else if (overButton()) fill(40, 150, 80);
  else fill(50, 170, 90);
  rect(x, y, BUTTON_W, BUTTON_H, 8);

  fill(255);
  textAlign(CENTER, CENTER);
  text(busy ? "Zipping..." : "Save to Zip", x + BUTTON_W / 2, y + BUTTON_H / 2);
}

// ---------------------------------------------------------------- input

void mousePressed() {
  if (busy) return;

  for (int i = 0; i < visibleRows(); i++) {
    if (overRow(i) && scroll + i < sketches.length) {
      selected = scroll + i;
      status = "Ready to zip \"" + sketches[selected].getName() + "\".";
      return;
    }
  }

  if (overButton() && selected >= 0) {
    busy = true;
    status = "Zipping...";
    thread("zipSelected");   // run in the background so the window stays responsive
  }
}

void mouseWheel(MouseEvent event) {
  int maxScroll = max(0, sketches.length - visibleRows());
  scroll = constrain(scroll + event.getCount(), 0, maxScroll);
}

boolean overRow(int row) {
  int y = LIST_TOP + row * ROW_H;
  return mouseX > MARGIN && mouseX < width - MARGIN && mouseY >= y && mouseY < y + ROW_H;
}

boolean overButton() {
  int x = width - MARGIN - BUTTON_W;
  int y = height - MARGIN - BUTTON_H;
  return mouseX > x && mouseX < x + BUTTON_W && mouseY > y && mouseY < y + BUTTON_H;
}

int listHeight() {
  return height - LIST_TOP - BUTTON_H - 2 * MARGIN;
}

int visibleRows() {
  return listHeight() / ROW_H;
}

// ---------------------------------------------------------------- zipping

// Called by thread("zipSelected") from mousePressed.
void zipSelected() {
  File folder = sketches[selected];
  File zipFile = uniqueFile(desktop, folder.getName(), ".zip");

  try {
    ZipOutputStream zip = new ZipOutputStream(new FileOutputStream(zipFile));
    // Put everything under the sketch's own folder name so it unzips as a
    // complete sketch folder that Processing can open.
    addToZip(zip, folder, folder.getName() + "/");
    zip.close();
    status = "Saved " + zipFile.getName() + " to your Desktop.";
  }
  catch (IOException e) {
    zipFile.delete();
    status = "Could not create the zip: " + e.getMessage();
  }

  busy = false;
}

void addToZip(ZipOutputStream zip, File folder, String path) throws IOException {
  zip.putNextEntry(new ZipEntry(path));   // the folder itself (keeps empty folders)
  zip.closeEntry();

  File[] children = folder.listFiles();
  if (children == null) return;

  byte[] buffer = new byte[8192];
  for (File child : children) {
    String name = child.getName();
    if (name.equals(".DS_Store") || name.equals("Thumbs.db")) continue;

    if (child.isDirectory()) {
      addToZip(zip, child, path + name + "/");
    } else {
      zip.putNextEntry(new ZipEntry(path + name));
      FileInputStream in = new FileInputStream(child);
      int n;
      while ((n = in.read(buffer)) > 0) {
        zip.write(buffer, 0, n);
      }
      in.close();
      zip.closeEntry();
    }
  }
}

// Returns Name.zip, or Name (2).zip, Name (3).zip... so an earlier zip is
// never overwritten.
File uniqueFile(File dir, String base, String ext) {
  File f = new File(dir, base + ext);
  int n = 2;
  while (f.exists()) {
    f = new File(dir, base + " (" + n + ")" + ext);
    n++;
  }
  return f;
}

// ---------------------------------------------------------------- finding folders

// A sketch is any folder in the sketchbook that has at least one .pde file.
File[] listSketches(File dir) {
  ArrayList<File> found = new ArrayList<File>();
  File[] children = dir.listFiles();
  if (children != null) {
    for (File child : children) {
      if (child.isDirectory() && hasPdeFile(child)) {
        found.add(child);
      }
    }
  }
  Collections.sort(found, new Comparator<File>() {
    public int compare(File a, File b) {
      return a.getName().compareToIgnoreCase(b.getName());
    }
  });
  return found.toArray(new File[0]);
}

boolean hasPdeFile(File dir) {
  File[] files = dir.listFiles();
  if (files == null) return false;
  for (File f : files) {
    if (f.getName().toLowerCase().endsWith(".pde")) return true;
  }
  return false;
}

// Reads the sketchbook location from Processing's preferences, so a student
// who moved their sketchbook still sees the right folder. Falls back to the
// default location if the preferences can't be read.
File findSketchbook() {
  String home = System.getProperty("user.home");
  String os = System.getProperty("os.name").toLowerCase();

  File prefs;
  if (os.contains("mac")) {
    prefs = new File(home, "Library/Processing/preferences.txt");
  } else if (os.contains("win")) {
    prefs = new File(System.getenv("APPDATA"), "Processing/preferences.txt");
  } else {
    prefs = new File(home, ".config/processing/preferences.txt");
  }

  if (prefs.exists()) {
    String[] lines = loadStrings(prefs.getAbsolutePath());
    for (String line : lines) {
      // Processing 4 uses sketchbook.path.four; older versions use sketchbook.path
      if (line.startsWith("sketchbook.path.four=") || line.startsWith("sketchbook.path=")) {
        File dir = new File(line.substring(line.indexOf('=') + 1).trim());
        if (dir.isDirectory()) return dir;
      }
    }
  }

  if (os.contains("mac") || os.contains("win")) {
    return new File(home, "Documents/Processing");
  }
  return new File(home, "sketchbook");
}

// On Windows, OneDrive often moves the Desktop into the OneDrive folder.
File findDesktop() {
  String home = System.getProperty("user.home");
  File oneDrive = new File(home, "OneDrive/Desktop");
  if (System.getProperty("os.name").toLowerCase().contains("win") && oneDrive.isDirectory()) {
    return oneDrive;
  }
  return new File(home, "Desktop");
}
